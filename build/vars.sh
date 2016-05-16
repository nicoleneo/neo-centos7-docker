export PATH=$PATH:/usr/sbin:/sbin
alias netbeans='/usr/local/netbeans-8.1/bin/netbeans -J-Xmx2048m -J-XX:+UseConcMarkSweepGC -J-XX:+UseParNewGC --jdkhome /usr/java/latest/'
export PS1="\[\033[38;5;30m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;34m\]docker\[$(tput sgr0)\]\[\033[38;5;15m\]:\w\\$ \[$(tput sgr0)\]"
export DISPLAY=:0
alias jupyternb='/opt/conda/bin/jupyter-notebook --no-browser --port 8888 --ip=0.0.0.0'
export QT_X11_NO_MITSHM=1
alias startnb='/startnb.sh && source ~/.tmprc'
alias killnb='sudo kill -s SIGSEGV $NBID'
alias restartnb='killnb; startnb'