local windows = require( "celautomata.windows" );
local M = {};

M.celautomata = function()
   windows.init_window();
end;

M.setup = function( opts )
   vim.api.nvim_set_keymap( "n", "<leader><BS>", "", { callback = M.celautomata } );
end;

return M;
