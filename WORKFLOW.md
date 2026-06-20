# Dev Workflow Guide

Ghostty handles tabs and splits. zmx handles session persistence. zmx-scripts wire them together.

zmx session = one persistent shell process. ghostty tab = viewport into a session. ghostty split = extra shell in the same tab, not persisted.

---

## Setup (one-time per machine)

1. Install deps: [zmx](https://github.com/neurosnap/zmx), fzf, fd, ghostty
2. Run installer:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/en9inerd/zmx-scripts/master/install.sh | bash
   ```
3. Add to `~/.config/ghostty/config`:
   ```ini
   shell-integration-features=no-cursor,no-sudo,ssh-terminfo,ssh-env
   window-inherit-working-directory = true
   keybind = ctrl+b>f=text:zmx-sessionizer\n
   keybind = ctrl+b>w=text:zmx-workspace attach\n
   keybind = ctrl+b>x=text:zmx kill $ZMX_SESSION\n
   keybind = ctrl+b>shift+x=text:zws kill-session\n
   ```
4. Add to `~/.zshrc`:
   ```zsh
   alias zws='zmx-workspace'
   alias zs='zmx-sessionizer'
   source <(zmx completions zsh)
   [[ -n "$ZMX_SESSION" ]] && GHOSTTY_SHELL_FEATURES=${(j:,:)${(s:,:)GHOSTTY_SHELL_FEATURES:#title}}
   _zmx_title() { [[ -n "$ZMX_SESSION" ]] && printf '\e]0;%s\a' "$ZMX_SESSION"; }
   precmd_functions+=(_zmx_title)
   ```
5. Edit `~/.config/zmx-sessionizer/zmx-sessionizer.conf` to set search paths:
   ```bash
   ZMX_SEARCH_PATHS=(~/Development)
   ```

---

## Bootstrap

New tabs open a plain shell. Run `zws` commands directly.

---

## Project Setup (one-time per project)

From any shell (Esc at picker, or another terminal):

```bash
zws new
```

```
project name: myapp
directory (empty for fzf picker) [/current/dir]: /path/to/myapp
sessions -- format: name:command  (bare shell: name:)  empty line to finish
  e.g.:
    editor:nvim .
    server:npm start
    shell:
  session> editor:nvim .
  session> shell:
  session>
```

Then create sessions and attach:

```bash
zws open myapp
zws attach myapp   # or ctrl+b w
```

Config saved to `~/.config/zmx-sessionizer/workspaces/myapp.conf`. Edit with `zws edit myapp`.

---

## Session Picker

`ctrl+b f` opens the session picker in the current tab.

| What you do | Result |
|---|---|
| Pick `[ZMX] name  pid:N  clients:N  /dir` | Attach existing session |
| Pick `[here] /path` | Create session in current directory, named by dirname |
| Pick `/path/to/dir` from list | Create session in that directory, named by dirname |
| Type name + `Enter` (no match in list) | Create named floating session (no dir) |
| `Esc` | Plain shell, no session |

---

## Concepts

| tmux                  | zmx equivalent                  |
|-----------------------|---------------------------------|
| session (with windows)| zmx-workspace project           |
| window                | zmx session (e.g. myapp-editor) |
| pane                  | ghostty split (not persisted)   |

---

## Working

**Splits** (not persisted, inherit current dir):
```
Cmd+D          horizontal split
Cmd+Shift+D    vertical split
```

**Tab title** shows the current session name automatically.

---

## Keybinds

| Key | Action |
|---|---|
| `Cmd+T` | New tab (plain shell) |
| `ctrl+b f` | Session picker (fzf) |
| `ctrl+b w` | Session picker — all projects (fzf) |
| `ctrl+b x` | Kill current session |
| `ctrl+b X` | fzf pick and kill any session |
| `ctrl+\` | Detach from session (leaves it running) |

---

## Project Management

```bash
zws new              # create project config (interactive)
zws open [project]   # create all sessions for project
zws attach [project] # fzf pick — flat list of all sessions across all projects, lazy-creates if missing
zws list             # all projects with active/total session counts
zws edit [project]   # edit project config in $EDITOR
zws kill [project]   # kill all sessions for project
zws kill-session     # fzf pick and kill any single session
zws delete [project] # kill all sessions and remove project config
```

---

## After Reboot

zmx sessions do not survive a full reboot.

**Managed project** - one command to restore:
```bash
zws open myapp
zws attach myapp   # or ctrl+b w
```

**Ad-hoc sessions** (created directly via picker, no `zws` config) - no automatic restore. Recreate manually by picking dirs in the session picker, or convert to a managed project with `zws new`.

---

## Typical Day

**Sessions alive (no reboot):**
```
ctrl+b f -> pick session from [ZMX] list -> attach
```

**After reboot (managed project):**
```bash
zws open myapp
# ctrl+b w -> pick myapp-editor
# ctrl+b w -> pick myapp-shell
```

**After reboot (multiple projects):**
```bash
zws open myapp
zws open myapp2
# ctrl+b w to attach each
```

**Quick one-off dir** (no config needed):
```
ctrl+b f -> pick dir from list -> session created
```

**Scratch session:**
```
ctrl+b f -> type name -> Enter (no match) -> floating session
```
