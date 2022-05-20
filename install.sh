# display hidden files & folders
defaults write com.apple.Finder AppleShowAllFiles true
# sudo killall Finder
# then use shortcuts: Command + Shift + .


# Install Brew - https://brew.sh/
which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing brew.."
    brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew doctor
    
    # exit as it requires specific configuration based on 
    exit

    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/"$USER"/.zprofile
    # eval "$(/opt/homebrew/bin/brew shellenv)"

    ## try to reload shell
    # test -f ~/.profile  && source ~/.profile
    # test -f ~/.zshrc    && source ~/.zshrc
    # test -f ~/.zprofile && source ~/.zprofile
else
    :
    echo "Updating brew.."
    # brew update
fi


# Create symlink to the Movies folder
test -d ~/Downloads/Movies || mkdir ~/Downloads/Movies
test -L ~/Desktop/Movies || ln -s ~/Downloads/Movies ~/Desktop/Movies


# Install packages
while read package; do
    brew ls --versions $package || brew install $package
    brew outdated $package || brew install $package
done <brew-packages.list


# Install apps
while read app; do
    brew ls --versions --cask $app || brew install --cask $app
    brew outdated --cask $app || brew install --cask $app
done <brew-apps.list


# Git configuration
# https://stackoverflow.com/a/48370253/1565790
git config --global pager.branch false
git config --global init.defaultBranch main

# Set Git NAME
GIT_NAME="$(git config --global user.name)"
if [ -z $GIT_NAME ]; then
    read -p "git user.name: " NAME
    git config --global user.name "$NAME"
fi

# Set Git EMAIL
GIT_EMAIL="$(git config --global user.email)"
if [ -z $GIT_EMAIL ]; then
    read -p "git user.email: " EMAIL
    git config --global user.email "$EMAIL"
fi


# Install VSCode extensions
# cat vscode-extensions.list | xargs -L1 code --install-extension
while read extension; do
    code --list-extensions | grep -e "^$extension$" || code --install-extension "$extension"
done <vscode-extensions.list


# Download & Install FileZilla
# !!! Provide a fresh URL  !!!
test -d /Applications/FileZilla.app 
if [[ $? != 0 ]] ; then
    echo installing filezilla..
    
    url_filzilla="https://dl4.cdn.filezilla-project.org/client/FileZilla_3.59.0_macosx-x86.app.tar.bz2?h=X5YF8yuBH9YQAHrgC1tHNQ&x=1653003363"
    test -f FileZilla.tar.bz2 || curl -o FileZilla.tar.bz2 "$url_filzilla" && tar -xzf FileZilla.tar.bz2 && mv FileZilla.app /Applications/FileZilla.app
    # open /Applications/FileZilla.app
fi


# Install oh-my-zsh - https://ohmyz.sh/#install
test -f ~/.zshrc || sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"


