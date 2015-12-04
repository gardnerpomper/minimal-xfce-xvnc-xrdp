if [ -f $HOME/.bashrc ]; then
    . $HOME/.bashrc
fi
eval $(ssh-agent)
export PATH=.:~/bin:$PATH
