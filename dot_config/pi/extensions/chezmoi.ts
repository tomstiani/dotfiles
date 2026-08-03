import assert from "node:assert/strict";
import { execFile } from "node:child_process";
import os from "node:os";
import path from "node:path";
import { promisify } from "node:util";
import { StringEnum } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const execFileAsync = promisify(execFile);
const MUTATING = new Set(["apply", "add", "forget"]);
const ACTIONS = ["status", "diff", "apply", "add", "forget", "managed", "source-path", "cat", "data", "doctor"] as const;

const ChezmoiParams = Type.Object({
	action: StringEnum(ACTIONS),
	path: Type.Optional(Type.String({ description: "Optional target path, e.g. ~/.zshrc or dot_zshrc" })),
	dryRun: Type.Optional(Type.Boolean({ description: "For apply only. Defaults to true." })),
	args: Type.Optional(Type.Array(Type.String({ description: "Extra chezmoi flags/args. Avoid unless needed." }))),
});

type Action = (typeof ACTIONS)[number];
type Params = { action: Action; path?: string; dryRun?: boolean; args?: string[] };

function buildArgs(params: Params) {
	const args = [params.action.replace("_", "-")];
	if (params.action === "apply" && params.dryRun !== false) args.push("--dry-run", "--verbose");
	if (params.path) args.push(params.path);
	if (params.args?.length) args.push(...params.args);
	return args;
}

async function runChezmoi(args: string[], signal?: AbortSignal) {
	try {
		const { stdout, stderr } = await execFileAsync("chezmoi", args, { signal, maxBuffer: 10 * 1024 * 1024 });
		return [stdout, stderr].filter(Boolean).join("\n") || "OK";
	} catch (error) {
		const err = error as Error & { stdout?: string; stderr?: string; code?: number };
		const output = [err.stdout, err.stderr, err.message].filter(Boolean).join("\n");
		return `chezmoi ${args.join(" ")} failed${err.code !== undefined ? ` (${err.code})` : ""}:\n${output}`;
	}
}

async function getChezmoiPath(args: string[], signal?: AbortSignal) {
	try {
		const { stdout } = await execFileAsync("chezmoi", args, { signal });
		return stdout.trim();
	} catch {
		return undefined;
	}
}

function resolveToolPath(file: string, cwd: string) {
	const expanded = file === "~" || file.startsWith("~/") ? path.join(os.homedir(), file.slice(2)) : file;
	return path.resolve(cwd, expanded);
}

function isInside(parent: string, child: string) {
	const rel = path.relative(parent, child);
	return rel === "" || (!!rel && !rel.startsWith("..") && !path.isAbsolute(rel));
}

function managedTargetMessageFromPaths(target: string, sourceRoot?: string, source?: string) {
	if (sourceRoot && isInside(sourceRoot, target)) return undefined;
	if (!source) return undefined;
	return `Blocked: ${target} is managed by chezmoi. Edit the source file instead:\n${source}`;
}

async function managedTargetMessage(file: string, cwd: string, signal?: AbortSignal) {
	const target = resolveToolPath(file, cwd);
	const sourceRoot = await getChezmoiPath(["source-path"], signal);
	const source = sourceRoot && isInside(sourceRoot, target) ? undefined : await getChezmoiPath(["source-path", target], signal);
	return managedTargetMessageFromPaths(target, sourceRoot, source);
}

async function confirmMutation(params: Params, ctx: ExtensionContext) {
	if (!MUTATING.has(params.action)) return true;
	if (params.action === "apply" && params.dryRun !== false) return true;
	if (!ctx.hasUI) return false;
	return ctx.ui.confirm("Run chezmoi?", `chezmoi ${buildArgs(params).join(" ")}`);
}

function splitArgs(input: string) {
	return input.match(/(?:[^\s"']+|"[^"]*"|'[^']*')+/g)?.map((s) => s.replace(/^(["'])(.*)\1$/, "$2")) ?? [];
}

function buildCommandArgs(input: string) {
	const args = splitArgs(input.trim());
	if (args.length === 0) args.push("status");
	const execute = args.indexOf("--execute");
	if (execute !== -1) args.splice(execute, 1);
	if (args[0] === "apply" && execute === -1 && !args.includes("--dry-run")) args.push("--dry-run", "--verbose");
	return args;
}

function selfTest() {
	assert.deepEqual(buildArgs({ action: "apply" }), ["apply", "--dry-run", "--verbose"]);
	assert.deepEqual(buildArgs({ action: "apply", dryRun: false, path: "~/.zshrc" }), ["apply", "~/.zshrc"]);
	assert.deepEqual(splitArgs('diff "~/.zshrc" --reverse'), ["diff", "~/.zshrc", "--reverse"]);
	assert.deepEqual(buildCommandArgs(""), ["status"]);
	assert.deepEqual(buildCommandArgs("apply"), ["apply", "--dry-run", "--verbose"]);
	assert.deepEqual(buildCommandArgs("apply --execute"), ["apply"]);

	assert.equal(isInside("/a/b", "/a/b/c"), true);
	assert.equal(isInside("/a/b", "/a/bc"), false);

	const sourceRoot = "/home/me/.local/share/chezmoi";
	assert.equal(managedTargetMessageFromPaths(`${sourceRoot}/dot_zshrc`, sourceRoot, "/ignored"), undefined);
	assert.match(
		managedTargetMessageFromPaths("/home/me/.zshrc", sourceRoot, `${sourceRoot}/dot_zshrc`) ?? "",
		/Edit the source file instead:\n\/home\/me\/\.local\/share\/chezmoi\/dot_zshrc/,
	);
	assert.equal(managedTargetMessageFromPaths("/home/me/.vimrc", sourceRoot), undefined);
}

if (process.env.CHEZMOI_EXTENSION_SELF_TEST === "1") selfTest();

export default function chezmoiExtension(pi: ExtensionAPI) {
	pi.on("before_agent_start", async (event) => ({
		systemPrompt:
			event.systemPrompt +
			"\n\nChezmoi dotfiles: prefer the `chezmoi` tool for inspecting status/diffs/source paths. Edit chezmoi source files, not managed destination files. `apply` defaults to dry-run; set dryRun=false only after confirming intent.",
	}));

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "edit" && event.toolName !== "write") return;
		const input = event.input as { path?: string };
		if (!input.path) return;

		const reason = await managedTargetMessage(input.path, ctx.cwd, ctx.signal);
		if (reason) return { block: true, reason };
	});

	pi.registerTool({
		name: "chezmoi",
		label: "chezmoi",
		description: "Run common chezmoi dotfile-manager commands safely: status, diff, dry-run apply, add, forget, managed, source-path, cat, data, doctor.",
		parameters: ChezmoiParams,
		async execute(_toolCallId, params: Params, signal, _onUpdate, ctx) {
			if (!(await confirmMutation(params, ctx))) {
				return { content: [{ type: "text", text: "Blocked: mutating chezmoi command was not confirmed." }], details: { blocked: true } };
			}

			const args = buildArgs(params);
			const text = await runChezmoi(args, signal);
			return { content: [{ type: "text", text }], details: { command: ["chezmoi", ...args] } };
		},
	});

	pi.registerCommand("chezmoi", {
		description: "Run chezmoi (default: status). Apply is dry-run unless you pass --execute.",
		getArgumentCompletions: (prefix) => ACTIONS.filter((a) => a.startsWith(prefix)).map((value) => ({ value, label: value })),
		handler: async (input, ctx) => {
			const args = buildCommandArgs(input);
			if (MUTATING.has(args[0]) && !(args[0] === "apply" && args.includes("--dry-run"))) {
				const ok = await ctx.ui.confirm("Run chezmoi?", `chezmoi ${args.join(" ")}`);
				if (!ok) return;
			}
			ctx.ui.notify(await runChezmoi(args), "info");
		},
	});
}
