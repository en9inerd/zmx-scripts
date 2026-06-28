# Dev Workflow Guide

Personal guide for the zmx + ghostty setup. Covers concepts, daily patterns, and what to do after a reboot.

---

## Concepts

Understanding the mental model first makes everything else obvious.

| Concept | What it is |
|---------|------------|
| **zmx session** | A persistent shell process with a name and working directory. Survives disconnects; does not survive a full reboot. |
| **ghostty tab** | A viewport into a zmx session (or a plain shell if not attached to one). |
| **ghostty split** | An extra shell inside a tab. Not persistent — splits die when the tab closes. |
| **zmx-workspace project** | A named collection of sessions defined in a config file. One command to recreate all sessions after a reboot. |

If you know tmux: a workspace project ≈ tmux session, a zmx session ≈ tmux window, a ghostty split ≈ tmux pane.

---

## Setup (one-time per machine)

### Install

1. Install deps: [zmx](https://github.com/neurosnap/zmx), fzf, fd, ghostty
2. Run the installer:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/en9inerd/zmx-scripts/master/install.sh | bash
   ```
3. Add to `~/.config/ghostty/config` (adjust keybinds to your preference):
   ```ghostty
   keybind = ctrl+b>f=text:zmx-sessionizer\n
   keybind = ctrl+b>w=text:zmx-workspace attach\n
   keybind = ctrl+b>x=text:zmx kill $ZMX_SESSION\n
   keybind = ctrl+b>shift+x=text:zmx-sessionizer kill\n
   ```
4. Add to `~/.zshrc`:
   ```zsh
   source <(zmx completions zsh)
   alias zws='zmx-workspace'
   alias zs='zmx-sessionizer'
   ```

### Extras

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
# ZMX_SEARCH_PATHS=(~/Development ~/Work:2)  # :N = max depth override per path
# ZMX_MAX_DEPTH=1
```

---

## Project Setup (one-time per project)

From any shell, run:

```bash
zws new
```

Follow the prompts:

```
project name: myapp
directory (empty for fzf picker) [/current/dir]: /path/to/myapp
sessions -- format: name:command  (bare shell: name:)  empty line to finish
  session> editor:nvim .
  session> server:npm start
  session> shell:
  session>
```

Then bring the project up:

```bash
zws open myapp     # create all sessions
zws attach myapp   # or just press ctrl+b w
```

Config saved to `~/.config/zmx-sessionizer/workspaces/myapp.conf`. Edit anytime with `zws edit myapp`.

---

## Daily Use

### Sessions already alive

```
ctrl+b f  →  pick session from [ZMX] list  →  attached
```

### Session picker behavior

| Selection | What happens |
|-----------|--------------|
| `[ZMX] name  pid:N  clients:N  /dir` | Attach to existing session |
| `[here] /path` | Create session in the current directory |
| `/path/to/dir` from search list | Create session in that directory |
| Type name + Enter (no match) | Create a floating named session (no dir) |
| Esc | Cancel |

### Splits (not persisted)

Splits open in the current tab and inherit its working directory. They close when the tab closes.

```
Cmd+D        horizontal split
Cmd+Shift+D  vertical split
```

---

## After Reboot

Sessions don't survive a full reboot.

**Managed project** — one command to restore:
```bash
zws open myapp
# ctrl+b w to attach each session
```

**Multiple projects:**
```bash
zws open myapp
zws open myapp2
# ctrl+b w to attach
```

**Ad-hoc sessions** (created directly via the picker, no `zws` config) — no automatic restore. Either recreate them by picking dirs in the session picker, or convert to a managed project with `zws new`.

---

## Reference

### Commands

```bash
zws new              # create project config interactively
zws open [project]   # start all sessions for a project
zws attach [project] # fzf pick from all sessions; lazy-creates missing ones
zws list             # list all projects with active/total session counts
zws edit [project]   # open project config in $EDITOR
zws kill [project]   # kill all sessions for a project
zws delete [project] # kill all sessions and remove the project config
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
