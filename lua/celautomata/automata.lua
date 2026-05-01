local empty_cell = { char = " ", hl = {} };

local gol = {};
gol = {
   cell_alive = function( cell )
      if (cell.char == " ") then return false; end;
      return true;
   end,
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
         if (1 <= yy and yy <= #grid and 1 <= xx and xx <= #grid[1]) then
            if (gol.cell_alive( grid[yy][xx] )) then n_cells_around = n_cells_around + 1; end;
         end;
      end;

      if (rules.die( n_cells_around )) then
         return empty_cell;
      end;
      if (rules.born( n_cells_around )) then
         for _, offset in ipairs( positions ) do
            xx = x + offset[1];
            yy = y + offset[2];
            if (1 <= yy and yy <= #grid and 1 <= xx and xx <= #grid[1]) then
               if (gol.cell_alive( grid[yy][xx] )) then
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

local M = {};

M = {
   example = {
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
   },

   conways_game_of_life = {
      fps = 10,
      variables = {
      },
      update = function( grid, variables )
         gol.update_grid( grid, gol.rule_conways );
      end,
   },
   day_night_game_of_life = {
      fps = 10,
      variables = {
      },
      update = function( grid, variables )
         gol.update_grid( grid, gol.rule_day_night );
      end,
   },
   pulsar_life_game_of_life = {
      fps = 10,
      variables = {
      },
      update = function( grid, variables )
         gol.update_grid( grid, gol.rule_pulsar_life );
      end,
   },
};

return M;
