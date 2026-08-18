import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const ASK_USER_BLOCKED_EVENT = "rpiv:ask-user:blocked";

export default function (pi: ExtensionAPI) {
	pi.events.on(ASK_USER_BLOCKED_EVENT, (data) => {
		const active = (data as { active?: unknown } | undefined)?.active;
		if (typeof active !== "boolean") return;

		pi.events.emit("herdr:blocked", {
			active,
			...(active ? { label: "Waiting for user response" } : {}),
		});
	});
}
