import { execFile } from "node:child_process";
import { promises as fs } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join, relative, resolve } from "node:path";
import { promisify } from "node:util";
import { getAgentDir, type ExtensionAPI, type ExtensionCommandContext } from "@earendil-works/pi-coding-agent";

const execFileAsync = promisify(execFile);
type Skill = { name: string; file: string; manualOnly: boolean };

function roots(cwd: string): string[] {
  return [...new Set([
    join(getAgentDir(), "skills"),
    join(homedir(), ".agents", "skills"),
    resolve(cwd, ".pi/skills"),
    resolve(cwd, ".agents/skills"),
  ])];
}

async function findSkills(root: string, result: string[]): Promise<void> {
  let entries;
  try {
    entries = await fs.readdir(root, { withFileTypes: true });
  } catch {
    return;
  }
  for (const entry of entries) {
    const path = join(root, entry.name);
    if (entry.isDirectory()) await findSkills(path, result);
    else if (entry.name === "SKILL.md") result.push(path);
  }
}

function readSkill(file: string, raw: string): Skill {
  const frontmatter = /^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/.exec(raw)?.[1] ?? "";
  const name = /^name:\s*(.+)$/m.exec(frontmatter)?.[1]?.trim().replace(/^['"]|['"]$/g, "") ?? basename(dirname(file));
  return { name, file, manualOnly: /^disable-model-invocation:\s*true\s*$/im.test(frontmatter) };
}

function toggle(raw: string, manualOnly: boolean): string {
  const eol = raw.includes("\r\n") ? "\r\n" : "\n";
  const match = /^---\r?\n([\s\S]*?)\r?\n---(\r?\n|$)/.exec(raw);
  if (!match) return manualOnly ? `---${eol}disable-model-invocation: true${eol}---${eol}${raw}` : raw;

  let frontmatter = match[1] ?? "";
  if (/^disable-model-invocation:\s*.+$/im.test(frontmatter)) {
    frontmatter = frontmatter.replace(/^disable-model-invocation:\s*.+$/im, `disable-model-invocation: ${manualOnly}`);
  } else if (manualOnly) {
    frontmatter += `${frontmatter.endsWith(eol) ? "" : eol}disable-model-invocation: true${eol}`;
  }
  const body = raw.slice(match[0].length);
  return `---${eol}${frontmatter.endsWith(eol) ? frontmatter : frontmatter + eol}---${match[2] ?? ""}${body}`;
}

async function atomicWrite(file: string, content: string): Promise<void> {
  const temp = `${file}.${process.pid}.tmp`;
  try {
    await fs.writeFile(temp, content, "utf8");
    await fs.rename(temp, file);
  } finally {
    await fs.rm(temp, { force: true });
  }
}

async function managedSource(file: string): Promise<string | undefined> {
  try {
    const { stdout } = await execFileAsync("chezmoi", ["source-path", file]);
    const source = stdout.trim();
    return source && resolve(source) !== resolve(file) ? source : undefined;
  } catch {
    return undefined;
  }
}

async function applyManaged(file: string): Promise<void> {
  await execFileAsync("chezmoi", ["apply", "--verbose", file], { maxBuffer: 10 * 1024 * 1024 });
}

async function toggleSkills(ctx: ExtensionCommandContext): Promise<void> {
  if (!ctx.hasUI) {
    ctx.ui.notify("/toggle-skills requires interactive mode", "error");
    return;
  }

  const files: string[] = [];
  for (const root of roots(ctx.cwd)) await findSkills(root, files);
  const skills = await Promise.all(files.sort().map(async (file) => readSkill(file, await fs.readFile(file, "utf8"))));
  if (skills.length === 0) {
    ctx.ui.notify("No skills found", "info");
    return;
  }

  const labels = skills.map((skill) => `${skill.manualOnly ? "manual-only" : "agent-invocable"}: ${skill.name} (${relative(ctx.cwd, skill.file)})`);
  const selected = await ctx.ui.select("Toggle skill", labels);
  if (!selected) return;
  const index = labels.indexOf(selected);
  const skill = skills[index];
  if (!skill) return;

  const nextManualOnly = !skill.manualOnly;
  if (!await ctx.ui.confirm("Toggle skill?", `${skill.name} → ${nextManualOnly ? "manual-only" : "agent-invocable"}`)) return;

  const source = await managedSource(skill.file);
  const target = source ?? skill.file;
  await atomicWrite(target, toggle(await fs.readFile(target, "utf8"), nextManualOnly));
  if (source) await applyManaged(skill.file);
  ctx.ui.notify(`${skill.name}: ${nextManualOnly ? "manual-only" : "agent-invocable"}`, "info");
  await ctx.reload();
}

export default function toggleSkillsExtension(pi: ExtensionAPI) {
  pi.registerCommand("toggle-skills", {
    description: "Toggle whether skills are agent-invocable or manual-only",
    handler: async (_args, ctx) => {
      try {
        await toggleSkills(ctx);
      } catch (error) {
        ctx.ui.notify(`toggle-skills failed: ${error instanceof Error ? error.message : String(error)}`, "error");
      }
    },
  });
}
