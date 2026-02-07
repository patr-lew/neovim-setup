return {
  'neovim/nvim-lspconfig',
  init = function()
    local idle_ms = 10 * 60 * 1000 -- 10 minutes
    local uv = vim.uv
    local timer = uv.new_timer()

    local hibernated = false

    -- Only hibernate these (tune this list)
    local heavy = {
      tsserver = true,
      ts_ls = true,
      angularls = true,
      eslint = true,
      eslintls = true,
      -- add others if needed
    }

    local function is_real_file_buf(buf)
      return vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buftype == ''
        and vim.api.nvim_buf_get_name(buf) ~= ''
    end

    local function detach_heavy_clients()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if is_real_file_buf(buf) then
          for _, client in ipairs(vim.lsp.get_clients { bufnr = buf }) do
            if heavy[client.name] then
              pcall(vim.lsp.buf_detach_client, buf, client.id)
            end
          end
        end
      end
      hibernated = true
    end

    local function wake_up()
      if not hibernated then
        return
      end
      -- Let LazyVim/LspAttach do its thing. This is a gentle nudge.
      -- (We avoid constantly calling LspStart, only on wake.)
      vim.cmd 'silent! LspStart'
      hibernated = false
    end

    local function schedule()
      if timer == nil then
        return
      end
      timer:stop()
      timer:start(idle_ms, 0, function()
        vim.schedule(function()
          detach_heavy_clients()
        end)
      end)
    end

    -- Activity in this Neovim instance resets the timer and wakes if needed
    vim.api.nvim_create_autocmd({
      'CursorMoved',
      'CursorMovedI',
      'InsertEnter',
      'BufEnter',
      'FocusGained',
    }, {
      callback = function()
        wake_up()
        schedule()
      end,
    })

    schedule()
  end,
}
