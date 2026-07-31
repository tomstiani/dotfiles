# ─── History ──────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_DUPS        # Don't record duplicate consecutive commands
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries from history
setopt HIST_IGNORE_SPACE       # Don't record commands starting with a space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicates to the history file
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks from commands
setopt HIST_VERIFY             # Show expanded history before executing
setopt SHARE_HISTORY           # Share history across all sessions in real time
setopt EXTENDED_HISTORY        # Save timestamp and duration with each entry

# ─── Navigation ───────────────────────────────────────────────────────────────
setopt AUTO_CD                 # Type a directory name to cd into it
setopt AUTO_PUSHD              # cd pushes old directory onto the stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicates onto the stack
setopt PUSHD_SILENT            # Don't print directory stack after pushd/popd
setopt CDABLE_VARS             # cd into variables that hold directory paths

# ─── Globbing ─────────────────────────────────────────────────────────────────
setopt EXTENDED_GLOB           # Extended glob patterns (^, ~, #)
setopt GLOB_DOTS               # Include dotfiles in glob patterns
setopt NO_CASE_GLOB            # Case-insensitive globbing
setopt NULL_GLOB               # Silently ignore failed globs instead of erroring
setopt MAGIC_EQUAL_SUBST       # Filename completion after = (e.g. --file=<TAB>)

# ─── Misc ─────────────────────────────────────────────────────────────────────
setopt CORRECT                 # Suggest corrections for mistyped commands
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shell
setopt NO_BEEP                 # Silence all bells/beeps
setopt NO_FLOW_CONTROL         # Disable ctrl-s / ctrl-q flow control
setopt COMBINING_CHARS         # Handle Unicode combining characters

# Better word boundaries (stop at slashes, etc.)
WORDCHARS=${WORDCHARS//[\/=]}

# ─── Vi mode ──────────────────────────────────────────────────────────────────
bindkey -v
