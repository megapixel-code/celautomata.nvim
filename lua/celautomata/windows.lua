local GLOBAL = require( "celautomata.global" );

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

   local extmarks_val, inspect_vals, hl_groups_values, hl, char;

   for y = 1, win.nlines do
      GLOBAL.CONSTANTS.grid[y] = {};
      for x = 1, win.ncols do
         hl, hl_groups_values = {}, {};
         inspect_vals         = vim.inspect_pos( 0, win.first_col + y - 1, x - 1 );
         extmarks_val         = inspect_vals.extmarks[1] or {};
         table.insert( hl_groups_values, inspect_vals.treesitter );
         table.insert( hl_groups_values, inspect_vals.syntax );
         table.insert( hl_groups_values, { extmarks_val.opts } );
         for _, group in ipairs( hl_groups_values ) do
            for _, value in ipairs( group ) do
               table.insert( hl, value.hl_group );
            end;
         end;

         char = vim.fn.strcharpart( lines[y] or "", x - 1, 1 );
         if (char == "") then char = " "; end;

         GLOBAL.CONSTANTS.grid[y][x] = { char = char, hl = hl };
      end;
   end;
end;

M._populate_vars = function()
   local val;
   for _, opt in ipairs( GLOBAL.DEFAULTS.relevant_win_opts ) do
      val = vim.api.nvim_get_option_value( opt, { win = 0 } );
      table.insert( GLOBAL.DEFAULTS.additional_nvim_opts.win, { opt, val } );
   end;
   GLOBAL.CONSTANTS.plugin.namespace = vim.api.nvim_create_namespace( GLOBAL.CONSTANTS.plugin.name );
   M._populate_grid();
end;

M._close_win = function()
   if (GLOBAL.CONSTANTS.plugin.win == nil) then return; end;

   vim.api.nvim_buf_delete( GLOBAL.CONSTANTS.plugin.buf, { force = true } );
   GLOBAL.CONSTANTS.plugin.win = nil;
   GLOBAL.CONSTANTS.plugin.buf = nil;
   GLOBAL.CONSTANTS.plugin.continue = false;
end;

M._setup_win_closing = function()
   vim.api.nvim_create_autocmd( { "WinLeave", "BufLeave" }, {
      group = vim.api.nvim_create_augroup( GLOBAL.CONSTANTS.plugin.name .. "-WINCLOSING", { clear = true } ),
      buffer = GLOBAL.CONSTANTS.plugin.buf,
      callback = function()
         M._close_win();
      end,
      once = true,
   } );

   -- TODO: add keymap config opt
   vim.api.nvim_buf_set_keymap( GLOBAL.CONSTANTS.plugin.buf, "n", "<Esc>", "", {
      callback = function()
         M._close_win();
      end,
   } );
end;

M._set_additional_nvim_opts = function()
   -- FIXME: offset when lines in buffer over 100
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
   vim.api.nvim_set_current_buf( GLOBAL.CONSTANTS.plugin.buf );

   GLOBAL.CONSTANTS.plugin.win = vim.api.nvim_get_current_win();
   M._set_additional_nvim_opts();
   M._setup_win_closing();
end;

return M;
