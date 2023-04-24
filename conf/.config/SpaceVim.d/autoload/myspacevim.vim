function! myspacevim#before() abort
  " 2022-11 set the shell to bash regardless of shell of executing environment
  " FIX: (neo)vim format buffer (prettier) inserts chars with SHELL=/bin/fish
  set shell=/bin/bash

  " 2023-03 Set spellfile to more "local" directory (default ~/.config/SpaceVim.d/spell)
  set spellfile=~/.local/share/nvim/spell/en.utf-8.add

  " 2022-08-16 FIX error: Cannot find the "neovim" node package.
  " Command to start the Node host. Setting this makes startup faster.
  " https://github.com/neovim/neovim/commit/0093c25dd3795972b953f9914cc33fc38c5d9dbc
  let g:node_host_prog = expand($NPM_CONFIG_PREFIX).'/bin/neovim-node-host'

  let g:jsdoc_formatter = 'tsdoc'

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " >= 2021
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  """"""""""""""""""
  " CoC
  """"""""""""""""""

  " 2021-04-21: change CoC's config directory without polluting SpaceVim
  " https://github.com/SpaceVim/SpaceVim/issues/2564#issuecomment-651513935
  let g:coc_config_home = expand($XDG_CONFIG_HOME).'/SpaceVim.d/'


  """"""""""""""""""
  " colorizer
  """"""""""""""""""

	" Methods of highlighting
        " \ 'sign_column',
        " \ 'background',
        " \ 'backgroundfull',
        " \ 'foreground',
        " \ 'foregroundfull'
	let g:Hexokinase_highlighters = [
        \ 'virtual'
        \ ]

  " Patterns to match for all filetypes
  let g:Hexokinase_optInPatterns = [
        \ 'colour_names',
        \ 'full_hex',
        \ 'hsl',
        \ 'hsla',
        \ 'rgb',
        \ 'rgba',
        \ 'triple_hex'
        \ ]

  " Filetype specific patterns to match
  " entry value must be comma seperated list
  " let g:Hexokinase_ftOptInPatterns = {
  "       \ 'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
  "       \ 'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names'
  "       \ }

  " Define custom patterns via palettes
  let g:Hexokinase_palettes = [
        \ expand($XDG_CONFIG_HOME).'/SpaceVim.d/colorizer-palettes/Color3.json',
        \ expand($XDG_CONFIG_HOME).'/SpaceVim.d/colorizer-palettes/gruvbox.json',
        \ expand($XDG_CONFIG_HOME).'/SpaceVim.d/colorizer-palettes/test.json'
        \ ]

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " <= 2020 (needs review)
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  """"""""""""""""""
  " ALE
  """"""""""""""""""

  " " auto fix (on file save)
  " " https://github.com/w0rp/ale#2ii-fixing
  " let g:ale_fixers = {
  " \   '*': ['remove_trailing_lines', 'trim_whitespace'],
  " \   'javascript': ['prettier', 'eslint'],
  " \   'json': ['prettier'],
  " \   'markdown': ['prettier'],
  " \ }

  " let g:ale_fix_on_save = 0

  " " https://github.com/w0rp/ale#5i-how-do-i-disable-particular-linters
  " " By default, all available tools for all supported languages will be run.
  " " If you want to only select a subset of the tools:
  " let g:ale_linters = {
  " \   'javascript': ['eslint', 'flow'],
  " \ }


  """"""""""""""""""
  " vim-surround
  """"""""""""""""""

  " use `echo char2nr("?")` to see ASCII, append to `surround_` for custom replacement

  " j: JSX comment
  let g:surround_106 = "{/* \r */}"

endfunction

function! myspacevim#after() abort
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " >= 2021
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  """"""""""""""""""
  " CoC
  """"""""""""""""""

  " 2022-08-08: Use <cr> to confirm completion (for autoImports)
  " https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-cr-to-confirm-completion
  " For features like textEdit and additionalTextEdits (mostly used by automatic import feature)
  " of LSP to work, you have to confirm completion by coc#pum#confirm()
  inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

  " one-key shortcut to restart coc
  nnoremap <silent> <F12> :CocRestart<CR>

  " show documentation in preview window.
  nnoremap <silent> <F10> :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction


  """"""""""""""""""
  " neoformat
  """"""""""""""""""

  " Add formatters, use prettier when supported
  " https://spacevim.org/layers/format/
  " https://github.com/sbdchd/neoformat
  " ~/.SpaceVim/autoload/SpaceVim/layers/lang/typescript.vim

  let _neoformat_clangformat = {
        \ 'exe': 'clang-format',
        \ 'args': ['-style=file'],
        \ 'stdin': 1
        \ }

  let _neoformat_prettier = {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
        \ 'stdin': 1
        \ }

  let g:neoformat_c_clangformat       = _neoformat_clangformat
  let g:neoformat_cpp_clangformat     = _neoformat_clangformat
  let g:neoformat_css_prettier        = _neoformat_prettier
  let g:neoformat_html_prettier       = _neoformat_prettier
  let g:neoformat_javascript_prettier = _neoformat_prettier
  let g:neoformat_json_prettier       = _neoformat_prettier
  let g:neoformat_jsonc_prettier      = _neoformat_prettier
  let g:neoformat_markdown_prettier   = _neoformat_prettier
  let g:neoformat_solidity_prettier   = _neoformat_prettier
  let g:neoformat_typescript_prettier = _neoformat_prettier
  let g:neoformat_xml_prettier        = _neoformat_prettier
  let g:neoformat_yaml_prettier       = _neoformat_prettier

  let g:neoformat_enabled_c          = ['clangformat']
  let g:neoformat_enabled_cpp        = ['clangformat']
  let g:neoformat_enabled_css        = ['prettier']
  let g:neoformat_enabled_html       = ['prettier']
  let g:neoformat_enabled_javascript = ['prettier']
  let g:neoformat_enabled_json       = ['prettier']
  let g:neoformat_enabled_jsonc      = ['prettier']
  let g:neoformat_enabled_markdown   = ['prettier']
  let g:neoformat_enabled_solidity   = ['prettier']
  let g:neoformat_enabled_typescript = ['prettier']
  let g:neoformat_enabled_xml        = ['prettier']
  let g:neoformat_enabled_yaml       = ['prettier']


  """"""""""""""""""
  " neomake
  """"""""""""""""""

    " \ '-checks=*,-fuchsia*,-llvm*',
    " \ '-extra-arg=-std=c++14',
  let _neomake_clangtidy_args = [
    \ ]

  let g:neomake_c_clangtidy_args   = _neomake_clangtidy_args
  let g:neomake_cpp_clangtidy_args = _neomake_clangtidy_args

  let g:neomake_c_enabled_makers   = ['clangtidy']
  let g:neomake_cpp_enabled_makers = ['clangtidy']

  let g:neomake_solidity_enabled_makers = ['solhint']

  " let g:neomake_javascript_enabled_makers = ['eslint']
  " let g:neomake_jsx_enabled_makers = ['eslint']
  " let g:neomake_typescript_enabled_makers = ['eslint']


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " <= 2020 (needs review)
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

	" call SpaceVim#custom#SPCGroupName(['G'], '+TestGroup')
	" call SpaceVim#custom#SPC('nore', ['G', 't'], 'echom 1', 'echomessage 1', 1)

  " italic comments
  " https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
  highlight Comment cterm=italic gui=italic

  " updated gitgutter response time
  " https://github.com/airblade/vim-gitgutter#getting-started
  set updatetime=100

  " disable persistent undo
  set noundofile
endfunction
