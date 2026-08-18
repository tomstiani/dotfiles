import { readFileSync } from "node:fs";
import { basename, dirname, join, resolve } from "node:path";
import { getAgentDir, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

type Pattern = string | { pattern: string; replace?: string; flags?: string };
type Rule = { filePattern: string | string[]; cloakPattern: Pattern | Pattern[]; replace?: string };
type Config = { enabled?: boolean; patterns?: Rule[] };
type CompiledRule = { paths: RegExp[]; patterns: Array<{ regex: RegExp; replace?: string }> };
type State = { config: Config; rules: CompiledRule[]; error?: string };

const CONFIG = join(getAgentDir(), "cloak.json");
const DEFAULT: Config = { enabled: true, patterns: [] };

function array<T>(value: T | T[]): T[] {
  return Array.isArray(value) ? value : [value];
}

function escapeRegex(value: string): string {
  return value.replace(/[|\\{}()[\]^$+?.]/g, "\\$&");
}

function globRegex(glob: string): RegExp {
  let result = "^";
  for (let i = 0; i < glob.length; i++) {
    const char = glob[i];
    const next = glob[i + 1];
    if (char === "*" && next === "*") {
      result += glob[i + 2] === "/" ? "(?:.*/)?" : ".*";
      i += glob[i + 2] === "/" ? 2 : 1;
    } else if (char === "*") {
      result += "[^/]*";
    } else if (char === "?") {
      result += "[^/]";
    } else {
      result += escapeRegex(char ?? "");
    }
  }
  return new RegExp(`${result}$`);
}

function compilePattern(pattern: Pattern, ruleReplace?: string) {
  if (typeof pattern === "string") return { regex: new RegExp(pattern, "g"), replace: ruleReplace };
  const flags = pattern.flags?.includes("g") ? pattern.flags : `${pattern.flags ?? ""}g`;
  return { regex: new RegExp(pattern.pattern, flags), replace: pattern.replace ?? ruleReplace };
}

function compileRules(config: Config): CompiledRule[] {
  return (config.patterns ?? []).map((rule) => ({
    paths: array(rule.filePattern).map(globRegex),
    patterns: array(rule.cloakPattern).map((pattern) => compilePattern(pattern, rule.replace)),
  }));
}

function candidates(rawPath: string, cwd: string): string[] {
  const path = rawPath.startsWith("@") ? rawPath.slice(1) : rawPath;
  const absolute = resolve(cwd, path.startsWith("~/") ? path.replace("~/", `${process.env.HOME}/`) : path);
  return [...new Set([path, absolute, basename(path), basename(absolute), dirname(path)])];
}

function matches(rule: CompiledRule, rawPath: string, cwd: string): boolean {
  return candidates(rawPath, cwd).some((path) => rule.paths.some((pattern) => pattern.test(path)));
}

export function cloakText(text: string, rawPath: string, cwd: string, state: State): string {
  if (state.config.enabled === false) return text;
  const rules = state.rules.filter((rule) => matches(rule, rawPath, cwd));
  return rules.reduce(
    (result, rule) => rule.patterns.reduce(
      (current, pattern) => current.replace(pattern.regex, pattern.replace ?? "*"),
      result,
    ),
    text,
  );
}

function loadState(): State {
  try {
    const config = { ...DEFAULT, ...(JSON.parse(readFileSync(CONFIG, "utf8")) as Config) };
    return { config, rules: compileRules(config) };
  } catch (error) {
    return {
      config: DEFAULT,
      rules: [],
      error: `${CONFIG}: ${error instanceof Error ? error.message : String(error)}`,
    };
  }
}

export default function piCloak(pi: ExtensionAPI) {
  let state = loadState();
  const reload = () => { state = loadState(); };

  pi.on("session_start", async (_event, ctx) => {
    reload();
    if (state.error && ctx.hasUI) ctx.ui.notify(`pi-cloak: ${state.error}`, "warning");
  });

  pi.registerCommand("cloak-status", {
    description: "Show pi-cloak status",
    handler: async (_args, ctx) => {
      reload();
      ctx.ui.notify(
        state.error ?? `pi-cloak ${state.config.enabled === false ? "disabled" : "enabled"}; ${state.rules.length} rules`,
        state.error ? "warning" : "info",
      );
    },
  });

  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "read" || state.config.enabled === false) return;
    const input = event.input as { path?: unknown };
    if (typeof input.path !== "string") return;

    let changed = false;
    const content = event.content.map((part) => {
      if (part.type !== "text") return part;
      const text = cloakText(part.text, input.path!, ctx.cwd, state);
      if (text === part.text) return part;
      changed = true;
      return { ...part, text };
    });
    return changed ? { content } : undefined;
  });
}
