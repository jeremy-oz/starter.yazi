# starter.yazi

A minimal, working [Yazi](https://yazi-rs.github.io) plugin to build on. It shows a notification
describing the hovered file, demonstrates `setup` options, argument parsing, and `ya.sync`.

Requires Yazi `25.2.13` or newer.

## Install

```sh
ya pkg add jeremy-oz/starter
```

This clones the repo into `~/.config/yazi/plugins/starter.yazi` and records it in
`~/.config/yazi/package.toml`. On a new machine, `ya pkg install` restores everything
listed there. Upgrade with `ya pkg upgrade`.

## Usage

Bind a key in `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on   = [ "g", "s" ]
run  = "plugin starter"
desc = "Describe the hovered file"

# Pass arguments after `--`:
[[mgr.prepend_keymap]]
on   = [ "g", "S" ]
run  = "plugin starter -- --level=warn"
desc = "Same, as a warning"
```

Optional configuration in `~/.config/yazi/init.lua`:

```lua
require("starter"):setup {
	greeting = "Howdy",
}
```

## Develop

Clone this repo directly into your plugins directory so edits apply immediately:

```sh
git clone git@github.com:jeremy-oz/starter.yazi.git ~/.config/yazi/plugins/starter.yazi
```

Yazi reloads plugins on each invocation, so there is no restart step. Debug with
`ya.dbg(...)` and `ya.err(...)`, then read `~/.local/state/yazi/yazi.log` after
starting Yazi with `YAZI_LOG=debug yazi`.

Key API points used here (see the [plugin docs](https://yazi-rs.github.io/docs/plugins/overview/)):

- `entry(self, job)` runs async. `job.args` holds positional args and `--flag` / `--key=value` options.
- `setup(state, opts)` runs sync from `init.lua`. `state` is the plugin's persistent table.
- `ya.sync(fn)` runs `fn` on the main thread with access to `state` and `cx`. Define it at file top level.
- `ya.notify { title, content, level, timeout }` shows a toast.
- `ya.emit("cmd", { args })` dispatches a Yazi command.

## Renaming

To turn this into your own plugin named `foo`: rename the repo to `foo.yazi`, replace
`starter` with `foo` in this README and in `main.lua` comments, then install with
`ya pkg add <you>/foo`.

## License

MIT
