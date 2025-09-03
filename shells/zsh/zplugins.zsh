fpath+=( "$HOME/.cache/antidote/romkatv/zsh-defer" )
source "$HOME/.cache/antidote/romkatv/zsh-defer/zsh-defer.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/zsh-users/zsh-completions" )
source "$HOME/.cache/antidote/zsh-users/zsh-completions/zsh-completions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/completion" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/completion/completion.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/compstyle" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/compstyle/compstyle.plugin.zsh"
if ! (( $+functions[zsh-defer] )); then
  fpath+=( "$HOME/.cache/antidote/romkatv/zsh-defer" )
  source "$HOME/.cache/antidote/romkatv/zsh-defer/zsh-defer.plugin.zsh"
fi
fpath+=( "$HOME/.cache/antidote/zsh-users/zsh-autosuggestions" )
zsh-defer source "$HOME/.cache/antidote/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/zdharma-continuum/fast-syntax-highlighting" )
zsh-defer source "$HOME/.cache/antidote/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/zsh-users/zsh-history-substring-search" )
zsh-defer source "$HOME/.cache/antidote/zsh-users/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/zfunctions" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/zfunctions/zfunctions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/color" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/color/color.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/directory" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/directory/directory.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/editor" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/editor/editor.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/environment" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/environment/environment.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/history" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/history/history.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/mattmc3/zephyr/plugins/utility" )
source "$HOME/.cache/antidote/mattmc3/zephyr/plugins/utility/utility.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/zshzoo/magic-enter" )
zsh-defer source "$HOME/.cache/antidote/zshzoo/magic-enter/magic-enter.plugin.zsh"
