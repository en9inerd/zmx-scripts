# zmx-scripts

fzf-driven session picker and project workspace manager for [zmx](https://github.com/neurosnap/zmx), integrated with ghostty.

## Requirements

- [zmx](https://github.com/neurosnap/zmx)
- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd)
- ghostty

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/en9inerd/zmx-scripts/master/install.sh | bash
```

Downloads scripts to `~/.local/bin/` and copies example config to `~/.config/zmx-sessionizer/`.

Add to `~/.zshrc`:

```zsh
source <(zmx completions zsh)
```

## Setup

Add to `~/.config/ghostty/config` (adjust keybinds to your preference):

```ghostty
keybind = ctrl+b>f=text:zmx-sessionizer\n
keybind = ctrl+b>w=text:zmx-workspace attach\n
keybind = ctrl+b>x=text:zmx kill $ZMX_SESSION\n
keybind = ctrl+b>shift+x=text:zmx-sessionizer kill\n
```

Add to `~/.zshrc`:

```zsh
alias zws='zmx-workspace'
alias zs='zmx-sessionizer'
```

---

## Usage

### zmx-sessionizer

`ctrl+b f` opens a session picker in the current tab.

| Selection | What happens |
|-----------|--------------|
| `[ZMX] name  pid:N  clients:N  /dir` | Attach to existing session |
| `[here] /path` | Create session in the current directory |
| `/path/to/dir` from search list | Create session in that directory |
| Type name + Enter (no match) | Create a floating named session (no dir) |

### zmx-workspace

```bash
zws new              # create project config interactively (name + dir + sessions)
zws open [project]   # start all sessions for a project
zws attach [project] # fzf pick from all sessions across all projects; lazy-creates missing ones
zws list             # list all projects with active/total session counts
zws edit [project]   # open project config in $EDITOR
zws kill [project]   # kill all sessions for a project
zws delete [project] # kill all sessions and remove the project config
```

Project config lives at `~/.config/zmx-sessionizer/workspaces/<name>.conf`:

```bash
ZMX_DIR=/path/to/project
ZMX_SESSIONS=(
    "editor:nvim ."
    "server:npm start"
    "shell:"
)
```

### Keybinds

| Key      | Action                                    |
|----------|-------------------------------------------|
| ctrl+b f | Session picker (fzf)                      |
| ctrl+b w | Session picker across all projects (fzf)  |
| ctrl+b x | Kill current session                      |
| ctrl+b X | fzf pick and kill any session             |
| ctrl+\   | Detach from session (leaves it running)   |
| Cmd+T    | New tab (plain shell)                     |

---

## Extras

**ghostty** — shell integration and directory inheritance for new tabs:

```ghostty
shell-integration-features=no-cursor,no-sudo,ssh-terminfo,ssh-env
window-inherit-working-directory = true
```

**~/.zshrc** — tab title management:

```zsh
# Inside zmx sessions: disable ghostty's built-in title hooks so zmx owns the tab title.
[[ -n "$ZMX_SESSION" ]] && GHOSTTY_SHELL_FEATURES=${(j:,:)${(s:,:)GHOSTTY_SHELL_FEATURES:#title}}
_zmx_title() { [[ -n "$ZMX_SESSION" ]] && printf '\e]0;%s\a' "$ZMX_SESSION"; }
precmd_functions+=(_zmx_title)  # keep this last in .zshrc
```

**~/.config/zmx-sessionizer/zmx-sessionizer.conf** — where the session picker looks for projects:

```bash
ZMX_SEARCH_PATHS=(~/Development)
# ZMX_SEARCH_PATHS=(~/Development ~/Work:2)  # multiple paths; :N = max depth override
# ZMX_MAX_DEPTH=1
```
