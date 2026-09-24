local M = {}

local data_path = vim.fn.stdpath("data") .. "/mini-harpoon.json"
local marks = {}

local function get_project_root()
	local root = vim.fs.root(0, { ".git", "package.json", "go.mod", "Cargo.toml" })
	return root or vim.fn.getcwd()
end

function load()
	local f = io.open(data_path, "r")
	if not f then
		return
	end

	local content = f:read("a")
	f:close()

	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		return
	end

	if not type(data) == "table" then
		return
	end

	marks = data
end

local function save()
	local f = io.open(data_path, "w")
	if not f then
		return
	end

	f:write(vim.json.encode(marks))
	f:close()
end

local function get_list()
	local root = get_project_root()
	marks[root] = marks[root] or {}

	return marks[root]
end

function M.add()
	local list = get_list()
	local path = vim.fn.expand("%:p")
	if path == "" then
		return
	end

	for _, p in ipairs(list) do
		if p == path then
			vim.notify("Already in list", vim.log.levels.INFO)
			return
		end
	end

	table.insert(list, path)
	save()
end

function M.select(idx)
	local list = get_list()
	local path = list[idx]
	if not path then
		return
	end

	local ok, err = pcall(vim.cmd.edit, vim.fn.fnameescape(path))
	if not ok then
		vim.notify("Error opening file: " .. tostring(err), vim.log.levels.WARN)
	end
end

function M.menu()
	local root = get_project_root()
	local list = get_list()

	local display_lines = {}
	for _, full_path in ipairs(list) do
		table.insert(display_lines, vim.fn.fnamemodify(full_path, ":~:."))
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].buftype = "acwrite"
	vim.bo[buf].filetype = "harpoon"
	pcall(vim.api.nvim_buf_set_name, buf, "mini-harpoon-menu-" .. buf)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_lines)

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.4)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " Harpoon ",
		title_pos = "center",
	})

	local function sync_buffer_to_marks()
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local updated_list = {}

		for _, line in ipairs(lines) do
			local trimmed = vim.trim(line)
			if trimmed ~= "" then
				local full_path = vim.fn.fnamemodify(trimmed, ":p")
				table.insert(updated_list, full_path)
			end
		end

		marks[root] = updated_list
		save()
	end

	local function close_win()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.keymap.set("n", "<CR>", function()
		local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
		sync_buffer_to_marks()
		close_win()
		M.select(cursor_line)
	end, { buffer = buf, silent = true })

	vim.api.nvim_create_autocmd("BufWriteCmd", {
		buffer = buf,
		callback = function()
			sync_buffer_to_marks()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.bo[buf].modified = false
			end
		end,
	})

	vim.keymap.set("n", "<Esc>", function()
		sync_buffer_to_marks()
		close_win()
	end, { buffer = buf, silent = true })

	vim.keymap.set("n", "q", function()
		sync_buffer_to_marks()
		close_win()
	end, { buffer = buf, silent = true })
end

load()

return M
