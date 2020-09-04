sudo apt-get update

echo 'Installing curl...' 
sudo apt install curl -y

echo 'Installing xclip...'
sudo apt install xclip -y

echo 'Installing git...' 
sudo apt install git -y

echo 'Installing vim...'
sudo apt install vim -y

echo "What name do you want to use in git user.name?"
read git_config_user_name
git config --global user.name "$git_config_user_name"

echo "What email do you want to use in git user.email?"
read git_config_user_email
git config --global user.email $git_config_user_email

echo "Can I set vim as your default git editor for you? (y/n)"
read git_core_editor_to_vim
if echo "$git_core_editor_to_vim" | grep -iq "^y" ;then
	git config --global core.editor vim
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Generating a SSH Key..."
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
echo "SSH public key copied to clipboard."

echo 'Installing firacode...'
sudo apt install fonts-firacode -y

echo 'Installing zsh...'
sudo apt install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh
echo "export PROFILE="$HOME/.zshrc"" >> ~/.zshrc
source ~/.zshrc

echo "Installing spaceship theme..."
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/' ~/.zshrc
source ~/.zshrc

cat <<EOF >>  ~/.zshrc
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
EOF

echo "Installing zinit..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

echo "Adding extentions"
echo "zinit light zdharma/fast-syntax-highlighting" >> ~/.zshrc
echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc
echo "zinit light zsh-users/zsh-completions" >> ~/.zshrc

echo 'Installing code...'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install apt-transport-https -y
sudo apt update
sudo apt install code -y

echo 'Installing VSCode extensions...'
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension eamodio.gitlens
code --install-extension pkief.material-icon-theme
code --install-extension rocketseat.theme-omni
code --install-extension ms-azuretools.vscode-docker

echo 'Installing chrome...'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo 'Installing nvm...' 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.zshrc
nvm --version
nvm install 12
nvm alias default 12
node --version
npm --version

echo 'Installing terminator...'
sudo apt-get update
sudo apt-get install terminator -y

echo 'Configuring terminator...' 
touch ~/.config/terminator/config
cat <<EOF >>  ~/.config/terminator/config
[global_config]
  tab_position = hidden
  title_transmit_fg_color = "#bd93f9"
  title_transmit_bg_color = "#282a36"
  title_receive_fg_color = "#8be9fd"
  title_receive_bg_color = "#282a36"
  title_inactive_fg_color = "#f8f8f2"
  title_inactive_bg_color = "#282a36"
[keybindings]
[profiles]
  [[default]]
    background_color = "#1e1f29"
    background_darkness = 0.9
    background_type = transparent
    cursor_blink = False
    cursor_shape = underline
    cursor_color = "#bbbbbb"
    font = Hack 12
    foreground_color = "#f8f8f2"
    scrollbar_position = hidden
    scrollback_infinite = True
    palette = "#000000:#ff5555:#50fa7b:#f1fa8c:#bd93f9:#ff79c6:#8be9fd:#bbbbbb:#555555:#ff5555:#50fa7b:#f1fa8c:#bd93f9:#ff79c6:#8be9fd:#ffffff"
    login_shell = True
  [[terminator_default]]
    background_color = "#282a36"
    cursor_color = "#f8f8f2"
    foreground_color = "#f8f8f2"
    palette = "#44475a:#ff5555:#50fa7b:#ffb86c:#3465a4:#ff79c6:#f1fa8c:#44475a:#44475a:#ff5555:#50fa7b:#ffb86c:#729fcf:#ad7fa8:#f1fa8c:#44475a"
    copy_on_selection = True
[layouts]
  [[default]]
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default
      command = ""
    [[[window0]]]
      type = Window
      parent = ""
[plugins]
EOF

echo 'Installing docker...' 
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

chmod 777 /var/run/docker.sock
docker run hello-world

echo 'Installing docker-compose...' 
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'Installing dbeaver...'
wget -c https://github.com/dbeaver/dbeaver/releases/download/7.1.5/dbeaver-ce_7.1.5_amd64.deb
sudo dpkg -i dbeaver-ce_7.1.5_amd64.deb
sudo apt-get install -f

echo 'Installing insomnia...'
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | sudo apt-key add -
sudo apt update
sudo apt install insomnia -y

echo 'Downloading intellij...'
wget -c https://download.jetbrains.com/idea/ideaIC-2020.2.tar.gz

echo 'Downloading robo3t...'
wget -c https://download.studio3t.com/robomongo/linux/robo3t-1.3.1-linux-x86_64-7419c406.tar.gz

echo 'Installing vlc...'
sudo apt install vlc -y

echo 'Installing openjdk-8-jdk...'
sudo apt install openjdk-8-jdk -y
