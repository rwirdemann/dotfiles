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
              },
            },
          },
        },
      },
    },
  },
}
