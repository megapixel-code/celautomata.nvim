local run = require( "celautomata.run" );

local M = {};

M.celautomata = function()
   -- TODO: animation names
   run.start_animation( "conways_game_of_life" );
end;

M.setup = function( opts )
   vim.api.nvim_set_keymap( "n", "<leader><BS>", "", { callback = M.celautomata } );
end;

return M;
