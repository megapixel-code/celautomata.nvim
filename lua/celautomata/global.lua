local automata = require( "celautomata.automata" );

--- @class global table of all available options
--- @field CONSTANTS constants_field
--- @field USER_CONFIG user_config_field

--- @class constants_field
--- @field plugin plugin_field
--- @field grid? grid_field
--- @field relevant_win_opts string[]
--- @field additional_nvim_opts additional_nvim_opts_field

--- @class plugin_field
--- @field win? integer
--- @field buf? integer
--- @field namespace? integer
--- @field name string
--- @field continue boolean

--- @class grid_field
--- @field line line_field[]
--- @class line_field
--- @field cell cell_field[]
--- @class cell_field
--- @field char string
--- @field hl string[]

--- @class user_config_field
--- @field animations? automata

--- @class additional_nvim_opts_field
--- @field buf nivm_opts_field
--- @field win nivm_opts_field

--- @class nivm_opts_field
--- @field [integer] table in the form { "name" "value" }; look |nvim_set_option_value()|

--- @module "celautomata"
--- @type global
GLOBAL = {
   CONSTANTS = {
      plugin = {
         win = nil,
         buf = nil,
         namespace = nil,
         name = "celautomata",
         continue = false,
      },
      relevant_win_opts = {
         "number",
         "relativenumber",
         "list",
         "signcolumn",
         "foldcolumn",
         "statuscolumn",
      },
      additional_nvim_opts = {
         buf = {
            { "modifiable", false },
            { "bufhidden",  "wipe" },
            { "buftype",    "nofile" },
            { "filetype",   "celautomata" },
            { "swapfile",   false },
         },
         win = {
            { "wrap",      false },
            { "listchars", "tab:  ,trail: ,nbsp: " },
            { "spell",     false },
         },
      },
   },

   USER_CONFIG = {
      animations = automata,
   },
};

return GLOBAL;
