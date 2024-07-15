" Make backspace work like most other programs.
set backspace=2
set nocompatible
set number
set encoding=utf-8
set ruler
set clipboard=unnamed
set tags=./tags,tags;$HOME
set hidden
set updatetime=100
set mouse=a
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set ignorecase
set smartcase
set wildmenu
set wildmode=longest:list,full


nmap <F1> <nop>
nmap \| :vsplit<CR>
nmap \_ :split<CR>

highlight Comment cterm=italic
filetype plugin indent on
syntax enable
set background=dark

set cursorline
colorscheme gruvbox

command! -nargs=1 E edit %:p:h/<args>

augroup lang_matlab
    autocmd!
    autocmd FileType matlab      setlocal ts=4 sw=4 et
augroup END

autocmd BufNewFile * silent! lcd %:p:h


function! s:PrintShortcut()
	call inputsave()
	let g:name = input("Variable name, please: ")
	call inputrestore()
endfunction

nnoremap pr oprint(f"<C-\><C-o>:call <SID>PrintShortcut()<CR><C-r>=name<CR>: {<C-r>=name<CR>}")<ESC>

function! Current_filename()
    return string(expand('%:p'))
endfunction

nnoremap <RightMouse> *

nnoremap <leader>y "+y
nnoremap <C-V> "+p
vnoremap <leader>y "+y
vnoremap <C-V> "+p

" Source ~/.vimrc file.
nnoremap <F2> :source ~/.config/nvim/init.vim<CR>

" Put the cursor on the end of a line.
nnoremap R $
vnoremap R $

nnoremap yb {V}y}k

" Show full file path.
nnoremap <C-g> 1<C-g>

" Map Esc to jj.
inoremap jj <Esc>

" Let Enter exit visual mode.
vnoremap <CR> <Esc>

" Jump to beginning of a line.
nnoremap <S-e> <S-^>

" Paste without overwriting.
noremap <Leader>p "0p
noremap <Leader>P "0P
vnoremap <Leader>p "0p

set nocursorline
" Toggle off search highlighting.
highlight Search guifg=Orange guibg=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE
highlight IncSearch guifg=Orange guibg=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE
highlight link SearchCursor WarningMsg
set termguicolors
highlight Cursorline cterm=NONE ctermbg=white
let g:python_highlight_space_errors = 0




nnoremap M :silent! nohls<CR>

" Place a python debug on line below.
nnoremap db oimport pdb; pdb.set_trace()<Esc>

" Move between vim windows without ctrl + w.
nnoremap <C-j> <C-W><C-j>
nnoremap <C-k> <C-W><C-k>
nnoremap <C-l> <C-W><C-l>
nnoremap <C-h> <C-W><C-h>

vnoremap <Up> dkP`[V`]
vnoremap <Down> dp`[V`]

nnoremap = <C-W>=

" Paste at end of line.
nnoremap pa $p

" Paste at bottom of buffer.
nmap pb G<Esc>:pu<CR>

" Paste on line directly under cursor.
nnoremap pu :pu<CR>
nnoremap pe e h p

nnoremap yl v$y
nnoremap dl d$
nnoremap cl c$

command! W write

" Automatically find and import the word under the cursor.
map <C-s> :ImportName<CR><C-o>

" Remove unnecessary spaces from line ends.
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR> :%s/<C-V><C-M>//g<CR>

" Enable all syntax highlighting in python.
let g:python_highlight_all=1

call plug#begin('~/.config/nvim/plugged')

" Silver searcher.
Plug 'rking/ag.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Use fzf with bat for syntax-highlighted previews
let g:fzf_preview_command = 'bat --style=numbers --color=always --line-range :500 {}'
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-p': g:fzf_preview_command,
\ }

command! -bang -nargs=* FZF
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
"function! FzfGitRoot()
"    " Find the Git root directory
"    let l:git_root = system("git rev-parse --show-toplevel")

"    " Remove trailing newline from system output
"    let l:git_root = substitute(l:git_root, '\n\+$', '', '')

"    " Change directory to the git root
"    execute 'cd' l:git_root

"    " Call FZF
"    FZF

"    " Change directory back to the original directory
"    execute 'cd' '-'
"endfunction
"nnoremap <C-p> :FZF<CR>


function! FzfGitRootOrFallback()
    " Attempt to find the Git root directory, suppressing error messages
    let l:git_root = system("git rev-parse --show-toplevel 2> /dev/null")
    let l:git_root = substitute(l:git_root, '\n\+$', '', '')

    " Store the current directory to return later
    let l:current_dir = getcwd()

    " Check if the git root directory was successfully found
    if v:shell_error == 0 && isdirectory(l:git_root)
        " Change directory to the git root
        execute 'cd' l:git_root
    endif

    " Call FZF
    call fzf#run(fzf#wrap())

    " Return to the original directory, whether or not we changed it
    execute 'cd' l:current_dir
endfunction

" Map Ctrl-P to the new function for searching
nnoremap <C-p> :call FzfGitRootOrFallback()<CR>







let g:ag_prg='ag --vimgrep --ignore "*.log,*.tmp,*.bak",*.ipynb'
function! RgQuery(query) abort
    if a:query =~ '^-F '
        let l:query = substitute(a:query, '^-F ', '', '')
        call fzf#vim#grep('rg --fixed-strings --column --line-number --no-heading --color=always '.shellescape(l:query), 1, fzf#vim#with_preview(), 0)
    else
        call fzf#vim#grep('rg --column --line-number --no-heading --color=always '.shellescape(a:query), 1, fzf#vim#with_preview(), 0)
    endif
endfunction

command! -bang -nargs=* Rg call RgQuery(<q-args>)

" Tag bar.
Plug 'majutsushi/tagbar'
nmap <C-t> :TagbarToggle<CR> zz
let g:tagbar_sort = 0
let g:tagbar_autoclose = 1

" Show the number of matching search items.
Plug 'google/vim-searchindex'

"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-easytags'
"let g:easytags_syntax_keyword = 'always'
"let g:easytags_async=1
"let g:easytags_auto_highlight=0

" Get all the python syntax.
Plug 'vim-python/python-syntax'

Plug 'nvie/vim-flake8'

" Automatically disable search highlighting on cursor move.
Plug 'romainl/vim-cool'


Plug 'zivyangll/git-blame.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

set completeopt-=preview
nnoremap <leader>g g<C-]>
nnoremap S g<C-]>

Plug 'mg979/vim-visual-multi'
let g:VM_maps = {}
let g:VM_maps['Add Cursor Down'] = '<C-z>'
let g:VM_maps['Find Under'] = '<C-f>'
let g:VM_maps['Find Subword Under'] = '<C-f>'
let g:VM_reselect_first = 1


Plug 'scrooloose/nerdtree'
let NERDTreeIgnore = [ '.*prof.*', '\.prof', '__pycache__', '\.pyc$', '\.o$', '\.swp',  '*\.swp',  'node_modules/', 'tags', '*.asv*']
let NERDTreeShowHidden=0
let NERDTreeMinimalUI=1
let g:NERDTreeWinPos = "left"
map <C-n> :NERDTreeToggle<CR>
nmap ,n :NERDTreeFind<CR>




"Use my sublime-like color scheme.
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-fugitive'


Plug 'preservim/nerdcommenter'
let NERDDefaultAlign = 'left'

Plug 'mgedmin/python-imports.vim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'will133/vim-dirdiff'


Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='gruvbox'

" Configure slime for REPL with vim.
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}
let g:slime_dont_ask_default = 1
xmap <C-v><C-v> <Plug>SlimeRegionSend
nmap <C-v><C-v> <Plug>SlimeParagraphSend
nmap <C-v>v <Plug>SlimeConfig
nnoremap t :bnext<CR>
nnoremap T :bprevious<CR>

" list buffers and jump to a chosen one
function! ListBuffers()
    redir => ls_output
    silent exec 'ls'
    redir END

    let list = substitute(ls_output, '"\(\f*/\)*\(\f*\)"', '\=submatch(2)', "g")

    echo list
endfunction


function! ChooseBuffer()
    " Display a list of open buffers with filenames
    echo "Buffers:"
    for b in range(1, bufnr('$'))
        if bufexists(b) && buflisted(b)
            let bufname = fnamemodify(bufname(b), ':t')
            echo b . ": " . bufname
        endif
    endfor

    let l:bufname = input('Choose buffer: ')

    " If the input is numeric, treat it as a buffer number
    if l:bufname =~ '^\d\+$'
        let l:bufnum = str2nr(l:bufname)
        if bufexists(l:bufnum) && buflisted(l:bufnum)
            execute 'buffer' l:bufnum
            return
        else
            echo "Buffer number " . l:bufnum . " does not exist or is not listed."
            return
        endif
    endif

    " Otherwise, treat it as a pattern to match filenames
    let l:matching_buffers = []

    for b in range(1, bufnr('$'))
        if bufexists(b) && buflisted(b)
            let current_bufname = fnamemodify(bufname(b), ':t')
            if match(current_bufname, l:bufname) != -1
                call add(l:matching_buffers, b)
            endif
        endif
    endfor

    if len(l:matching_buffers) == 1
        execute 'buffer' l:matching_buffers[0]
    elseif len(l:matching_buffers) > 1
        echohl WarningMsg
        echo "\n"
        echom "Multiple buffers match, be more specific:"
        echohl None
        for b in l:matching_buffers
            echohl ErrorMsg
            echo ">>> " . b . ": " . fnamemodify(bufname(b), ':t')
            echohl None
        endfor
        call ChooseBuffer()
    else
        echo "No matching buffer found."
    endif
endfunction

nnoremap <Leader>t :call ChooseBuffer()<CR>


Plug 'qpkorr/vim-bufkill'
nnoremap <C-w> :BD!<CR>

Plug 'dart-lang/dart-vim-plugin'

Plug 'airblade/vim-gitgutter'

Plug 'iamcco/markdown-preview.vim'

nnoremap qo mz bi"<Esc>ea"<Esc> `z
nnoremap qoa i"<Esc>F(a"<Esc> vf) :s/, /", "/g<CR>






Plug 'jreybert/vimagit'
let g:magit_discard_untracked_do_delete=1


Plug 'easymotion/vim-easymotion'

let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0
map / <Plug>(easymotion-sn)
nnoremap L `. zz
"
command! -nargs=+ G cexpr system('g <args>')


Plug 'dense-analysis/ale'
Plug 'microsoft/pyright'

let g:ale_completion_enabled = 0
let g:ale_fixers={'python': ['autoimport', 'isort', 'black', 'autoflake'], 'cpp': ['clang-format']}
let g:ale_linters = {'python': ['pyright'], 'cpp': ['clangtidy', 'cppcheck', 'gcc']}

let g:ale_fixer_commands ={}
let g:ale_fixer_commands['black'] = '/usr/bin/black --target-version=py36 --line-length=95'

nnoremap <F3> :w<CR>:! /Users/aaronlevy/.pyenv/shims/black --target-version=py36 --line-length=95 '%:p'<CR>


"let g:ale_python_pyright_settings = {
"     \ 'plugins': {
"     \     'pyright': {
"     \         'autoImportCompletions': 'onEnter',
"     \     },
"     \ },
"     \ }

"let g:ale_python_pyright_settings = {
"     \ 'plugins': {
"     \     'pyright': {
"     \         'extraPaths': ['src'],
"     \     },
"     \ },
"     \ }
let g:ale_cpp_clangtidy_executable='clang-tidy'
let g:ale_cpp_gcc_executable='gcc'
let g:ale_cpp_parse_makefile=1
let g:ale_completion_enabled=1
let g:ale_completion_delay=300



let g:ale_disable_lsp = 0
let g:ale_enabled=0
let g:ale_c_clangformat_style_option='{BinPackArguments: false, BinPackParameters: false, ColumnLimit: 95}'
" Automatically find and import the word under the cursor.
"map <C-s> :ALEImport<CR>


Plug 'easymotion/vim-easymotion'
let g:EasyMotion_smartcase = 1
map / <Plug>(easymotion-sn)
nnoremap L `. zz
nnoremap <Leader>sp :if &paste \| set nopaste \| else \| set paste \| endif<CR>


"" FOLD LOGIC START
"" Disable automatic folding
"set nofoldenable
"set foldmethod=manual
"set foldtext=FoldText()
"nnoremap <space> za
"vnoremap <Space> zo
"nnoremap zM :call FoldCellsFunc()<CR>

"" Define your :FoldCells command
"command! FoldCells call FoldCellsFunc()



"function! FoldCellsFunc()
"    " Remember current line to come back to it after folding
"    let l:current_line = line(".")

"    " Unfold everything
"    normal! zE

"    " Variables to keep track of the folding range
"    let l:start_fold = 0
"    let l:end_fold = 0


"    " Iterate over all lines
"    for l:lnum in range(1, line("$"))
"        let l:line_text = getline(l:lnum)

"        "" Debugging output
"        "if l:lnum < 20
"        "    echo "Line" l:lnum ": " . l:line_text
"        "    echo "Start fold: " . l:start_fold . ", End fold: " . l:end_fold
"        "endif

"        " Folding logic
"        if l:line_text =~ '^# %%'
"            " If we are already in a fold, close it before starting a new one
"            if l:start_fold != 0
"                execute l:start_fold . "," . (l:lnum - 1) . "fold"
"            endif
"            " Start a new fold
"            let l:start_fold = l:lnum
"        endif
"    endfor

"    " Close any remaining open fold range
"    if l:start_fold != 0
"        execute l:start_fold . "," . line("$") . "fold"
"    endif

"    " Return to the original line
"    call cursor(l:current_line, 1)
"endfunction


"function! FoldText()
"    let firstLine = getline(v:foldstart+1)
"    if firstLine =~ '^#\+ #.*'
"        return getline(v:foldstart+1)
"    else
"        return '...' " or return an empty string ('') if you want nothing to be shown.
"    endif
"endfunction

"highlight CellSeparator1 cterm=bold ctermbg=LightGreen ctermfg=black gui=bold guibg=LightGreen guifg=black
"highlight CellSeparator2 cterm=bold ctermbg=150 ctermfg=black gui=bold guibg=LightMagenta guifg=black

"autocmd FileType python syn match CellSeparator1 /^# %%.*$/
"autocmd FileType python syn match CellSeparator2 /^# #.*$/
"" FOLD LOGIC END


Plug 'heavenshell/vim-pydocstring'
let g:pydocstring_formatter = 'numpy'
let g:pydocstring_doq_path = '/home/aaron/.pyenv/shims/doq'
nmap <silent> <C-_> <Plug>(pydocstring)
nnoremap <leader>d :Pydocstring<CR>

function! ExecuteJupyterAscendingSlime()
normal ma
write
let l:current_file = expand('%:p')
let l:current_line = line('.')
let l:cmd = 'python -m jupyter_ascending.requests.execute --filename ' .  substitute(l:current_file, $HOME, '~', '') . ' --line ' . l:current_line
"let l:cmd = 'python -m jupyter_ascending.requests.execute --filename ' . l:current_file . ' --line ' . l:current_line

call slime#send(l:cmd . "\n")
endfunction
"nnoremap <C-e> :call ExecuteJupyterAscendingSlime()<CR>
"inoremap <C-e> <Esc> :call ExecuteJupyterAscendingSlime()<CR>k

nnoremap <C-e> :Neopyter run current<CR>
function! ExecuteJupyterAscendingSlimeVisual()
    normal ma
    write
    let l:current_file = expand('%:p')
    let l:start_line = line("'<")
    let l:end_line = line("'>")

    " Execute the first line
    let l:cmd = 'python -m jupyter_ascending.requests.execute --filename ' .  substitute(l:current_file, $HOME, '~', '') . ' --line ' . l:start_line
    "let l:cmd = 'python -m jupyter_ascending.requests.execute --filename ' . l:current_file . ' --line ' . l:start_line
    call slime#send(l:cmd . "\n")

    " Initialize a flag to track whether a line starting with # %% is encountered
    let l:execute_next_line = 0

    " Loop over the subsequent lines in the selection
    for l:line_number in range(l:start_line + 1, l:end_line)
        " Check if the line starts with # %%
        let l:line_content = getline(l:line_number)
        if l:line_content =~ '^# %%'
            let l:execute_next_line = 1
        endif

        " Execute the line if the flag is set
        if l:execute_next_line == 1
            let l:cmd = 'python -m jupyter_ascending.requests.execute --filename ' .  substitute(l:current_file, $HOME, '~', '') . ' --line ' . l:line_number
            "let l:cmd = 'python -m jupyter_ascending.requests.execute --filename ' . l:current_file . ' --line ' . l:line_number
            call slime#send(l:cmd . "\n")
            let l:execute_next_line = 0
        endif
    endfor
endfunction
xnoremap <C-e> :<C-u>call ExecuteJupyterAscendingSlimeVisual()<CR>



function! MarkdownCell()
call append(line('.'), ['# %% [markdown]', '# #', '# %%'])
    execute "normal! 2j"
    startinsert!
endfunction
command! MD call MarkdownCell()

function! SplitCell()
call append(line('.'), ['# %%'])
    execute "normal! jo"
endfunction
command! SP call SplitCell()
nnoremap <Leader>bb :SP<CR>

if executable('xclip')
  " Ensure Vim uses the system clipboard for all yank, delete, change and put operations
  " set clipboard+=unnamedplus

" Mapping to copy to clipboard using xclip
vnoremap <Leader>y :w !xclip -selection clipboard<CR><CR>
nnoremap <Leader>y V:w !xclip -selection clipboard<CR><CR>
nnoremap <leader>p :let @" = system('xclip -selection clipboard -o')<CR>
endif

"Plug 'jupyter-vim/jupyter-vim'
"let g:jupyter_omnicfunc_ipython=1
"vnoremap <leader>X  :JupyterSendRange<CR>


Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Find files using Telescope command-line sugar.
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" Add the required plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'AbaoFromCUG/websocket.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'SUSTech-data/neopyter'
call plug#end()

lua << EOF
require("CopilotChat").setup({
  window = {
    layout = 'vertical',
    relative = 'cursor',
  },
  mappings = {
    reset = {
      normal ='<C-r>',
    },
  },
})
require("telescope").setup({
  defaults = {
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
  }
})
require('neopyter').setup({
    mode="direct",
    remote_address = "127.0.0.1:9001",
    file_pattern = { "*.ju.*" },
    on_attach = function(bufnr)
        -- do some buffer keymap
    end,
    highlight = {
        enable = true,
        shortsighted = false,
    }
})
EOF
nnoremap <leader>cq :lua require('CopilotChat').ask(vim.fn.input('Quick Chat: '), { selection = require('CopilotChat.select').buffer })<CR>
nnoremap <leader>ch :lua require('CopilotChat.actions'); require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').help_actions())<CR>
nnoremap <leader>cp :lua require('CopilotChat.actions'); require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions())<CR>
