#!/data/data/com.termux/files/usr/bin/bash
#/bin/sh

function printll() {
    i=1
    while [ ${i} -lt 5 ] #https://www.cnblogs.com/sidesky/p/10679427.html
    do
      let i++
      printf " "
    done
    echo -e "\033[47;30m $* \033[0m"
		#echo -e "\033[30m 黑色字 \033[0m"
		# echo -e "\033[31m 红色字 \033[0m"
		# echo -e "\033[32m 绿色字 \033[0m"
		# echo -e "\033[33m 黄色字 \033[0m"
		# echo -e "\033[34m 蓝色字 \033[0m" 
		# echo -e "\033[35m 紫色字 \033[0m" 
		# echo -e "\033[36m 天蓝字 \033[0m" 
		# echo -e "\033[37m 白色字 \033[0m" 
		# echo -e "\033[40;37m 黑底白字 \033[0m"
		# echo -e "\033[41;37m 红底白字 \033[0m" 
		# echo -e "\033[42;37m 绿底白字 \033[0m" 
		# echo -e "\033[43;37m 黄底白字 \033[0m" 
		# echo -e "\033[44;37m 蓝底白字 \033[0m" 
		# echo -e "\033[45;37m 紫底白字 \033[0m" 
		# echo -e "\033[46;37m 天蓝底白字 \033[0m" 
		# echo -e "\033[47;30m 白底黑字 \033[0m"
}
if [[ "$*" =~ help || ! -n "$1" ]]; then
	printll all = INSTALLS AND SETUP EVERYTHING
    printll chs = CHANGE SOFTWARE SOURCE TO TSINGHUA TUNA
  	printll omz = INSTALLS OH-MY-ZSH AND SETUP .zshrc.
  	printll vim = INSTALLS vim-python AND SETUP .vimrc
  	printll fasd = INSTALL AND SETUP FASD
  	printll fzf = INSTALL FZF AND ADD COMMON ALIASES LIKE fcd AND fv
  	printll neovim = INSTALL NEOVIM AND SETUP init.vim
    printll eks = CUSTOMIZE EXTRA-KEY
    printll info = PRINT BASIC INFO
    printll yg = INSTALL YOU-GET
	  printll basic = INSTALL BASIC TOOLS
	  printll zas = INSTALL ZSH-AUTOSUGGESTIONS
    printll ss = SETUP STORAGE
    printll fun = INSTALL FUN SOFTWARES
    printll b = Backing up
    printll r = Restoring
    printll sl = Create soft links
fi

if [[ "$*" =~ info ]]; then    
	printll "The main content of this script is based on open source code."
    printll "The content of this script may not be suitable for everyone."
    printll "The original information please visit the following links"
    printll "And thanks to the authors for their efforts"
    printll "https://www.sqlsec.com/2018/05/termux.html#toc-heading-23"
    printll "https://github.com/sahilsehwag/android-termux-setup-script"
    printll "And all the open source projects used in the scripts"
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

#enable storage
if [[ "$*" =~ ss || "$*" =~ all ]]; then
	  termux-setup-storage
    # echo $HOME  #/data/data/com.termux/files/home
    # echo $PREFIX #/data/data/com.termux/files/usr
fi


#Backing up
if [[ "$*" =~ b ]]; then
    termux-setup-storage
    printll "Backing up & Restoring"
    printll "https://wiki.termux.com/wiki/Backing_up_Termux"
	  tar -zcf /storage/emulated/0/Download/termux-backup.tar.gz -C /data/data/com.termux/files ./home ./usr
fi

#Restoring
if [[ "$*" =~ r ]]; then
    termux-setup-storage
    printll "Backing up & Restoring"
    printll "https://wiki.termux.com/wiki/Backing_up_Termux"
	  tar -zxf /storage/emulated/0/Download/termux-backup.tar.gz -C /data/data/com.termux/files --recursive-unlink --preserve-permissions
fi

#SOFT-LINK
if [[ "$*" =~ sl || "$*" =~ all ]]; then
    #QQ
 	  ln -s /storage/emulated/0/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv ~/qq
fi

#Install baisc tools
if [[ "$*" =~ basic || "$*" =~ all ]]; then
	pkg update
	pkg install vim curl wget git tree openssh neofetch man htop -y
fi

#Install fun softwares
if [[ "$*" =~ fun || "$*" =~ all ]]; then
  apt install fortune
  apt install ruby -y
  gem install cowsay
  gem install lolcat
  echo "for fun just type: fortune | cowsay | lolcat or fun"
  echo "alias fun='fortune | cowsay | lolcat'" >> "$HOME/.zshrc"
fi

#Install you-get _Will not be automatically installed
if [[ "$*" =~ yg ]]; then
    pkg install python3 ffmpeg -y
    pip3 install you-get  -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
fi

#OH-MY-ZSH
if [[ "$*" =~ omz || "$*" =~ all ]]; then
    #sh -c "$(curl -fsSL https://github.com/Cabbagec/termux-ohmyzsh/raw/master/install.sh)"
    # install zsh
    pkg update
    pkg install -y git zsh
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
		echo "alias lla='ls -al'"
		echo "alias src='source ~/.zshrc'"

		echo "alias ai='apt install'"
		echo "alias ala='apt list-all'"
		echo "alias aii='apt list-installed'"
		echo "alias au='apt uninstall'"
		echo "alias ash='apt show'"
		echo "alias ase='apt search'"
	} >> ~/.zshrc
    #git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    echo "source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>  ~/.zshrc
    
    chsh -s zsh

    printll "The default color theme is Tango,run chcolor to change it."
    printll "The default font is Ubuntu font,run chfont to change it."
fi

#zsh-autosuggestions
if [[ "$*" =~ zas || "$*" =~ all ]]; then
    git clone git://github.com/zsh-users/zsh-autosuggestions  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions #this is ok
    #git clone https://github.com/zsh-users/zsh-autosuggestions.git "'$ZSH_CUSTOM'/plugins/zsh-autosuggestions" --depth 1 #bad run
    #git clone git://github.com/zsh-users/zsh-autosuggestions  $ZSH_CUSTOM/plugins/2/zsh-autosuggestions --depth 1 #bad run
    
    awk -v line=$(awk '$1!="#" && /plugins=\(/ && !/zsh-autosuggestions/ {print NR}' "$HOME/.zshrc")  '{if(NR==line) gsub(/\)/," zsh-autosuggestions)");print > "'${HOME}'/.zshrc"}' "$HOME/.zshrc"
	  #在awk内用print输出内容到某个文件，要写权路径，且整个文件名加路径要用双引号括起来；
	  #即：print > "/tmp/aa" 对于变量 print >> "'${filenamePath}'/aa"
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
if [[ "$*" =~ neovim || "$*" =~ all ]]; then
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
	# extra-keys = [ \
    # extra-keys = [ \
    # ['ESC','|','/','`','UP','QUOTE','APOSTROPHE'], \
    # ['TAB','CTRL','~','LEFT','DOWN','RIGHT','ENTER'] \
    # ]'
    cp "$HOME/.termux/termux.properties" "$HOME/.termux/termux.properties.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    tempfile=`mktemp temp.XXXXXX`
    echo 'ICAgIGV4dHJhLWtleXMgPSBbIFwKICAgIFsnRVNDJywnfCcsJy8nLCdgJywnVVAnLCdRVU9URScsJ0FQ' > $tempfile
    sed -i 's/$/T1NUUk9QSEUnXSwgXAogICAgWydUQUInLCdDVFJMJywnficsJ0xFRlQnLCdET1dOJywnUklHSFQnLCdFTlRFUiddIFwKICAgIF0n/' $tempfile
    cat $tempfile|base64 -d >> ~/.termux/termux.properties
    rm -f $tempfile 2>/dev/null
fi

#FASD
if [[ "$*" =~ fasd || "$*" =~ all ]]; then
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


echo -e "\033[42;37m Please restart Termux app... \033[0m"
exit

