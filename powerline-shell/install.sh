echo "› installing powerline-shell"
CUR_DIR=`pwd`
PL_DIR=$HOME/powerline-shell
git clone https://github.com/b-ryan/powerline-shell $PL_DIR
cd $PL_DIR
ln -f -s $HOME/powerline-shell/powerline-shell.py $HOME/powerline-shell.py
mkdir -p $HOME/.config/powerline-shell
ln -f -s $HOME/.dotfiles/powerline-shell/config.json $HOME/.config/powerline-shell/config.json
python setup.py install
cd $CUR_DIR
exit 0
