vim.o.guifont = "JetBrainsMono_Nerd_Font_Mono,JetBrainsMono_Nerd_Font,JetBrains_Mono:h16,monospace:h16"
-- cursor blinking and settings
vim.o.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

if vim.g.neovide then
  -- I frequently forget I am in the IDE\Windowed\Visual version so a confirmation makes me think
  -- twice before closing.
  vim.g.neovide_confirm_quit = true

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_input_use_logo = true

  vim.g.neovide_cursor_animation_length = 0 -- Turn off cursor animations
end

