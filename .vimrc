
set background=dark
set incsearch
set hidden
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p
nnoremap <Leader>v <c-v>
" use same clipboard as system, allowing for copy/paste across
" windows/linux(wsl)/vim
set clipboard^=unnamed
" if $DISPLAY =~

filetype indent plugin on
syntax on

" set spell spelllang=en_us

set spellfile=~/.vim/spell/default.utf-8.add

" With of a tab = 4, indents will have a width of 4
set tabstop=4 shiftwidth=4 softtabstop=4
" Indent using spaces instead of tabs
set expandtab

" Indent with tabs if editing a Makefile
if has ("autocmd")
	autocmd FileType make set noexpandtab softtabstop=0 tabstop=4
endif

set path+=src/**

" Better command-line completion
set wildmenu
" Ignore certain files when completing
set wildignore+=*.o,*.swp,*.DS_Store

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
" Automatically change working directory when editing a file, but not really.
" Also, Don't do it for files in /tmp
" autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
" make ctrl-backspace delete the previous word (insert mode)
imap <C-BS> <C-W>

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
" Linewrap markdown files at 80 characters
au BufRead,BufNewFile *.md setlocal textwidth=80

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number
set relativenumber

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" make CTRL-L clear highlighted search terms as well as redraw the screen
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" Keybind Q to rewrap a block of selected text 
vnoremap Q gq

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Closetag settings

" filenames like *.xml, *.html, *.xhtml, ...
" " These are the file extensions where this plugin is enabled.
" "
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
"
" " filenames like *.xml, *.xhtml, ...
" " This will make the list of non-closing tags self-closing in the specified
" files.
" "
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
"
" " filetypes like xml, html, xhtml, ...
" " These are the file types where this plugin is enabled.
" "
" let g:closetag_filetypes = 'html,xhtml,phtml'
"
" " filetypes like xml, xhtml, ...
" " This will make the list of non-closing tags self-closing in the specified
" files.
" "
" let g:closetag_xhtml_filetypes = 'xhtml,jsx'
"
" " integer value [0|1]
" " This will make the list of non-closing tags case-sensitive (e.g. `<Link>`
" will be closed while `<link>` won't.)
" "
" let g:closetag_emptyTags_caseSensitive = 1
"
" " Shortcut for closing tags, default is '>'
" "
let g:closetag_shortcut = '>'
"
" " Add > at current position without closing the current tag, default is ''
" "
" let g:closetag_close_shortcut = '<leader>>'

" ------------------------------ MISC SETTINGS -------------------------------

" Gets the syntax item stack of the symbol under the cursor
" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim#9464929
function! SynStack()
  if !exists("*synstack")
    return
  endif
  return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


" Gets the syntax group of the token under the cursor.
" Takes 1 optional argument. If truthy, all syntax groups the token belongs to
" are listed. If falsy, only the first group is returned. Defaults to falsy.
function SynGroup(...)
  let listAll = get(a:, 1, 0)
  if listAll
    return map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  else
    return synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  end
endfunc

command! -nargs=0 SynStack :echo SynStack()
"
" nmap <leader>ss :SynStack<CR>
nmap <leader>ss :echo SynStack()<CR>
nmap <leader>sg :echo SynGroup()<CR>
nmap <leader>sG :echo SynGroup(1)<CR>

nmap <C-.> :echo "hello!"<CR>

" ----------------------------- PLUGGED SETTINGS -----------------------------

" Auto-install vim-plugged if it's not installed yet
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
       \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 1 for debug messages, 2 for verbose debug messages
let g:detectindent_verbosity = 0
let g:NERDTreeStatusLine = '%#NonText#'
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeShowHidden=1
" These files won't appear in the file explorer
let g:NERDTreeIgnore=['node_modules', 'dist', '\.git', '\.yarn', '\.DS_Store', '\.tsbuildinfo$', '\~$']

" This part initializes plugins installed using vim-plugged
" To install plugins, add them to this list and run :PlugInstall 
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'
" vim IDE plugin, based on VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'sheerun/vim-polyglot'
" Sidebar file explorer
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-ruby/vim-ruby'
Plug 'hashivim/vim-terraform'
Plug 'wlangstroth/vim-racket'
Plug 'chr4/nginx.vim'
Plug 'neoclide/jsonc.vim'
Plug 'vim-scripts/DoxygenToolkit.vim'
" TypeScript plugin
" Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'DonIsaac/detectindent'
Plug 'harenome/vim-mipssyntax'
Plug 'abecodes/tabout.nvim'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" Git plugin (https://github.com/tpope/vim-fugitive)
Plug 'tpope/vim-fugitive'

" Rainbow brackets plugin
" Plug 'junegunn/rainbow_parentheses.vim'
Plug 'frazrepo/vim-rainbow'
" Color schemes
Plug 'dikiaap/minimalist' " colorscheme minimalist
Plug 'drewtempelmeyer/palenight.vim' " colorscheme palenight

" Only install these plugins if we're running neovim, not vim
if has('nvim')
    Plug 'github/copilot.vim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Plug 'rockerBOO/boo-colorscheme-nvim' " colorscheme boo
endif

" Detects indent style of currently opened file and adjusts accordingly
" Plug 'ciaranm/detectindent'
call plug#end()

" ------------------------ RAINBOW PARENTHESES SETTINGS -----------------------

" Enable rainbow parentheses
" call rainbow_parenthsis#activate()
" augroup rainbow_parenthsis
    " au!
    " au FileType * RainbowParenthesis
" augroup END
let g:rainbow_active = 1



" --------------------------- DETECT-INDENT SETTINGS --------------------------

" Prefer 'expandtab' to 'noexpandtab' when no detection is possible
" let g:detectindent_preferred_expandtab = 1
"
" Prefer an indent width of 2 when no detection in possible
" let g:detectindent_preferred_indent = 2
"
" This needs to be run after above settings are set
" :autocmd BufReadPost * :DetectIndent



" ----------------------------- NERDTREE SETTINGS -----------------------------

" Open NERDTree whenever vim is started
autocmd vimenter * NERDTree
let NERDTreeRespectWildIgnore=1

" Open NERDTree when 'vim' command is run. You no longer have to type 'vim .'
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim when NERDTree is the last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif



" --------------------------- NERDCOMMENTER SETTINGS ---------------------------

" Comment out the current line
" noremap <expr> <C-/> NERDComment("n", "Toggle")
" nmap <C-_> <Plug>NERDCommenterToggle<CR>gv
let g:NERDSpaceDelims = 1



" ---------------------------- COLORSCHEME SETTINGS ----------------------------

set t_Co=256
if has("termguicolors")
    set termguicolors
endif

if has('nvim')
    colorscheme palenight
    let g:palenight_terminal_italics = 1
else
    colorscheme minimalist
endif



" ----------------------------- COC.NVIM SETTINGS ------------------------------

let g:coc_filetype_map = { 'tex': 'latex' }

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer delays between .swp writes (default is 4000 = 4s) leads to
" noticeable delays/bad UX
set updatetime=300

" |foo|
" Don't pass messages to |ins-completion-menu|
set shortmess+=c

if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-type-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" K shows documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use ctrl+\ to insert λ
if maparg("<C-\>", "n") == ""
  inoremap <buffer> <C-\> <C-K>l*
endif

" Use tab to trigger completion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Format selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use \rn or F2 to rename current word
nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" use \. to show fix suggestions
nmap <leader>. :CocFix<CR>
imap <leader>. <C-O>:CocFix<CR>

" Run the Code Lens action on the current line.
nmap <leader>cl <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Add `:Format` command to format the current buffer
command! -nargs=0 Format :call CocAction('format')
" todo: does not work
" nnoremap <silent> \ef :call <SID>CocAction('format')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"



" ------------------------------ COPILOT SETTINGS ------------------------------

" Enable Copilot for json and yaml files
let g:copilot_filetypes = {
            \ 'yaml':  v:true,
            \ 'json':  v:true,
            \ 'sh':    v:true,
            \ }



" ---------------------------- TREESITTER SETTINGS -----------------------------

function! ConfigureTreeSitter()
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "python", "javascript", "typescript", "html", "css" },
    sync_install = false,
    highlight = {
        enable = true,
        -- List of languages to disable
        disable = {},
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_higlighting = false
        },
    -- Experimental indent for `=` operator
    indent = {
        enabled = true
    }
}
EOF
endfunction

if has("nvim")
    call ConfigureTreeSitter()
endif



" -------------------------- STATUS BAR --------------------------
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0 ? "\uE725 " . l:branchname . ' ' : ''
endfunction

function! s:GetNum(cmd)
    return split(execute("setl " . a:cmd), "=")[-1]
endfunction

function! IndentLine()
    let l:type = execute("setl expandtab?") ==? "expandtab" ? "spaces" : "tabs"
    let l:stop_count = s:GetNum(l:type ==? "spaces" ? "softtabstop" : "tabstop")
    let l:indent_width = s:GetNum("shiftwidth")
    " let l:count = split(execute("setl " . l:cmd), "=")[-1]

    let l:res = l:stop_count . ":" . l:indent_width . " " . l:type
    " echom l:res

    return l:res
endfunction

function! CreateStatusLine()
  " Left
  set statusline=
  set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
  set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
  set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
  set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
  set statusline+=\ %n\                       " buffer number
  set statusline+=%#Visual#                   " colour
  set statusline+=%{&paste?'\ PASTE\ ':''}
  set statusline+=%{&spell?'\ SPELL\ ':''}
  set statusline+=%#CursorIM#                 " colour
  set statusline+=%R                          " readonly flag
  set statusline+=%M                          " modified [+] flag
  set statusline+=%#Cursor#                   " colour
  set statusline+=%#CursorLine#               " colour
  set statusline+=\ %t\                       " short file name

  set statusline+=%=                          " right align

  " Right
  set statusline+=%#CursorLine#               " colour
  set statusline+=\ %Y\                       " file type
  set statusline+=\ %{StatuslineGit()}\       " git branch, if available
  set statusline+=\ %{IndentLine()}\          " indent stats
  set statusline+=%#CursorIM#                 " colour
  set statusline+=\ %3l:%-2c\                 " line + column
  set statusline+=%#Cursor#                   " colour
  set statusline+=\ %3p%%\                    " percentage
endfunction

autocmd BufEnter,TabEnter,WinEnter,BufWinEnter * :call CreateStatusLine()


" ------------------------- KEY BINDINGS --------------------------

nmap di <Plug>DetectIndent<CR> | call CreateStatusLine()

" CTRL-/ toggles comments
map <C-_> <Plug>NERDCommenterToggle
imap <C-_> <Plug>NERDCommenterToggle
nnoremap <C-J> a<CR><Esc>k$
" execute "set <M-Q>=\eQ"
nnoremap <leader>q vipgq<CR>
" inoremap <F3> <C-O>:w<CR>

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
" let s:opam_share_dir = system("opam config var share")
" let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

" let s:opam_configuration = {}

" function! OpamConfOcpIndent()
"   execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
" endfunction
" let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

" function! OpamConfOcpIndex()
"   execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
" endfunction
" let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

" function! OpamConfMerlin()
"   let l:dir = s:opam_share_dir . "/merlin/vim"
"   execute "set rtp+=" . l:dir
" endfunction
" let s:opam_configuration['merlin'] = function('OpamConfMerlin')

" let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
" let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
" let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
" for tool in s:opam_packages
"   " Respect package order (merlin should be after ocp-index)
"   if count(s:opam_available_tools, tool) > 0
"     call s:opam_configuration[tool]()
"   endif
" endfor
" " ## end of OPAM user-setup addition for vim / base ## keep this line
" " ## added by OPAM user-setup for vim / ocp-indent ## 621d1b14e458dedc3b4e09620bac9516 ## you can edit, but keep this line
" " if count(s:opam_available_tools,"ocp-indent") == 0
"   " source '/home/donisaac/.opam/4.07.0/share/ocp-indent/vim/indent/ocaml.vim'
" " endif
" " ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
