" Vim-Plug plugin manager
call plug#begin('~/.vim/bundle')

    " Sensible defaults
    Plug 'tpope/vim-sensible'

    " Linting
    Plug 'w0rp/ale'
        let g:ale_lint_on_text_changed = "never"

    " Autocomplete
    Plug 'copy/deoplete-ocaml'
    Plug 'Shougo/deoplete.nvim', {'do':':UpdateRemotePlugins'}
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#ignore_sources = {}
        let g:deoplete#ignore_sources._ = ['buffer', 'around']
        let g:deoplete#omni#input_patterns={}
        let g:deoplete#omni#input_patterns.ocaml='[^ ,;\t\[()\]]{2,}'

call plug#end()

" Keybindings
inoremap jk <esc>
nnoremap \r :source ~/.config/nvim/init.vim<cr>
nnoremap \h :nohlsearch<cr>

" Color settings
set termguicolors

" Settings
set number
set laststatus=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set incsearch            " Set incremental searching
set inccommand=nosplit   " Set live command simulation
set hlsearch             " Set highlighting for searches
set completeopt-=preview " No preview buffer for autocomplete

" Language-specific settings
augroup OCaml
    autocmd Filetype ocaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup end

" Fix tab for autocomplete selection
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
