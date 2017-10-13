#!/bin/sh

echo "---------------------------------------------------------"
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "---------------------------------------------------------"
echo "check if osx command line tools are installed"
git --version

echo "---------------------------------------------------------"
brew=$(which brew)
if [ -f "$brew" ]
then
  echo "Homebrew is installed, nothing to do here"
else
  echo "Homebrew is not installed, installing now"
  echo "This may take a while"
  echo "Homebrew requires osx command lines tools, please download xcode first"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "---------------------------------------------------------"
echo "Installing brew packages..."
packages=(
"awscli",
"ffmpeg"
"git"
"go"
#"go-delve/delve/delve"
"gradle"
"maven"
"neovim"
"node",
"packer",
"python3"
"openssl",
"ssh-copy-id"
"terragrunt"
"tflint"
"vim --with-override-system-vi --with-features=huge --without-nls --enable-interp=ruby,perl,python"
"wget"
)

for i in "${packages[@]}"
do
  echo "-- $i"
  brew install $i
done

echo "---------------------------------------------------------"
echo "=> Installing tapped formulas"
echo "---------------------------------------------------------\n"
# format: tap#formula
brewtaps=(
  "wata727#tflint"
)

for i in "${brewtaps[@]}"
do
  tap=$(echo $i | cut -d# -f1)
  formula=$(echo $i | cut -d# -f2)
  brew tap $tap
  brew install $formula
  brew untap $tap
done

echo "---------------------------------------------------------"
echo "Cloning Manuel's dotfiles insto .dotfiles"
git clone https://github.com/mavogel/dotfiles.git ~/.dotfiles

echo "---------------------------------------------------------"
echo "running oxs defaults"
sh ~/.dotfiles/osx.sh

echo "---------------------------------------------------------"
echo "copying maven settings"
[ ! -d ~/.m2 ] && mkdir ~/.m2
cp ~/.dotfiles/maven/settings.xml ~/.m2/

echo "---------------------------------------------------------"
echo "creating and filling proxy_vars.sh template"
touch ~/.dotfiles/proxy_vars.sh
echo "proxyUser=''\n
      proxy=''\n
      proxyPort=''\n
      noProxies=''\n
      noProxiesJVM=''\n
      forwardUser=''\n
      forwardServer=''\n" >> ~/.dotfiles/proxy_vars.sh

echo "---------------------------------------------------------"
echo "adapting ~.zshrc"
sed -i.bak \ 
  -e 's#.*ZSH_CUSTOM.*#ZSH_CUSTOM=$HOME/.dotfiles/custom_zsh#' \ 
  -e 's#.*ZSH_THEME.*#ZSH_THEME="geoffgarside"#' \ 
  .zshrc && rm -f .zshrc.bak

echo "---------------------------------------------------------"
vscode=$(which code)
if [ -f "$vscode" ]
then
  echo "Installing vscode extensions"
  vscode_extensions=(
  "PeterJausovec.vscode-docker"
  "dbaeumer.vscode-eslint"
  "donjayamanne.python"
  "k--kato.intellij-idea-keybindings"
  "lukehoban.Go"
  "mauve.terraform"
  "mindginative.terraform-snippets"
  "tht13.python"
  )

  for i in "${vscode_extensions[@]}"
  do
    echo "-- $i"
    code --install-extension $i
  done
else
  echo "Visual Studio Code is not present hence no extension could be installed"
fi

 # [WIP]
# echo "---------------------------------------------------------"
# echo "Installing dev tools - need admin rights"
# sudo su
#exit # get out of sudo mode

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "and change your terminal font to source code pro"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
