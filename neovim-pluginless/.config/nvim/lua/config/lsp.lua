local get_buf_opts = function(bufnr, desc)
  return {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = desc,
  }
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf

    -- Keymaps
    vim.keymap.set("n", "K", vim.lsp.buf.hover, get_buf_opts(bufnr, "Show doc"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, get_buf_opts(bufnr, "[G]oto [d]efinition"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, get_buf_opts(bufnr, "[G]oto [I]mplementation"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, get_buf_opts(bufnr, "[G]oto [R]eferences"))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, get_buf_opts(bufnr, "[G]oto [D]eclaration"))
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, get_buf_opts(bufnr, "Show signature help"))
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, get_buf_opts(bufnr, "Type [D]efinition"))
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, get_buf_opts(bufnr, "Rename"))
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, get_buf_opts(bufnr, "[R]e[n]ame"))
    vim.keymap.set("n", "<Leader><CR>", vim.lsp.buf.code_action, get_buf_opts(bufnr, "Show code actions"))
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, get_buf_opts(bufnr, "Show [C]ode [A]ctions"))
    vim.keymap.set("x", "<Leader>ca", vim.lsp.buf.code_action, get_buf_opts(bufnr, "Show [C]ode [A]ctions"))
    vim.keymap.set("n", "<Leader>f", function()
      vim.lsp.buf.format({ async = false })
    end, { noremap = true, silent = true, desc = "Format file" })

    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client:supports_method("textDocument/completion") then
    vim.opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
    vim.lsp.completion.enable(true, client.id, ev.buf, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })
    vim.keymap.set("i", "<C-Space>", function()
      vim.lsp.completion.get()
    end)
    -- end
    if
        not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting")
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})
