#!/bin/bash

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
"asciinema"
"awscli"
"cask install haskell-platform"
"ffmpeg"
"git"
"go"
"govendor"
"godep"
#"go-delve/delve/delve"
"gradle"
"grep"
"jq"
"jo"
"kubectl"
"maven"
"neovim"
"node@8"
"packer"
"pandoc"
"pandoc-citeproc"
"python3"
"openssl"
"shellcheck"
"ssh-copy-id"
"terragrunt"
"tflint"
"tree"
"tsub/s3-edit/s3-edit"
"vim --with-override-system-vi --with-features=huge --without-nls --enable-interp=ruby,perl,python"
"wget"
)

for p in "${packages[@]}"
do
  echo "-- $p"
  brew install $p
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
  -e "s#.*ZSH_CUSTOM.*#ZSH_CUSTOM=$HOME/.dotfiles/custom_zsh#" \
  -e 's#.*ZSH_THEME.*#ZSH_THEME="spaceship"#' \
  .zshrc && rm -f .zshrc.bak

echo "installing 'spaceship' theme"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo "---------------------------------------------------------"
echo "setting symlinks"
# the symlinks should be with out a starting dot in ~/.dotfiles
symlinks=(
  gitconfig
)
for symlink in "${symlinks[@]}"
do
  ln -s ~/.dotfiles/${symlink} ~/.${symlink}
done

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
    "timonwong.shellcheck"
    "MS-DevSkim.vscode-devskim"
    "eamodio.gitlens"
  )

  for ext in "${vscode_extensions[@]}"
  do
    echo "-- $ext"
    code --install-extension $ext
  done
else
  echo "Visual Studio Code is not present hence no extension could be installed"
fi

# [WIP]
# echo "---------------------------------------------------------"
# echo "Installing dev tools - need admin rights"
# sudo su
# sudo chmod -R 777 /Library/Ruby/Gems/2.3.0
# gem install travis
# sudo chmod -R 755 /Library/Ruby/Gems/2.3.0
#exit # get out of sudo mode

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "and change your terminal font to source code pro"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
