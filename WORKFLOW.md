# Dev Workflow Guide

Ghostty handles tabs and splits. zmx handles session persistence.

zmx session = one persistent shell. ghostty tab = viewport into a session. ghostty split = extra shell in the same tab, not persisted.

## Concepts

| tmux                  | zmx equivalent              |
|-----------------------|-----------------------------|
| session (with windows)| zmx-workspace project       |
| window                | zmx session (e.g. pac-nvim) |
| pane                  | ghostty split (not persisted)|

## Daily Use

New tab (Cmd+T or ctrl+b f) opens fzf picker:

- `[here] /path` - create session in current directory
- `[ZMX] name  pid:N  clients:N  /dir` - attach existing session
- `/path/to/dir` - create session there
- type name + Enter (no match) - create named session
- Ctrl-N + typed name - create named session without a directory
- Esc - plain shell, no session

Splits (Cmd+D / Cmd+Shift+D) inherit the working directory of the current pane. Use for quick parallel work within the same context.

Detach with ctrl+\ to leave a session running in the background.

## Project Setup

One-time per project:

```bash
zws new
```

```
project name: pac
directory (empty for fzf picker) [/current/dir]: /Users/enginerd/Development/pac
sessions -- format: name:command  (bare shell: name:)  empty line to finish
  session> nvim:nvim .
  session> shell:
  session>
```

Session format: `name:command`. Bare shell: `name:` with no command.

Config saved to `~/.config/zmx-workspace/pac.conf`. Edit with `zws edit pac`.

## Project Workflow

```bash
zws open pac         # create all sessions
zws attach pac       # fzf pick and attach a session (also ctrl+b w)
zws list             # all projects with active/total session counts
zws status           # all active zmx sessions
zws kill pac         # kill all sessions for project
zws kill-session     # fzf pick and kill any single session
```

Open one tab per session, attach a different session in each.

## After Reboot

zmx sessions don't survive a full reboot. Recreate:

```bash
zws open pac
```

Then open tabs and attach each session.

## Typical Day

```bash
# morning
zws open pac

# open tabs and attach
# tab 1: zws attach pac -> pick pac-nvim
# tab 2: zws attach pac -> pick pac-shell

# new tab opens session picker automatically

# end of day: sessions stay alive, no need to kill
# after reboot: zws open pac again
```
