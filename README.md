# Celautomata

## Introduction:

[Cellular-automaton.nvim](https://github.com/Eandrju/cellular-automaton.nvim) is such a great plugin. I just have had a few problems with it:

- Support for utf chars is not present (a PR has been sent but no review a year later).
- If you have folds anywhere in your screen the plugin crashes. (I use folds) (support for folds is not implemented right now but it does not crash).
- If you don't have a treesitter parser for the buffer the plugin crashes.
- You cant move your mouse during the animations.
- The animation window does not copy the window options; meaning that if you have weird window options (I do) you end up with a offset at the start of the animation. (and other small problems)
- Some options like nowrap were not set, meaning that sometime you would end up with animations that would wrap lines. (not good)
- The plugin is not maintained which is fine but I want the fixes.

This is why I made a full re-write of the plugin (took me 3 whole days lol)

## Examples:


## Config:

```lua
return {
   dir = "~/documents/projects/celautomata.nvim/",
   lazy = true,

   init = function()
      -- you can use the api to start the plugin
      vim.keymap.set( "n", "<leader><BS>", function()
                         require( "celautomata" ).start_random_animation(
                            nil, { "conways_game_of_life" } );
                      end, { desc = "start random animation that is not 'conways_game_of_life'" } );

      -- or
      vim.keymap.set( "n", "<leader><BS>", function()
                         require( "celautomata" ).start_animation( "falling_sand" );
                      end, { desc = "start falling_sand animation" } );

   end,

   --- @module "celautomata"
   --- @type user_config_field
   opts = {
      -- you can change the options of the animations like so
      -- or even create new animations
      animations = {
         falling_sand = {
            fps = 10,
         },
      },
   },
};
```

## API:
```lua
-- returns a table with all of the animations that you can call
require("celautomata").get_all_animations()

-- start the animation with the name
require("celautomata").start_animation( "animation_name" )

-- start a random animation from all of the animations available from |get_all_animations()|
-- you can give it a list of animations you want to choose from and/or filter some animations
-- Optional parameter `{animations}` is set to all animations by default
-- Optional parameter `{filter_out}` is set to none by default
require("celautomata").start_random_animation()
```

## Custom animations:

```lua
opts = {
   animations = {
      example = {
         fps = 60,
         variables = {},
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
   },
},

-- that you will call like
require("celautomata").start_animation( "test" )
```

What's inside ```grid[y][x]``` ?
```lua
{
   char = "?"                 -- a string containing the char at that position
   hl = { "?", "?", "?" ... } -- a array of strings representing the hl_groups
}                             -- at that position (can be empty)
```

