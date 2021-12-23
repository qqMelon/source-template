# Vim and Neovim settings

## Installion

Depend from your os but for arch it's:
```sh
yay/pacman -S vim nvim vim-plug
``` 

Other linux i guess:
```sh
apt-get install vim nvim vim-plug
```

Vim is my currently text editor for development. I mainly program on :
- Javascript / Typescript
- Golang
- Yaml
- Lua
- Python

Neovim is a extra layer to vim. To set it, create a file: `~/.config/nvim/init.vim`

*Here, i put my lua code on the `.vim` file. because i set other personnal use on my lua directory but if you want you can 
create lua directory to cut them from the `init.vim` file.*

**After writting file don't forget to `:PlugInstall` :)**

