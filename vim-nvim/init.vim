set nocompatible
set showmatch
set ignorecase
set mouse=v
set hlsearch
set incsearch
set tabstop=4
set softtabstop=2
set expandtab
set shiftwidth=4
set autoindent
set number
set wildmode=longest, list
set cc=80
filetype plugin indent on
syntax on
set title
set laststatus=2
set shell=zsh
set mouse=a
set clipboard=unnamedplus
filetype plugin on
set cursorline
set ttyfast
set nobackup
set scrolloff=10

call plug#begin("~/.vim/plugged")
 " Plugin Section
 " Themes
 Plug 'dracula/vim'
 Plug 'projekt0n/github-nvim-theme'
 Plug 'ryanoasis/vim-devicons'
 " Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'
 Plug 'scrooloose/nerdtree'
 Plug 'preservim/nerdcommenter'
 Plug 'mhinz/vim-startify'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'windwp/nvim-autopairs'
 Plug 'kristijanhusak/defx-git'
 Plug 'kristijanhusak/defx-icons'  
 " Go packages
 Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
 Plug 'nvim-lua/plenary.nvim'
 Plug 'nvim-lua/popup.nvim'
 Plug 'crispgm/nvim-go', {'branch': 'main'}
 " Recommended plugin LSP Config
 Plug 'neovim/nvim-lspconfig'
 " Vue packages
 Plug 'leafOfTree/vim-vue-plugin'
 " Typescript packages
 Plug 'jose-elias-alvarez/null-ls.nvim', {'branch': 'main'}
 Plug 'jose-elias-alvarez/nvim-lsp-ts-utils', {'branch': 'main'}
call plug#end()

" Color schemes
if (has("termguicolors"))
  set termguicolors
endif
syntax enable

" Color scheme evening
colorscheme github_dark

" Open new split panes to right and below
set splitright
set splitbelow

" Move line or visually selected block - alt+j/k
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Move split panes to left/bottom/top/right
nnoremap <A-h> <C-W>H
nnoremap <A-j> <C-W>J
nnoremap <A-k> <C-W>K
nnoremap <A-l> <C-W>L

" Move between panes to left/bottom/top/right
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Press i to entre insert mde, and ii to exit it
:inoremap ii <Esc>
:inoremap jk <Esc>
:inoremap kj <Esc>
:vnoremap jk <Esc>
:vnoremap kj <Esc>

" Open file in a text by placinf text and gf
nnoremap gf :vert winc f<cr>

" Copies filepath to clipboard by pressing yf
:nnoremap <silent> yf :let @+=expand('%:p')<CR>

" Copies pwd to clipboard: command yd
:nnoremap <silent> yd :let @+expand('%:p:h')<CR>

" Vim jump to the last position when reoening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line ("£")
                \| exe"normal! g'\"" | endif
endif

" Lua settings
lua << EOF

local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end
local on_attach = function(client, bufnr)
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
    buf_map(bufnr, "n", "gd", ":LspDef<CR>")
    buf_map(bufnr, "n", "gr", ":LspRename<CR>")
    buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
    buf_map(bufnr, "n", "K", ":LspHover<CR>")
    buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
    buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
    buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
    buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
    buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        on_attach(client, bufnr)
    end,
})
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier,
    },
    on_attach = on_attach,
})

EOF
