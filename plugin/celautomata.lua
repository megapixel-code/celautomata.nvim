-- Prevent load multiple times
if vim.g.loaded_celautomata then
   return;
end;

vim.g.loaded_celautomata = 1;
