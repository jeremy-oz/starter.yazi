--- @since 25.2.13
-- starter.yazi — a minimal, working Yazi plugin to build on.
--
-- Install:   ya pkg add jeremy-oz/starter
-- Keymap:    run = "plugin starter"            (see README for args)
-- Setup:     require("starter"):setup { greeting = "Hi" }   (optional, in init.lua)

-- `ya.sync` wraps a function so it runs on the main (sync) thread, where the
-- shared plugin `state` and the UI context `cx` are available. Must be defined
-- at the top level of the file.
local get_hovered = ya.sync(function(state)
	local h = cx.active.current.hovered
	return {
		greeting = state.greeting or "Hello",
		name = h and tostring(h.name) or nil,
		url = h and tostring(h.url) or nil,
		is_dir = h and h.cha.is_dir or false,
		cwd = tostring(cx.active.current.cwd),
	}
end)

return {
	-- Called from init.lua: require("starter"):setup { ... }
	-- Runs in a sync context; `state` persists for the life of the Yazi process.
	setup = function(state, opts)
		opts = opts or {}
		state.greeting = opts.greeting or "Hello"
	end,

	-- Called when a key bound to `plugin starter [-- args]` is pressed.
	-- Runs in an async context, so blocking calls (ya.input, fs.*, Command) are OK here.
	--
	-- job.args[1]       first positional arg      (plugin starter -- foo)
	-- job.args.flag     true for --flag           (plugin starter -- --flag)
	-- job.args.key      "v" for --key=v           (plugin starter -- --key=v)
	entry = function(_, job)
		local info = get_hovered()
		local level = job.args.level or "info"

		if not info.name then
			ya.notify { title = "starter", content = "Nothing hovered in " .. info.cwd, level = "warn", timeout = 3 }
			return
		end

		local kind = info.is_dir and "directory" or "file"
		ya.notify {
			title = "starter",
			content = string.format("%s! Hovered %s: %s", info.greeting, kind, info.name),
			level = level,
			timeout = 4,
		}

		-- Example of dispatching a Yazi command from a plugin:
		-- ya.emit("reveal", { info.url })
	end,
}
