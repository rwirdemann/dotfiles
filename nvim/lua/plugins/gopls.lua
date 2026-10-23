return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              analyses = {
                ST1000 = false,
                -- Doc-Kommentare, die mit TODO anfangen, sollen nicht
                -- anmahnen, dass sie mit dem Namen beginnen muessten.
                -- ST1020: Funktionen, ST1021: Typen, ST1022: Var/Const.
                ST1020 = false,
                ST1021 = false,
                ST1022 = false,
              },
            },
          },
        },
      },
    },
  },
}
