" let vimrc_path = $HOME . "/.vimrc"
let s:vimrc_path = expand('~/.vimrc')
echo "vimrc path: " . s:vimrc_path
if filereadable(s:vimrc_path)
    exe 'source' s:vimrc_path
endif
