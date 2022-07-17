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

" Include source folder and monorepos in path, making them discoverable with
" :find
set path+=src/**
set path+=packages/**

" Better command-line completion
set wildmenu
" Ignore certain files when completing
set wildignore+=*.o,*.swp,*.DS_Store

" Show partial commands in the last line of the screen
set showcmd

set nowrap

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

" Disable line numbers and sign column (gap on left side of line numbers) in
" the integrated terminal
au TermOpen * setlocal nonumber norelativenumber signcolumn=no

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

" nmap <C-.> :echo "hello!"<CR>

" ----------------------------- PLUGGED SETTINGS -----------------------------

" Auto-install vim-plugged if it's not installed yet
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
       \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 1 for debug messages, 2 for verbose debug messages
let g:detectindent_verbosity = 0
let g:NERDTreeStatusline = '%#NonText#'
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeShowHidden=1
" These files won't appear in the file explorer
let g:NERDTreeIgnore=['node_modules', 'dist', '\.git', '\.yarn', '\.DS_Store', '\.tsbuildinfo$', '\~$', '\.cache']

" This part initializes plugins installed using vim-plugged
" To install plugins, add them to this list and run :PlugInstall 
call plug#begin('~/.vim/plugged')

" vim IDE plugin, based on VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Debugger plugin, based on VSCode + debug protocol
Plug 'puremourning/vimspector'

" Useful utilities, generally cross-language
Plug 'scrooloose/nerdcommenter' " Commenting lines or blocks of code
Plug 'tpope/vim-surround'       " Add, edit, and remove surrounding quotes/parens/etc
Plug 'DonIsaac/detectindent'    " Detect and adjust shiftwidth, expandtab, etc based on current buffer
Plug 'abecodes/tabout.nvim'     " Press tab to move out of quotes/parens/etc
Plug 'junegunn/fzf'             " fuzzyfinder, gives Ctrl+P-like functionality. Requires fzf installed.

" Sidebar file explorer
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'  " Show git status next to files in nerdtree
Plug 'ryanoasis/vim-devicons'       " Adds filetype icons next to files/folders. Requires a Nerd Font compatible font
Plug 'kyazdani42/nvim-web-devicons' " Adds filetype icons next to files/folders. Requires a Nerd Font compatible font

" Status and tab line
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax plugins
Plug 'sheerun/vim-polyglot'
Plug 'vim-ruby/vim-ruby'
Plug 'hashivim/vim-terraform'
Plug 'wlangstroth/vim-racket'
Plug 'chr4/nginx.vim'
Plug 'neoclide/jsonc.vim'
Plug 'leafgarland/typescript-vim'
Plug 'harenome/vim-mipssyntax'
Plug 'fladson/vim-kitty'

Plug 'vim-scripts/DoxygenToolkit.vim'
" TypeScript plugin
" Plug 'Quramy/tsuquyomi'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" Git plugin (https://github.com/tpope/vim-fugitive)
Plug 'tpope/vim-fugitive'
" Show git changes next to line numbers
Plug 'airblade/vim-gitgutter'

" Rainbow brackets plugin
" Plug 'junegunn/rainbow_parentheses.vim'
Plug 'frazrepo/vim-rainbow'

" Color schemes
Plug 'dikiaap/minimalist' " colorscheme minimalist
Plug 'drewtempelmeyer/palenight.vim' " colorscheme palenight
Plug 'mhartington/oceanic-next'
Plug 'marko-cerovac/material.nvim'

" Only install these plugins if we're running neovim, not vim
if has('nvim')
    Plug 'github/copilot.vim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'p00f/nvim-ts-rainbow'
	Plug 'JoosepAlviste/nvim-ts-context-commentstring'
    Plug 'rockerBOO/boo-colorscheme-nvim' " colorscheme boo
endif

" Detects indent style of currently opened file and adjusts accordingly
" Plug 'ciaranm/detectindent'
call plug#end()

let g:vimspector_enable_mappings = 'HUMAN'

" ------------------------ VIM-FUGITIVE SETTINGS -----------------------
" command
cnoreabbrev GA Git add %
cnoreabbrev GDi Git diff % 

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

" Open NERDTree whenever vim is started and put the cursor back into the
" opened file.
autocmd vimenter * NERDTree | wincmd p
let NERDTreeRespectWildIgnore=1

" Open NERDTree when 'vim' command is run. You no longer have to type 'vim .'
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim when NERDTree is the last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Open the exiting NERDTree on each new tab
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif


" --------------------------- NERDCOMMENTER SETTINGS ---------------------------

" Comment out the current line
" noremap <expr> <C-/> NERDComment("n", "Toggle")
inoremap <C-/> <esc><Plug>NERDCommenterToggle
nnoremap <C-/> <Plug>NERDCommenterToggle
let g:NERDSpaceDelims = 1



" ---------------------------- COLORSCHEME SETTINGS ----------------------------

set t_Co=256
if has("termguicolors")
    set termguicolors
endif

if has('nvim')
    " colorscheme palenight
    " let g:palenight_terminal_italics = 1

    " colorscheme OceanicNext

	colorscheme material
else
    colorscheme minimalist
endif

" if colorscheme is material
if g:colors_name == "material"

	if has('nvim')
lua << EOF
require('material').setup({
    contrast = {
        sidebars = false,
        line_numbers = false
	},
    italics = {
        comments = true
    },
    disable = {
		-- colored_cursor = true
	},
    custom_colors = {
        -- yellow = "#AB47BC"
    },
	custom_highlights = {
		Cursor = {
            -- bg = "#FFCC00",
            bg = "#AB47BC",
            fg = "#1B1E2B"
		},
		Cursor = {
            -- bg = "#FFCC00",
            bg = "#AB47BC",
            fg = "#1B1E2B"
		},
        RedrawDebugClear = { bg = "#AB47BC" },
	}
})
EOF
	endif

	lua require('material.functions').change_style('palenight')
endif

" -------------------------------- FZF SETTINGS --------------------------------

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
nnoremap <silent> <C-P> :call fzf#run(fzf#wrap({
            \ 'sink': 'e',
            \ 'source': 'fdfind --type f --hidden --follow --exclude .git --exclude node_modules --exclude dist',
            \ 'options': '--margin 2% --padding 1%',
            \ 'window': { 'width': 0.9, 'height': 0.7 }
            \ }))<CR>

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
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction

function! s:show_documentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
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

" use \. to show fix suggestions
" nmap <leader>. :CocFix<CR>
" imap <leader>. <C-O>:CocFix<CR>
nmap <leader>. :call CocAction("codeAction")<CR>
nmap <C-.> <Plug>(coc-codeaction-selected)
xmap <C-.> <Plug>(coc-codeaction-selected)
imap <C-.> <Plug>(coc-codeaction-cursor)
" nmap <C-.> :call CocAction("codeAction")<CR>
imap <leader>. <C-O>:call CocAction("codeAction")<CR>

" Add `:Format` command to format the current buffer
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 Lint :call CocActionAsync('runCommand', 'eslint.executeAutofix')
" todo: does not work
" nnoremap <silent> \ef :call <SID>CocAction('format')<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
if empty(maparg("<Tab>", "i", 0, 1))
	inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()
endif
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif


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
    ensure_installed = { "c", "cpp", "python", "javascript", "typescript", "jsdoc", "html", "css" },
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
    },
    context_commentstring = {
		enabled = true
	},
    rainbow = {
		enable = true,
		extended_mode = true -- Also highlight non-bracket delimeters like tags. boolean or table: lang -> boolean
	}
}
EOF
endfunction

if has("nvim")
    call ConfigureTreeSitter()
endif



" --------------------------------- TABPAGE BAR --------------------------------

lua << EOF
require("bufferline").setup{
    options = {
		-- "buffers" to show all opened buffers in the tab bar, "tabs" to only show tabpages
		mode = "tabs",
        diagnostics = "coc",
		-- Can be "slant", "thick", "thin", or a table with 2 custom separators
		separator_style = "slant"
        -- This triangle is \u25b6, but doesn't seem to work well
		-- separator_style = { "▶", "▶" }
	}
}
EOF



" --------------------------------- STATUS BAR ---------------------------------
let g:airline_theme = 'bubblegum'
" ---- Symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep='' " \uE0B0
let g:airline_right_sep='' " \uE0B2
let g:airline_symbols.branch='' " \uE725



" ---- Status bar customization

" Don't show empty status bar sections
let g:airline_skip_empty_sections = 1

" Don't show encoding/line ending in status bar if it's the usual
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" let g:airline_section_z+="%p%%%#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#%#__accent_bold#%{g:airline_symbols.colnr}%v%#__restore__#"
" let g:airline_section_z="%l:%v %#__accent_bold#%{g:airline_symbols.maxlinenr}%#__restore__# %p%%"

" Customize Z section (line/col number)
let g:airline_section_z="%l:%v "
let g:airline_section_z = g:airline_section_z . "%#__accent_bold#%{g:airline_symbols.maxlinenr}%#__restore__# "
let g:airline_section_z = g:airline_section_z . "%p%%"

" CoC Configuration
let airline#extensions#coc#error_symbol=""
let airline#extensions#coc#warning_symbol=""

function! CopilotStatus()
	let l:status = ""
	if copilot#Enabled()
		let l:status = " "
	elseif ! empty(copilot#Agent().StartupError())
		let l:status = " "
	else
		let l:status = " "
	endif

	return l:status
endfunction

call airline#parts#define_function('copilot', 'CopilotStatus')
call airline#parts#define_minwidth('copilot', 20)
let g:airline_section_y = airline#section#create_right(['ffenc', 'copilot'])


" -----------------------------------------------------------------------------
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
  " Check if buffer is NERDTree
  " if execute("setl ft?") =~? "nerdtree"
  "   " NERDTree status line
  "   set statusline=
  "   set statusline+=%#CursorLine#
  "   set statusline+=%{expand('%:p:h:t')}\        " Root folder path
  "   " set statusline+=${StatuslineGit()}
  " else
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
    set statusline+=%{coc#status()}
    " set statusline^=%{coc#status()}%{get(b:, 'coc_current_function', '')}

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
  " endif
endfunction

" autocmd BufEnter,TabEnter,WinEnter,BufWinEnter * :call CreateStatusLine()


" ------------------------- KEY BINDINGS --------------------------

" nmap di <Plug>DetectIndent<CR> | call CreateStatusLine()

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
