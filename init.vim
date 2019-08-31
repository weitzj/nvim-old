
" Lean 'n' Clean Neovim Config
" ----------------------------------------------------------------------------

call plug#begin()

" ----------------------------------------------------------------------------
" MARK: - Global Variables
" ----------------------------------------------------------------------------

let nvimDir  = '$HOME/.config/nvim'
let cacheDir = expand(nvimDir . '/.cache')

" ----------------------------------------------------------------------------
" MARK: - Basic Useful Functions
" ----------------------------------------------------------------------------

function! PreserveCursorPosition(command)
	" preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")

	" do the business:
	execute a:command

	" clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

function! StripTrailingWhitespace()
	call PreserveCursorPosition("%s/\\s\\+$//e")
endfunction

function! CreateAndExpand(path)
	if !isdirectory(expand(a:path))
		call mkdir(expand(a:path), 'p')
	endif

	return expand(a:path)
endfunction

function! CloseWindowOrKillBuffer()
	let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

	" never bdelete a nerd tree
	if matchstr(expand("%"), 'NERD') == 'NERD'
		wincmd c
		return
	endif

	if number_of_windows_to_this_buffer > 1
		wincmd c
	else
		bdelete
	endif
endfunction


" ----------------------------------------------------------------------------
" MARK: - Basic Vim Configuration
" ----------------------------------------------------------------------------

let mapleader = "," " Set mapleader
let g:mapleader = ","

set mouse=a " Allow mouse usage
set mousehide

set encoding=utf-8 " Set right encoding and formats
set fileformat=unix
set nrformats-=octal

set spelllang=en_us,fr " Spell check english and french

set hidden " Deal nicely with buffers and switch without saving
set autowrite
set autoread

set modeline " Allow modeline for per file formating using
set modelines=5

set backspace=indent,eol,start " Makes backspace behave like most editors

set clipboard+=unnamedplus

set hlsearch   " Highlight search
set incsearch  " Highlight pattern matches as you type
set ignorecase " Ignore case when using a search pattern
set smartcase  " Override 'ignorecase' when pattern has upper case character


" ----------------------------------------------------------------------------
" MARK: - Backup Configuration
" ----------------------------------------------------------------------------

set history=1000 " Remember everything
set undolevels=1000

" Nice persistent undos
let &undodir=CreateAndExpand(cacheDir . '/undo')
set undofile

" Keep backups
let &backupdir=CreateAndExpand(cacheDir . '/backup')
set backup

" Keep swap files, can save your life"
let &directory=CreateAndExpand(cacheDir . '/swap')
set swapfile


" ----------------------------------------------------------------------------
" MARK: - Basic UI Configuration
" ----------------------------------------------------------------------------

set number       " Show line numbers
set showcmd      " Show last command
set lazyredraw   " Don't redraw when not needed
set scrolloff=10 " Keep cursor from reaching end of screen
set laststatus=2 " Always show the status line
set noshowmode   " Hide the mode on last line as we use Vim Airline

set cursorline " Highlight current line
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline

set autoindent " Auto indent line on CR
set smarttab   " Add tab and backspace like you'd like to
set shiftround " Always indent with a multiple of shiftwidth

set tabstop=4 " Default indentation is 4 spaces long and uses tabs, not spaces...
set softtabstop=4
set shiftwidth=4
set expandtab
" set noexpandtab

set ttyfast

set list " Show invisible characters
set listchars=tab:\|\ ,trail:•

set linebreak " Show linebreaks
let &showbreak='↪ '

set showmatch " Hightlight brackets
set matchtime=2

set wildmenu           " Tab complete commands
set wildmode=list:full " Show full list of commands
set wildignorecase
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

set splitbelow " Split windows below
set splitright " Split windows right

set noerrorbells " Turn of error notifications
set novisualbell

set nofoldenable " Disable folding
" set background=dark


" ----------------------------------------------------------------------------
" MARK: - Colors Themes
" ----------------------------------------------------------------------------

" Gruvbox setup
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
" ----------------------------------------------------------------------------
" MARK: - UI Plugins
" ----------------------------------------------------------------------------

Plug 'vim-airline/vim-airline'
Plug 'zhaocai/GoldenView.Vim', {'on': '<Plug>ToggleGoldenViewAutoResize'}
" Plug 'luochen1990/rainbow'
" Plug 'thiagoalessio/rainbow_levels.vim'

" Vim Airline setup
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2

" GoldenView setup
let g:goldenview__enable_default_mapping=0
nmap <F4> <Plug>ToggleGoldenViewAutoResize

" Rainbow Parentheses setup
let g:rainbow_conf = {'ctermfgs': ['245', '142', '109', '175', '167', '208', '214', '223']}

" Rainbow Levers setup
let g:rainbow_levels = [
			\{'ctermfg': 142, 'guifg': '#b8bb26'},
			\{'ctermfg': 108, 'guifg': '#8ec07c'},
			\{'ctermfg': 109, 'guifg': '#83a598'},
			\{'ctermfg': 175, 'guifg': '#d3869b'},
			\{'ctermfg': 167, 'guifg': '#fb4934'},
			\{'ctermfg': 208, 'guifg': '#fe8019'},
			\{'ctermfg': 214, 'guifg': '#fabd2f'},
			\{'ctermfg': 223, 'guifg': '#ebdbb2'},
			\{'ctermfg': 245, 'guifg': '#928374'}]


" ----------------------------------------------------------------------------
" MARK: - Buffer Plugins
" ----------------------------------------------------------------------------

Plug 'duff/vim-bufonly'
Plug 'qpkorr/vim-bufkill'


" ----------------------------------------------------------------------------
" MARK: - Startup Plugins
" ----------------------------------------------------------------------------

Plug 'mhinz/vim-startify', {'on': 'Startify'}

" Vim Startify setup
let g:startify_session_dir = CreateAndExpand(cacheDir . '/sessions')
let g:startify_change_to_vcs_root = 1
let g:startify_show_sessions = 1
nnoremap <F1> :Startify<cr>


" ----------------------------------------------------------------------------
" MARK: - Editing Plugins
" ----------------------------------------------------------------------------

Plug 'editorconfig/editorconfig-vim'

Plug 'kristijanhusak/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

" Rainbow
let g:rainbow_active = 1

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Undotree setup
nnoremap <silent> <F5> :UndotreeToggle<CR>

" Comment strings
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" ----------------------------------------------------------------------------
" MARK: - Language Plugins
" ----------------------------------------------------------------------------

" Misc
Plug 'tpope/vim-endwise'

" Vim Polyglote
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['markdown', 'c', 'cpp', 'h']

" C++
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp', 'c', 'h'] }

" Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_fmt_command = "goimports"

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
let g:racer_cmd = "/home/weitz/.cargo/bin/racer"
let g:rustfmt_autosave=1
let g:racer_experimental_completer = 1
au FileType rust set makeprg=cargo\ build\ -j\ 4
au FileType rust nmap <leader>t :!cargo test<cr>
au FileType rust nmap <leader>r :!RUST_BACKTRACE=1 cargo run<cr>
au FileType rust nmap <leader>c :term cargo build -j 4<cr>
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" Terraform
Plug 'hashivim/vim-terraform'
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" Neomake
Plug 'neomake/neomake'
let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = { 'text': '⚠️','texthl': 'NeomakeWarningSign'}

" YAML
" Plug 'chase/vim-ansible-yaml'
Plug 'pearofducks/ansible-vim'

" Ruby
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" Markdown
autocmd BufRead,BufNewFile *.md,*.markdown setlocal filetype=pandoc.markdown " Automatically set filetype for Markdown files"
Plug 'vim-pandoc/vim-pandoc', { 'for': ['markdown', 'pandoc.markdown', 'md'] }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': ['markdown', 'pandoc.markdown', 'md'] }
Plug 'shime/vim-livedown', { 'for': ['markdown', 'pandoc.markdown', 'md'] }

" Pandoc setup
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#conceal#blacklist = ['block', 'codeblock_start', 'codeblock_delim']
let g:pandoc#syntax#conceal#cchar_overrides = {'li': '*'}
let g:pandoc#formatting#equalprg = "pandoc -t gfm --wrap=none"

" Livedown setup
let g:livedown_autorun = 0
let g:livedown_open = 1
let g:livedown_port = 1337
let g:livedown_browser = "chrome"
map <leader>gm :call LivedownPreview()<CR>

" Fish shell
Plug 'dag/vim-fish'

" ----------------------------------------------------------------------------
" Autocompletion & Snippets Plugins
" ----------------------------------------------------------------------------
Plug 'autozimu/LanguageClient-neovim', {
			\ 'branch': 'next',
			\ 'do': 'bash install.sh',
			\ }


""----------------------------------------------------------------------------
" ncm2 - https://github.com/ncm2/ncm2/issues/19
" ----------------------------------------------------------------------------

" assuming you're using vim-plug: https://github.com/junegunn/vim-plug
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" https://github.com/ncm2/ncm2
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" make it fast
let ncm2#popup_delay = 5
let ncm2#complete_length = [[1, 1]]
" Use new fuzzy based matches
let g:ncm2#matcher = 'substrfuzzy'

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
" https://github.com/lifepillar/vim-mucomplete/issues/81
let g:endwise_no_mappings = 1
inoremap <silent> <expr> <CR> ((pumvisible() && empty(v:completed_item)) ?  "\<c-y>\<cr>" : (!empty(v:completed_item) ? ncm2_ultisnips#expand_or("", 'n') : "\<CR>" ))

" close scratch window in completion
" https://gregjs.com/vim/2016/configuring-the-deoplete-asynchronous-keyword-completion-plugin-with-tern-for-vim/
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-go'

" Plug 'ncm2/ncm2-match-highlight'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-cssomni'
Plug 'ObserverOfTime/ncm2-jc2', {'for': ['java', 'jsp']}
Plug 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp']}

" Dictionary
Plug 'filipekiss/ncm2-look.vim'
let g:ncm2_look_enabled = 1

" more dictionaries"
let ncm2_look_use_spell = 0

" Python
Plug 'HansPinckaers/ncm2-jedi'  " fast python completion (use ncm2 if you want type info or snippet support)
" Plug 'ncm2/ncm2-jedi'
Plug 'davidhalter/jedi-vim'   " jedi for python

" semantic completion"
" Plug 'zxqfl/tabnine-vim'


""----------------------------------------------------------------------------
" UltiSnips
" ----------------------------------------------------------------------------
"  
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ladislas/vim-snippets'

" c-j c-k for moving in snippet
imap <expr> <c-u> ncm2_ultisnips#expand_or("\<Plug>(ultisnips_expand)", 'm')
smap <c-u> <Plug>(ultisnips_expand)
let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0


""----------------------------------------------------------------------------
" YouCompleteMe
" ----------------------------------------------------------------------------

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer', 'for': ['cpp', 'c', 'h', 'ino', 'ruby']}
Plug 'tenfyzhong/CompleteParameter.vim'


" YouCompleteMe setup
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '!!'

" CompleteParameter setup
inoremap <silent><expr> ( complete_parameter#pre_complete("()")
smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)


" ----------------------------------------------------------------------------
" Linting
" ----------------------------------------------------------------------------

let g:ale_completion_enabled = 1
Plug 'w0rp/ale'
" Error and warning signs.
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '⚠'

" ----------------------------------------------------------------------------
" Denite Plugins
" ----------------------------------------------------------------------------

Plug 'Shougo/denite.nvim'
Plug 'Shougo/neoyank.vim'


" ----------------------------------------------------------------------------
" MARK: - Navigation Plugins
" ----------------------------------------------------------------------------

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" NERDTree setup
let NERDTreeShowHidden=0
let NERDTreeQuitOnOpen=0
let g:NERDTreeUseSimpleIndicator=1
let NERDTreeShowLineNumbers=1
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=0
let NERDTreeIgnore=['\.hg', '.DS_Store']
let g:NERDTreeBookmarksFile = CreateAndExpand(cacheDir . '/NERDTree/NERDTreeShowBookmarks')

nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeFind<CR>


" ----------------------------------------------------------------------------
" Source Control Management Plugins
" ----------------------------------------------------------------------------

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Gitgutter setup
let g:gitgutter_realtime=0

" Fugitive setup
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>

autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
autocmd BufReadPost fugitive://* set bufhidden=delete

" ----------------------------------------------------------------------------
" MARK: - SEARCH files, grep
" ----------------------------------------------------------------------------
if empty(glob("~/bin/rg"))
	 !mkdir -p ~/bin/
	 !curl -fLo /tmp/rg.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
	 !tar xzvf /tmp/rg.tar.gz --directory /tmp
	 !cp /tmp/ripgrep-0.10.0-x86_64-unknown-linux-musl/rg ~/bin/rg
endif

Plug 'mileszs/ack.vim'
let g:ackprg = '~/bin/rg --vimgrep --no-heading'

Plug 'ctrlpvim/ctrlp.vim'

let g:ctrlp_map	 = '<c-p>'
" let g:ctrlp_cmd	 = 'CtrlPMixed'
" let g:ctrlp_cmd	 = 'CtrlPMixed'
nnoremap <leader>b :CtrlPBufTagAll<CR>
let g:ctrlp_user_command = '~/bin/rg --files %s'
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }    " Install fzf for user
Plug 'junegunn/fzf.vim'

if !empty(glob("~/.fzf/bin/fzf"))
	if empty(glob("~/.fzf/bin/rg"))
		silent !curl -fLo /tmp/rg.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
		silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
		silent !cp /tmp/ripgrep-0.10.0-x86_64-unknown-linux-musl/rg ~/.fzf/bin/rg
	endif
endif


" fzf config
" not working since /dev/tty cannot be opened. Using ctlr-p plugin instead
" nmap <C-p> :Files<cr>
imap <c-x><c-l> <plug>(fzf-complete-line)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

let g:rg_command = '
\ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
\ -g "*.{ts,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
\ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
"
" Ctrl-Space for completions. Heck Yeah!
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
        \ "\<lt>C-n>" :
        \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
        \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
        \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>





" ----------------------------------------------------------------------------
" MARK: - Stop Loading Plugins
" ----------------------------------------------------------------------------

call plug#end()

" Disable Jedi-vim autocompletion and enable call-signatures options
" let g:jedi#auto_initialization = 1
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#smart_auto_mappings = 0
" let g:jedi#popup_on_dot = 0
" let g:jedi#completions_command = ""
" let g:jedi#show_call_signatures = "1"

let g:gruvbox_bold = 0
" colorscheme gruvbox

" colorscheme PaperColor
set background=light
" set background=dark


" ----------------------------------------------------------------------------
" Misc setup
" ----------------------------------------------------------------------------

" When writing a buffer (no delay).
" call neomake#configure#automake('w')
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
" call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing (no delay).
" call neomake#configure#automake('rw', 1000)
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
" call neomake#configure#automake('nrwi', 500)

" ----------------------------------------------------------------------------
" denite setup
" ----------------------------------------------------------------------------


" Set denite leader
nmap <space> [denite]
nnoremap [denite] <nop>

" Set useful denite mappings
nnoremap <silent> [denite]y :<C-u>Denite neoyank -direction=dynamictop -buffer-name=yanks<cr>
nnoremap <silent> [denite]t :<C-u>Denite -direction=dynamictop -buffer-name=files file<cr>
nnoremap <silent> [denite]l :<C-u>Denite -direction=dynamictop -buffer-name=line line<cr>
nnoremap <silent> [denite]b :<C-u>Denite -direction=dynamictop -buffer-name=buffers buffer<cr>


" ----------------------------------------------------------------------------
" MARK: - Mappings
" ----------------------------------------------------------------------------

" Call basic functions
nmap <leader>f$ :call StripTrailingWhitespace()<CR>
nmap <leader>fef :call PreserveCursorPosition('normal gg=G')<CR>

" Quick save
nnoremap <leader>w :w<cr>

" Add newline with return key
nmap <CR> o<Esc>


" Quicker ESC
inoremap jj <ESC>

" Save with sudo
cmap w!! %!sudo tee > /dev/null %

" Sort text
vmap <leader>ss :sort<cr>

" Remap arrow keys
nnoremap <down> :tabprev<CR>
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>

" Windows/Buffers motion keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>s <C-w>s
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>vsa :vert sba<cr>

" Change cursor position in insert mode
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>

" Sane regex search
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap :s/ :s/\v

" Turn search highlight on and off
nnoremap <BS> :set hlsearch! hlsearch?<cr>

" Screen line scroll
nnoremap <silent> j gj
nnoremap <silent> k gk

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Toggles smart indenting while pasting, A.K.A lifesaver
set pastetoggle=<F6>

" Reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Make Y consistent with C and D. See :help Y.
nnoremap Y y$

" Hide annoying quit message
nnoremap <C-c> <C-c>:echo<cr>

" Window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

" Quick buffer open
nnoremap gb :ls<cr>:e #

" Tab shortcuts
map <leader>tn :tabnew<CR>
map <leader>tc :tabclose<CR>

" Spell check on/off
nmap <silent> <leader>sp :set spell!<CR>


" ----------------------------------------------------------------------------
" MARK: - End of Configuration
" ----------------------------------------------------------------------------

" Set color scheme

" Finish tuning Vim
filetype plugin indent on
syntax on
