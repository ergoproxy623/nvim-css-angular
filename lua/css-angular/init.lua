local M = {}

local source = require("css-angular.source")
local externals = require("css-angular.externals")
local extractor = require("css-angular.extractor")
local ss = require("css-angular.style_sheets")
local internal = require("css-angular.internal")
local config = require("css-angular.config").config

local source_name = "css-angular"

vim.print("inti css")

---@type string[]
local enable_on_dto = {}

if config.enable_on ~= nil then
  for _, ext in pairs(config.enable_on) do
    table.insert(enable_on_dto, "*." .. ext)
  end
end

function M:setup()
	require("cmp").register_source(source_name, source)

	if config.style_sheets ~= nil and #config.style_sheets ~= 0 then
		ss.init(config.style_sheets)
	end

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre", "WinEnter" }, {
		pattern = enable_on_dto,
		callback = function(event)
			local hrefs = extractor.href(config.style_sheets)
			externals.init(event.buf, hrefs)
			internal.init(event.buf, event.file)
		end,
	})
end

return M
