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

   local x_index;
   vim.api.nvim_buf_clear_namespace( GLOBAL.CONSTANTS.plugin.buf, GLOBAL.CONSTANTS.plugin.namespace, 0, -1 );
   for y, _ in ipairs( GLOBAL.CONSTANTS.grid ) do
      x_index = vim.str_utf_pos( lines[y] );
      for x, vals in ipairs( GLOBAL.CONSTANTS.grid[y] ) do
         if (vals.char ~= " ") then
            vim.hl.range( GLOBAL.CONSTANTS.plugin.buf, GLOBAL.CONSTANTS.plugin.namespace, vals.hl,
                          { y - 1, x_index[x] - 1 },
                          { y - 1, x_index[x] - 1 } );
         end;
      end;
   end;
end;

M._frame_update = function( animation )
   if (GLOBAL.CONSTANTS.plugin.continue == false) then return; end;

   local ms = 1000 / animation.fps;

   M._display_frame();
   animation.update( GLOBAL.CONSTANTS.grid, animation.variables );
   vim.defer_fn( function()
                    M._frame_update( animation );
                 end, ms );
end;

M.start_animation = function( animation_name )
   windows.init_window();

   GLOBAL.CONSTANTS.plugin.continue = true;
   M._frame_update( GLOBAL.DEFAULTS.animations[animation_name] );
end;

return M;
