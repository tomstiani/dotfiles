import type { ExtensionAPI, ExtensionUIContext } from "@earendil-works/pi-coding-agent";

const ASK_USER_BLOCKED_EVENT = "rpiv:ask-user:blocked";
const WRAPPED = Symbol.for("herdr.hitl-ui-wrapped");

export default function (pi: ExtensionAPI) {
	const report = (active: boolean) => pi.events.emit("herdr:blocked", {
		active,
		...(active ? { label: "Waiting for user response" } : {}),
	});

	pi.events.on(ASK_USER_BLOCKED_EVENT, (data) => {
		const active = (data as { active?: unknown } | undefined)?.active;
		if (typeof active === "boolean") report(active);
	});

	pi.on("session_start", (_event, ctx) => {
		const ui = ctx.ui as ExtensionUIContext & { [WRAPPED]?: boolean };
		if (ui[WRAPPED]) return;
		ui[WRAPPED] = true;

		const wrap = <T extends (...args: never[]) => Promise<unknown>>(method: T): T =>
			(async (...args: Parameters<T>) => {
				report(true);
				try {
					return await method(...args);
				} finally {
					report(false);
				}
			}) as T;

		ui.select = wrap(ui.select.bind(ui));
		ui.confirm = wrap(ui.confirm.bind(ui));
		ui.input = wrap(ui.input.bind(ui));
		ui.editor = wrap(ui.editor.bind(ui));
	});
}
