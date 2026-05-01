GLOBAL = {
   CONSTANTS = {
      plugin = {
         win = nil,
         buf = nil,
      },
      grid = {},
   },

   DEFAULTS = {
      relevant_win_opts = {
         "number",
         "relativenumber",
         "list",
         "wrap",
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
