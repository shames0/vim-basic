" --- Essential ---
set nocompatible                " Use Vim defaults, not Vi-compatible (must be early!)
set encoding=utf-8              " Use UTF-8 encoding
syntax enable                   " Enable syntax highlighting
filetype plugin indent on       " Enable filetype detection, plugins, and indentation

" --- User Interface & Editing ---
set number                      " Show line numbers
set relativenumber              " Show relative numbers (combines with 'number')
set scrolloff=15                " Keep 15 lines visible above/below cursor when scrolling
set termguicolors               " Enable true color support in terminal (important for modern colorschemes)
set background=dark             " Assume a dark background (Solarized Dark needs this)
set showcmd                     " Show partial commands in the last line
set wildmenu                    " Enhanced command-line completion
set hidden                      " Allow switching buffers without saving
" set signcolumn=yes            " Show signs in the sign column (for LSP diagnostics, etc.)
" set updatetime=100            " Faster updates for CursorHold events (e.g., LSP diagnostics)
set laststatus=2                " Always show the status line

" --- Search ---
set incsearch                   " Show matches incrementally while searching
set hlsearch                    " Highlight all search matches
set ignorecase                  " Ignore case when searching
set smartcase                   " Override ignorecase if search pattern has uppercase letters

" --- Indentation ---
set tabstop=4                   " Number of visual spaces per tab
set softtabstop=4               " Number of spaces Vim uses for Tab key in Insert mode
set shiftwidth=4                " Number of spaces used for auto-indentation (>>, <<)
set expandtab                   " Use spaces instead of actual Tab characters

" --- Optional: Better Behavior ---
" set mouse=a                   " Enable mouse support in all modes (optional)
" set wrap                      " Disable line wrapping (personal preference)
set list                        " Show invisible characters (tabs, trailing whitespace)
set listchars=tab:>·,trail:·    " Define how invisible characters look (if 'list' is set)
colorscheme retrobox


" --- Statusline
set statusline=
set statusline+=%f\ %h%m%r       " Normal file info
set statusline+=%{%GitBranch()%} " Insert the Git branch, re-evaluated for highlighting
set statusline+=%=               " Separator and other information
set statusline+=\ %{hostname()}\ \|
set statusline+=\ %{&filetype}\ \|
set statusline+=\ %{(&fenc!=''\ ?\ &fenc\ :\ &enc)}\ \|
set statusline+=\ %l:%c%V\ %p%%  " set statusline+=\ %{getcwd()}

" --- Enable Git branch detection ---
" determine Git branch and cache it
function! GitBranchRefresh()
  if executable('git')
    let l:file_path = expand('%:p:h')

    " Check if a file is open and in a git repository
    if !empty(l:file_path) && system("git -C " . l:file_path . " rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
      let l:branch_name = system("git -C " . l:file_path . " rev-parse --abbrev-ref HEAD 2>/dev/null")
      " Trim to remove any trailing newlines or spaces
      let b:git_branch_name = trim(l:branch_name)
    else
      let b:git_branch_name = ''
    endif
  else
      let b:git_branch_name = ''
  endif
endfunction

" display the cached Git branch name
function! GitBranch()
  let l:branch_name = get(b:, 'git_branch_name', '')

  " Check if there is a branch name to display
  if !empty(l:branch_name)
    return '|  ' . l:branch_name
  else
    return ''
  endif
endfunction

" update the Git branch on key events
augroup GitBranchStatus
  autocmd!
  " On entering a buffer or directory, refresh the branch name
  autocmd BufEnter,DirChanged * call GitBranchRefresh()
augroup END


" --- Highlight trailing whitespace and spaces before tabs ---
highlight UnwantedWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match UnwantedWhitespace /\s\+$\| \+\ze\t/
autocmd InsertEnter * match UnwantedWhitespace /\s\+\%#@<!$\| \+\ze\t/
autocmd InsertLeave * match UnwantedWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinLeave * call clearmatches()
