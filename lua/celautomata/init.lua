local run                 = require( "celautomata.run" );
local GLOBAL              = require( "celautomata.global" );

local M                   = {};

--- Api to get all available animations
--- @return string[] animation_names table containing all animation_names
M.get_annimations         = function()
   local annimations = {};
   for animation_name, _ in pairs( GLOBAL.USER_CONFIG.animations ) do
      table.insert( annimations, animation_name );
   end;
   return annimations;
end;

--- Api to run one random animation
---
--- Optional parameter `{animations}` is set to all animations by default
--- Optional parameter `{filter_out}` is set to none by default
---
--- @param animations? string[] choose from theses animations
--- @param filter_out? string|string[] filter out theses animations
M.start_random_annimation = function( animations, filter_out )
   animations = animations or M.get_annimations();
   filter_out = filter_out or {};
   if (type( filter_out ) == "string") then filter_out = { filter_out }; end;

   local animations_available = {};

   for _, animation_name in ipairs( animations ) do
      if (not vim.list_contains( filter_out, animation_name )) then
         table.insert( animations_available, animation_name );
      end;
   end;

   math.randomseed( os.time() );
   local random_nb = math.random( 1, #animations_available );
   local chosen_annimation = animations_available[random_nb];

   vim.print( GLOBAL.CONSTANTS.plugin.name .. ": Started animation " .. chosen_annimation );
   M.start_animation( chosen_annimation );
end;

--- Api to run one animation
--- see also: `get_annimations()`
--- @param animation_name string the name of the animation
M.start_animation         = function( animation_name )
   run.start_animation( animation_name );
end;

M.setup                   = function( opts )
   opts = opts or {};

   GLOBAL.USER_CONFIG = vim.tbl_deep_extend( "force", GLOBAL.USER_CONFIG, opts );
end;

return M;
