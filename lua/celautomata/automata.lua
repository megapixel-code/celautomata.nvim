local empty_cell = { char = " ", hl = {} };

local example = {
   fps = 60,
   variables = {
   },
   update = function( grid, variables )
      local temp;
      for y = 1, #grid do
         temp = grid[y][#(grid[y])];
         for x = 1, #(grid[y]) do
            grid[y][x], temp = temp, grid[y][x];
         end;
      end;
   end,
};

--- @param cell cell_field
--- @return boolean
local cell_alive = function( cell )
   if (cell.char == " ") then return false; end;
   return true;
end;

--- @param grid grid_field
--- @param pos1 [integer, integer]
--- @param pos2 [integer, integer]
local swap_cells = function( grid, pos1, pos2 )
   local x, y = pos1[1], pos1[2];
   local xx, yy = pos2[1], pos2[2];

   grid[yy][xx], grid[y][x] = grid[y][x], grid[yy][xx];
end;

--- @param pos [integer, integer]
--- @param grid grid_field
--- @return boolean
local pos_in_grid = function( pos, grid )
   local x, y = pos[1], pos[2];
   return (1 <= y and y <= #grid and 1 <= x and x <= #grid[1]);
end;

local gol = {};
gol = {
   update_cell = function( grid, coords, rules )
      local positions = {
         { -1, -1 },
         { 1,  -1 },
         { -1, 1 },
         { 1,  1 },
         { -1, 0 },
         { 0,  -1 },
         { 1,  0 },
         { 0,  1 },
      };
      local n_cells_around = 0;
      local x, y = coords[1], coords[2];

      local xx, yy;
      for _, offset in ipairs( positions ) do
         xx = x + offset[1];
         yy = y + offset[2];
         if pos_in_grid( { xx, yy }, grid ) then
            if (cell_alive( grid[yy][xx] )) then n_cells_around = n_cells_around + 1; end;
         end;
      end;

      if (rules.die( n_cells_around )) then
         return empty_cell;
      end;
      if (rules.born( n_cells_around )) then
         for _, offset in ipairs( positions ) do
            xx = x + offset[1];
            yy = y + offset[2];
            if pos_in_grid( { xx, yy }, grid ) then
               if (cell_alive( grid[yy][xx] )) then
                  return grid[yy][xx];
               end;
            end;
         end;
      end;
      return grid[y][x];
   end,
   update_grid = function( grid, rule )
      local new_grid = {};

      for y = 1, #grid do
         table.insert( new_grid, {} );
         for x = 1, #(grid[y]) do
            new_grid[y][x] = gol.update_cell( grid, { x, y }, rule );
         end;
      end;

      for y = 1, #grid do
         for x = 1, #(grid[y]) do
            grid[y][x] = new_grid[y][x];
         end;
      end;
   end,

   rule_conways = {
      die = function( n_cells_around )
         return (n_cells_around < 2 or n_cells_around > 3);
      end,
      born = function( n_cells_around )
         return (n_cells_around == 3);
      end,
   },
   rule_day_night = {
      die  = function( n_cells_around )
         return (n_cells_around <= 2 or n_cells_around == 5);
      end,
      born = function( n_cells_around )
         return (n_cells_around == 3 or 6 <= n_cells_around);
      end,
   },
   rule_pulsar_life = {
      die  = function( n_cells_around )
         return not (n_cells_around == 2 or n_cells_around == 3 or n_cells_around == 8);
      end,
      born = function( n_cells_around )
         return (n_cells_around == 3);
      end,
   },
};

local falling_sand = {
   --- @param grid grid_field
   --- @param coords [integer, integer]
   process_cell = function( grid, coords )
      local x, y = coords[1], coords[2];
      local xx, yy;

      if (not cell_alive( grid[y][x] )) then
         return;
      end;

      if (grid[y][x].processed == true) then
         return;
      end;

      for _, hl_group in ipairs( grid[y][x].hl ) do
         if (string.match( hl_group, "comment" ) ~= nil) then
            -- comments don't move
            return;
         end;
      end;

      local move_probability = 0.15;
      if (math.random() <= move_probability) then
         if (math.random() > 0.5) then
            xx = x + 1;
         else
            xx = x - 1;
         end;
         if (pos_in_grid( { xx, y + 1 }, grid )) then
            if (not cell_alive( grid[y + 1][xx] )) then
               swap_cells( grid, { x, y }, { xx, y + 1 } );
               return;
            end;
         end;
         if (pos_in_grid( { xx, y }, grid )) then
            if (not cell_alive( grid[y][xx] )) then
               swap_cells( grid, { x, y }, { xx, y } );
               return;
            end;
         end;
      end;

      local look_pos = {
         {
            { 0, -1 },
         },
         {
            { 1,  -1 },
            { -1, -1 },
         },
      };

      for _, priority in ipairs( look_pos ) do
         -- shuffle table
         for i = #priority, 2, -1 do
            local j = math.random( 1, i );
            priority[i], priority[j] = priority[j], priority[i];
         end;

         for _, pos in ipairs( priority ) do
            xx, yy = x - pos[1], y - pos[2];
            if (pos_in_grid( { xx, yy }, grid )) then
               if (not cell_alive( grid[yy][xx] )) then
                  swap_cells( grid, { x, y }, { xx, yy } );
                  grid[yy][xx].processed = true;
                  return;
               end;
            end;
         end;
      end;
   end,
};

--- @class automata
--- @field [string] animations_field

--- @class animations_field
--- @field fps integer
--- @field variables table
--- @field update fun(grid: grid_field, variables: table)

--- @type automata
local M = {};
M = {
   conways_game_of_life = {
      fps = 10,
      variables = {},
      update = function( grid, variables )
         gol.update_grid( grid, gol.rule_conways );
      end,
   },
   day_night_game_of_life = {
      fps = 10,
      variables = {},
      update = function( grid, variables )
         gol.update_grid( grid, gol.rule_day_night );
      end,
   },
   pulsar_life_game_of_life = {
      fps = 10,
      variables = {},
      update = function( grid, variables )
         gol.update_grid( grid, gol.rule_pulsar_life );
      end,
   },

   falling_sand = {
      fps = 40,
      variables = {},
      update = function( grid, variables )
         for y, _ in ipairs( grid ) do
            for x, _ in ipairs( grid[y] ) do
               grid[y][x].processed = false;
            end;
         end;

         local offset;
         for y, _ in ipairs( grid ) do
            for x, _ in ipairs( grid[y] ) do
               if (y % 2 == 0) then
                  offset = #grid[y] - x + 1;
               else
                  offset = x;
               end;
               falling_sand.process_cell( grid, { offset, #grid - y + 1 } );
            end;
         end;
      end,
   },
};

return M;
