local windows = require( "celautomata.windows" );
local GLOBAL = require( "celautomata.global" );

local M = {};

M._display_frame = function()
   local lines = {};
   local line;

   for y, _ in ipairs( GLOBAL.CONSTANTS.grid ) do
      line = {};
      for x, vals in ipairs( GLOBAL.CONSTANTS.grid[y] ) do
         line[x] = vals.char;
      end;
      table.insert( lines, table.concat( line ) );
   end;

   vim.api.nvim_set_option_value( "modifiable", true, { buf = GLOBAL.CONSTANTS.plugin.buf } );
   vim.api.nvim_buf_set_lines( GLOBAL.CONSTANTS.plugin.buf, 0, -1, false, lines );
   vim.api.nvim_set_option_value( "modifiable", false, { buf = GLOBAL.CONSTANTS.plugin.buf } );

   vim.api.nvim_buf_clear_namespace( GLOBAL.CONSTANTS.plugin.buf, GLOBAL.CONSTANTS.plugin.namespace, 0, -1 );
   for y, _ in ipairs( GLOBAL.CONSTANTS.grid ) do
      for x, vals in ipairs( GLOBAL.CONSTANTS.grid[y] ) do
         vim.hl.range( GLOBAL.CONSTANTS.plugin.buf, GLOBAL.CONSTANTS.plugin.namespace, vals.hl,
                       { y - 1, x - 1 },
                       { y - 1, x - 1 } );
      end;
   end;
end;

local my_animation = {
   variables = {
   },
   update = function( grid, variables )
      for i = 1, #grid do
         local prev = grid[i][#(grid[i])];
         for j = 1, #(grid[i]) do
            grid[i][j], prev = prev, grid[i][j];
         end;
      end;
   end,
};

M._frame_update = function( animation, depth )
   if (GLOBAL.CONSTANTS.plugin.continue == false) then return; end;

   M._display_frame();
   animation.update( GLOBAL.CONSTANTS.grid, animation.variables );
   vim.defer_fn( function()
                    M._frame_update( my_animation, depth + 1 );
                    print( depth );
                 end, 100 );
end;

M.start_animation = function( animation_name )
   windows.init_window();

   GLOBAL.CONSTANTS.plugin.continue = true;
   M._frame_update( my_animation, 0 );
end;

return M;
