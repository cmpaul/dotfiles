echo "› installing powerline-shell"
CUR_DIR=`pwd`
PL_DIR=$HOME/powerline-shell
git clone https://github.com/milkbikis/powerline-shell $PL_DIR
cd $PL_DIR 
# ./install.py
ln -f -s $HOME/powerline-shell/powerline-shell.py $HOME/powerline-shell.py
ln -f -s $HOME/.dotfiles/powerline-shell/config.py $HOME/powerline-shell/config.py
./install.py
cd $CUR_DIR
exit 0
