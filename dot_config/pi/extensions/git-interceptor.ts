import { isToolCallEventType, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const GIT_RE = /\bgit(?:\s|$)/;
const NO_VERIFY_RE = /(?:^|\s)--no-verify(?:\s|$)/;
const GIT_ENV = "export GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true GIT_MERGE_AUTOEDIT=no\n";

export default function gitInterceptor(pi: ExtensionAPI) {
  pi.on("tool_call", (event) => {
    if (!isToolCallEventType("bash", event) || !GIT_RE.test(event.input.command)) return;
    if (NO_VERIFY_RE.test(event.input.command)) {
      return {
        block: true,
        reason: "Blocked: --no-verify bypasses repository hooks. Fix the hook failure instead.",
      };
    }
    event.input.command = GIT_ENV + event.input.command;
  });
}
