#!bin/bash

if [[ "$*" =~ info ]]; then
    echo "The main content of this script is based on open source code and has been adjusted to suit personal preference."
    echo "The content of this script may not be suitable for everyone."
    echo "For access to the original information please visit the following links"
    echo "And thanks to the authors for their efforts"
    echo "https://www.sqlsec.com/2018/05/termux.html#toc-heading-23"
    echo "https://github.com/sahilsehwag/android-termux-setup-script"
    echo "And all the open source projects used in the scripts"

    echo $HOME  #/data/data/com.termux/files/home
    echo $PREFIX #/data/data/com.termux/files/usr
    echo $TMPPREFIX

    echo "Backing up & Restoring"
    echo "https://wiki.termux.com/wiki/Backing_up_Termux"
    echo "tar -zcf /sdcard/termux-backup.tar.gz -C /data/data/com.termux/files ./home ./usr"
    echo "tar -zxf /sdcard/termux-backup.tar.gz -C /data/data/com.termux/files --recursive-unlink --preserve-permissions"
fi

if [[ "$*" =~ help ]]; then
	echo all = INSTALLS & SETUP EVERYTHING
    echo chs = CHANGE SOFTWARE SOURCE TO TSINGHUA TUNA
    echo sl = CREATE SOFT LINK
	echo omz = INSTALLS OH-MY-ZSH AND SETUP .zshrc. TO CHANGE DEFAULT SHELL USE chsh AND TYPE zsh
	echo vim = INSTALLS vim-python AND SETUP .vimrc
	echo fasd = INSTALL AND SETUP FASD
	echo fzf = INSTALL FZF AND ADD COMMON ALIASES LIKE fcd AND fv
	echo neovim = INSTALL NEOVIM AND SETUP init.vim
    echo eks = CUSTOMIZE EXTRA-KEY
    echo info = PRINT BASIC INFO
    echo yg = INSTALL YOU-GET
    echo pt = INSTALL PROXYCHAINS4
fi

#Change source (for Chinese user)
if [[ "$*" =~ chs || "$*" =~ all ]]; then
	echo "Start to change software source to tsinghua tuna"
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
    sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
    sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
    echo "Done! Start to update source list"
    pkg update
fi

#SOFT-LINK
if [[ "$*" =~ sl || "$*" =~ all ]]; then
    #QQ
	ln -s /data/data/com.termux/files/home/storage/shared/tencent/QQfile_recv qq
    #TIM
    #ln -s /data/data/com.termux/files/home/storage/shared/tencent/TIMfile_recv tim
fi

#Install baisc tools
if [[ "$*" =~ all ]]; then
	pkg upgrade
	pkg install -y man
	pkg install -y curl
	pkg install -y wget
	pkg install -y tree
    pkg install -y proxychains4
    pkg install -y openssh
    pkg install neofetch
fi

#_Will not be automatically installed
if [["$*" =~ pt ]]; then
    pkg install -y proxychains4
fi

#Install you-get _Will not be automatically installed
if [["$*" =~ yg ]]; then
    pkg install python3 ffmpeg -y
    pip3 install you-get  -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
fi

#OH-MY-ZSH
if [[ "$*" =~ omz || "$*" =~ all ]]; then
    #sh -c "$(curl -fsSL https://github.com/Cabbagec/termux-ohmyzsh/raw/master/install.sh)"
    # enable storage
    termux-setup-storage
    # install zsh
    apt update
    apt install -y git zsh
    git clone https://github.com/Cabbagec/termux-ohmyzsh.git "$HOME/termux-ohmyzsh" --depth 1

    mv "$HOME/.termux" "$HOME/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    cp -R "$HOME/termux-ohmyzsh/.termux" "$HOME/.termux"

    git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    sed -i '/^ZSH_THEME/d' "$HOME/.zshrc"
    sed -i '1iZSH_THEME="agnoster"' "$HOME/.zshrc"
    echo "alias chcolor='$HOME/.termux/colors.sh'" >> "$HOME/.zshrc"
    echo "alias chfont='$HOME/.termux/fonts.sh'" >> "$HOME/.zshrc"
    {
		echo "bindkey -v"
		echo "alias la='ls -a'"
		echo "alias ll='ls -l'"
		echo "alias lal='ls -al'"
		# echo "alias src='source ~/.zshrc'"

		echo "alias pi='pkg install'"
		echo "alias pla='pkg list-all'"
		echo "alias pii='pkg list-installed'"
		echo "alias pu='pkg uninstall'"
		echo "alias psh='pkg show'"
		echo "alias pse='pkg search'"
	} >> ~/.zshrc
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlightin                              g" --depth 1
    echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
    
    #zsh-autosuggestions
    git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    awk -v line=$(awk '$1!="#" && /plugins=\(/{print NR}' ~/.zshrc)  '{if(NR==line) gsub(/\)/," zsh-autosuggestions)");print > "~/.zshrc"}' ~/.zshrc

    chsh -s zsh

    echo "The default color theme is Tango,run chcolor to change it.";
    echo "The default font is Ubuntu font,run chfont to change it.";

fi

#VIM
if [[ "$*" =~ vim || "$*" =~ all ]]; then
	pkg install -y vim
	touch ~/.vimrc
	{
		echo '"PREFERENCES'
		echo 'set tabstop=4'
		echo 'set shiftwidth=4'
		echo 'set autoindent'
		echo 'set ignorecase'
		echo 'set smartcase'
		echo 'set nobackup'
		echo 'set noswapfile'
		echo 'set number'
		echo 'set relativenumber'
		echo 'set incsearch'
		echo 'set hlsearch'
		echo 'set nowrap'
		echo ''

		echo '"LEADER MAPPINGS'
		echo 'let mapleader=" "'
		echo 'let maplocalleader=","'
		echo 'nnoremap <LEADER><LEADER> :'
		echo ''

		echo '"BUFFER MAPPINGS'
		echo 'nnoremap <Leader>ba :badd '
		echo 'nnoremap <Leader>be :edit '
		echo 'nnoremap <Leader>bd :bdelete<CR>'
		echo 'nnoremap <Leader>bw :w<CR>'
		echo 'nnoremap <Leader>bfw :w!<CR>'
		echo 'nnoremap <Leader>bn :bnext<CR>'
		echo 'nnoremap <Leader>bp :bprevious<CR>'
		echo ""

		echo '"WINDOWS MAPPINGS'
		echo 'nnoremap <Leader>wo :only<CR>'
		echo 'nnoremap <Leader>ws :split '
		echo 'nnoremap <Leader>wv :vsplit '
		echo 'nnoremap <Leader>wj <C-W><C-J>'
		echo 'nnoremap <Leader>wk <C-W><C-K>'
		echo 'nnoremap <Leader>wl <C-W><C-L>'
		echo 'nnoremap <Leader>wh <C-W><C-H>'
		echo ""

		echo '"TAB MAPPINGS'
		echo 'nnoremap <LEADER>ta :tabnew<CR>     '
		echo 'nnoremap <LEADER>tc :tabclose<CR>   '
		echo 'nnoremap <LEADER>tn :tabnext<CR>    '
		echo 'nnoremap <LEADER>tp :tabprevious<CR>'
		echo 'nnoremap <LEADER>th :tabmove -<CR>  '
		echo 'nnoremap <LEADER>tl :tabmove +<CR>  '
		echo ""

		echo '"VIM MAPPINGS'
		echo 'nnoremap <Leader>vrc :edit ~/.vimrc<CR>'
		echo 'nnoremap <Leader>vs :source ~/.vimrc<CR>'
		echo 'nnoremap <Leader>vq :q<CR>'
		echo 'nnoremap <Leader>vfq :q!<CR>'
		echo 'nnoremap <Leader>vc :normal! 0i"<Esc>'
		echo 'nnoremap <Leader>vu :normal! 0x'
	} >> ~/.vimrc
    {
        set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
        set enc=utf8
        set fencs=utf8,gbk,gb2312,gb18030
    } >> ~/.vimrc
fi

#NEOVIM
if [[ "$*" =~ neovim ]]; then
	pkg install -y neovim
	mkdir ~/.config
	mkdir ~/.config/nvim
	touch ~/.config/nvim/init.vim
	{
		echo '"PREFERENCES'
		echo 'set tabstop=4'
		echo 'set shiftwidth=4'
		echo 'set autoindent'
		echo 'set ignorecase'
		echo 'set smartcase'
		echo 'set nobackup'
		echo 'set noswapfile'
		echo 'set number'
		echo 'set relativenumber'
		echo 'set incsearch'
		echo 'set hlsearch'
		echo 'set nowrap'
		echo ''

		echo '"LEADER MAPPINGS'
		echo 'let mapleader=" "'
		echo 'let maplocalleader=","'
		echo 'nnoremap <LEADER><LEADER> :'
		echo ''

		echo '"BUFFER MAPPINGS'
		echo 'nnoremap <Leader>ba :badd '
		echo 'nnoremap <Leader>be :edit '
		echo 'nnoremap <Leader>bd :bdelete<CR>'
		echo 'nnoremap <Leader>bw :w<CR>'
		echo 'nnoremap <Leader>bfw :w!<CR>'
		echo 'nnoremap <Leader>bn :bnext<CR>'
		echo 'nnoremap <Leader>bp :bprevious<CR>'
		echo ""

		echo '"WINDOWS MAPPINGS'
		echo 'nnoremap <Leader>wo :only<CR>'
		echo 'nnoremap <Leader>ws :split '
		echo 'nnoremap <Leader>wv :vsplit '
		echo 'nnoremap <Leader>wj <C-W><C-J>'
		echo 'nnoremap <Leader>wk <C-W><C-K>'
		echo 'nnoremap <Leader>wl <C-W><C-L>'
		echo 'nnoremap <Leader>wh <C-W><C-H>'
		echo ""

		echo '"TAB MAPPINGS'
		echo 'nnoremap <LEADER>ta :tabnew<CR>     '
		echo 'nnoremap <LEADER>tc :tabclose<CR>   '
		echo 'nnoremap <LEADER>tn :tabnext<CR>    '
		echo 'nnoremap <LEADER>tp :tabprevious<CR>'
		echo 'nnoremap <LEADER>th :tabmove -<CR>  '
		echo 'nnoremap <LEADER>tl :tabmove +<CR>  '
		echo ""

		echo '"VIM MAPPINGS'
		echo 'nnoremap <Leader>vrc :edit ~/.vimrc<CR>'
		echo 'nnoremap <Leader>vs :source ~/.vimrc<CR>'
		echo 'nnoremap <Leader>vq :q<CR>'
		echo 'nnoremap <Leader>vfq :q!<CR>'
		echo 'nnoremap <Leader>vc :normal! 0i"<Esc>'
		echo 'nnoremap <Leader>vu :normal! 0x'
	} >> ~/.config/nvim/init.vim
fi

#Custom extra-key
if [[ "$*" =~ eks || "$*" =~ all ]]; then
	# extra-keys = [ \\
    #  ['ESC','|','/','HOME','UP','END','PGUP','DEL'], \\
    #  ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP'] \\
    # ]'
    # extra-keys = [ \\
    # ['ESC','|','/','`','UP','QUOTE','APOSTROPHE'], \\
    # ['TAB','CTRL','~','LEFT','DOWN','RIGHT','ENTER'] \\
    # ]'
    tempfile=`mktemp temp.XXXXXX`
    echo 'ZXh0cmEta2V5cyA9IFsgXAogWydFU0MnLCd8JywnLycsJ0hPTUUnLCdVUCcsJ0VORCcsJ1BHVVAnLCdERUwn' > $tempfile
    sed -i 's/$/XSwgXAogWydUQUInLCdDVFJMJywnQUxUJywnTEVGVCcsJ0RPV04nLCdSSUdIVCcsJ1BHRE4nLCdCS1NQJ10gXApd/' $tempfile
    cat $tempfile|base64 -d >> ~/.termux/termux.properties
    rm -f $tempfile 2>/dev/null
fi

#FASD
if [[ "$*" =~ fasd ]]; then
	pkg install -y git
	pkg install -y make
	git clone https://github.com/clvv/fasd ~/fasd
	cd ~/fasd
	make install

	if [[ -f ~/.zshrc && -x /usr/bin/fasd ]]; then
		echo 'eval "$(fasd --init auto)"' >> ~/.zshrc
		echo "alias v='f -e vim'" >> ~/.zshrc
	fi
	if [[ -f ~/.bashrc && -x /usr/bin/fasd ]]; then
		echo 'eval "$(fasd --init auto)"' >> ~/.bashrc
		echo "alias v='f -e vim'" >> ~/.bashrc
	fi
fi

#FZF
if [[ "$*" =~ 'fzf' || "$*" =~ all ]]; then
	pkg install -y fzf
	touch ~/.bashrc
	touch ~/.zshrc

	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
	[ -f ~/.fzf.bash ] && source ~/.fzf.bash

	{
		echo "export FZF_DEFAULT_COMMAND='find'"
		echo "export FZF_DEFAULT_OPTS='--height 50% --reverse --margin 0,0,0,2 --color fg:-1,bg:-1,hl:33,fg+:254,bg+:235,hl+:33 --color info:136,prompt:136,pointer:230,marker:230,spinner:136'"
		echo $'alias fcd=\'cd "$(find -L -type d | fzf)"\''
		echo $'alias fv=\'vim "$(find -L -type f | fzf)"\''
	} >> ~/.zshrc
	{
		echo "export FZF_DEFAULT_COMMAND='find'"
		echo "export FZF_DEFAULT_OPTS='--height 50% --reverse --margin 0,0,0,2 --color fg:-1,bg:-1,hl:33,fg+:254,bg+:235,hl+:33 --color info:136,prompt:136,pointer:230,marker:230,spinner:136'"
		echo $'alias fcd=\'cd "$(find -L -type d | fzf)"\''
		echo $'alias fv=\'vim "$(find -L -type f | fzf)"\''
	} >> ~/.bashrc
fi

echo "Please restart Termux app..."

exit

