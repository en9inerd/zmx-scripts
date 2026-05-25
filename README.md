# zmx-scripts

fzf-driven session picker and project workspace manager for [zmx](https://github.com/neurosnap/zmx), integrated as ghostty's tab launcher.

## Requirements

- [zmx](https://github.com/neurosnap/zmx)
- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd)
- ghostty

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/en9inerd/zmx-scripts/master/install.sh | bash
```

Downloads scripts to `~/.local/bin/` and copies example config.

## ghostty config

Add to `~/.config/ghostty/config`:

```ini
command = ~/.local/bin/zmx-sessionizer

keybind = ctrl+b>f=new_tab
keybind = ctrl+b>w=text:zmx-workspace attach\n
keybind = ctrl+b>x=text:zmx kill $ZMX_SESSION\n
keybind = ctrl+b>shift+x=text:zws kill-session\n
```

## zshrc

Append to `~/.zshrc`:

```zsh
alias zws='zmx-workspace'
alias zs='zmx-sessionizer'

source <(zmx completions zsh)

_zmx_title() { [[ -n "$ZMX_SESSION" ]] && printf '\e]0;%s\a' "$ZMX_SESSION"; }
precmd_functions+=(_zmx_title)
```

`precmd_functions+=` must be last in `.zshrc` to win the tab title race over ghostty/fzf/fnm hooks.

## sessionizer config

Edit `~/.config/zmx-sessionizer/zmx-sessionizer.conf`:

```bash
TS_SEARCH_PATHS=(~/Development)
# TS_EXTRA_SEARCH_PATHS=(~/Work:3)
# TS_MAX_DEPTH=2
```

## Usage

### zmx-workspace

```bash
zws new              # create project (name + dir + sessions)
zws open [project]   # start all sessions for project
zws attach [project] # fzf pick and attach (also ctrl+b w)
zws list             # all projects with session counts
zws kill [project]   # kill all project sessions
zws kill-session     # fzf pick and kill any single session
zws status           # all active zmx sessions
```

Project config format (`~/.config/zmx-workspace/<name>.conf`):

```bash
ZMX_DIR=/path/to/project
ZMX_SESSIONS=(
    "nvim:nvim ."
    "server:npm run dev"
    "shell:"
)
```

### Keybinds

| Key            | Action                        |
|----------------|-------------------------------|
| ctrl+b f       | new tab, session picker       |
| ctrl+b w       | project session picker        |
| ctrl+b x       | kill current session          |
| ctrl+b X       | fzf pick and kill any session |

