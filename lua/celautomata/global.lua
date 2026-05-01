GLOBAL = {
   CONSTANTS = {
      plugin = {
         win = nil,
         buf = nil,
         namespace = nil,
         name = "celautomata",
         continue = false,
      },
      grid = {},
   },

   DEFAULTS = {
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
            { "wrap", false },
         },
      },
   },
};

return GLOBAL;
