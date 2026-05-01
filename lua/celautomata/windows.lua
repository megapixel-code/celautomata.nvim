local GLOBAL = require( "celautomata.constants" );

local M = {};

M._populate_grid = function()
   local win = {
      first_col = vim.fn.line( "w0" ) - 1,
      ncols = vim.api.nvim_win_get_width( 0 ),
      nlines = vim.api.nvim_win_get_height( 0 ),
   };

   local lines = vim.api.nvim_buf_get_lines( 0, win.first_col, win.first_col + win.nlines, false );
   local tab_replacement = string.rep( " ", vim.o.tabstop );
   for i, l in ipairs( lines ) do
      lines[i], _ = string.gsub( l, "\t", tab_replacement );
   end;

   local treesitter_values, hl, char;

   for x = 1, win.ncols do
      GLOBAL.CONSTANTS.grid[x] = {};
      for y = 1, win.nlines do
         treesitter_values = vim.inspect_pos( 0, y - 1, x - 1 ).treesitter[1] or { hl_group = "" };
         hl = treesitter_values.hl_group;

         char = vim.fn.strcharpart( lines[y], x, 1 );

         GLOBAL.CONSTANTS.grid[x][y] = { char = char, hl = hl };
      end;
   end;
end;

M._populate_vars = function()
   local val;
   for _, opt in ipairs( GLOBAL.DEFAULTS.relevant_win_opts ) do
      val = vim.api.nvim_get_option_value( opt, { win = 0 } );
      table.insert( GLOBAL.DEFAULTS.additional_nvim_opts.win, { opt, val } );
   end;
   M._populate_grid();
end;

M._close_win = function()
   if (GLOBAL.CONSTANTS.plugin.win == nil) then return; end;
   vim.api.nvim_win_close( GLOBAL.CONSTANTS.plugin.win, true );
   GLOBAL.CONSTANTS.plugin.win = nil;
   GLOBAL.CONSTANTS.plugin.id = nil;
end;

M._setup_win_closing = function()
   vim.api.nvim_create_autocmd( { "WinLeave", "BufLeave" }, {
      group = vim.api.nvim_create_augroup( "celautomata" .. "-WINCLOSING", { clear = true } ),
      buffer = GLOBAL.CONSTANTS.plugin.buf,
      callback = function()
         M._close_win();
      end,
      once = true,
   } );

   -- TODO: add keymap config opt
   vim.api.nvim_buf_set_keymap( GLOBAL.CONSTANTS.plugin.buf, "n", "<Esc>", "", {
      callback = function()
         vim.api.nvim_buf_del_keymap( GLOBAL.CONSTANTS.plugin.buf, "n", "<Esc>" );
         vim.print( "kdasjf" );
         M._close_win();
      end,
   } );
end;

M._set_additional_nvim_opts = function()
   for _, opt in ipairs( GLOBAL.DEFAULTS.additional_nvim_opts.buf ) do
      vim.api.nvim_set_option_value( opt[1], opt[2], { buf = GLOBAL.CONSTANTS.plugin.buf } );
   end;
   for _, opt in ipairs( GLOBAL.DEFAULTS.additional_nvim_opts.win ) do
      vim.api.nvim_set_option_value( opt[1], opt[2], { win = GLOBAL.CONSTANTS.plugin.win, scope = "local" } );
   end;
end;

M.init_window = function()
   M._populate_vars();
   GLOBAL.CONSTANTS.plugin.buf = vim.api.nvim_create_buf( false, true );
   GLOBAL.CONSTANTS.plugin.win = vim.api.nvim_set_current_buf( GLOBAL.CONSTANTS.plugin.buf );
   M._set_additional_nvim_opts();
   M._setup_win_closing();


   -- TODO:
   -- vim.print( grid );
   -- vim.fn.nr2char(10)
end;

return M;
