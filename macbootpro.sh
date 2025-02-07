#!/bin/bash

set -e


## Basic options and setup

function show_help ()
{
    echo "Usage:"
    echo -e "\t-h: help"
    echo -e "\t-e: also install extra Brewfile (Brewfile.extra)"
}

INSTALL_EXTRA=0

while getopts "h?e?" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    e)  INSTALL_EXTRA=1
        ;;
    esac
done


## Install apps
echo "> Checking Homebrew..."
if ! which -s brew
then
    echo "Please install Homebrew first: https://brew.sh"
    exit 1
fi

echo "> Updating Homebrew..."
brew update

echo "> Install Mac App Store CLI..."
brew install mas

echo "> Applying Brewfile..."
brew bundle

if [ $INSTALL_EXTRA -ne 0 ]
then
    echo "> Applying extra Brewfile..."
    brew bundle --file Brewfile.extra
fi

echo "> Install Python utils..."
source ~/.bash_profile  # make sure paths and etc are up-to-date
pip install -r requirements.txt
echo "virtualenv" > $(pyenv root)/default-packages
source ~/.bash_profile  # make sure virtualenv and friends are loaded


## Set macOS defaults
echo "> Adjusting macOS defaults..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true  # Expand save panel by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true  # Finder: show all filename extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # Don't complain when changing file extensions

echo "> Setting Dark mode..."
defaults write "Apple Global Domain" AppleInterfaceStyle Dark

echo "> Configure Menu bar..."
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm:ss"
defaults write com.apple.menuextra.battery ShowPercent YES
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool NO  # Remove Fast User Switching from menu bar
defaults delete com.apple.Spotlight "NSStatusItem Visible Item-0" # Remove Spotlight from menu bar
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Volume.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"

echo "> Configure Dock..."
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock show-recents -int 0
defaults write com.apple.dock autohide -int 0
defaults write com.apple.dock tilesize -int 48

echo "> Configure Keyboard..."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # Disable automatic quotes
defaults write -g ApplePressAndHoldEnabled -bool false  # Disable Character picker
defaults write -g InitialKeyRepeat -int 68  # Repeat rate
defaults write -g KeyRepeat -int 2  # Repeat rate, minumum in UI

echo "> Enable trackpad tap to click..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "> Configure Hot Corners..."
# Top left screen corner - Application windows
defaults write com.apple.dock wvous-tl-corner -int 3
defaults write com.apple.dock wvous-tl-modifier -int 0
# Bottom left screen corner - put display to sleep
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
# Top right screen corner - Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
# bottom right screen corner - show Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

echo "Enabling snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo "> Configure Calendar..."
defaults write com.apple.iCal "first day of week" -int 1


## Configure apps
echo "> Configure Clipy"
defaults read com.clipy-app.Clipy >/dev/null 2>&1 || open /Applications/Clipy.app
defaults write com.clipy-app.Clipy kCPYPrefShowIconInTheMenuKey -int 0
defaults write com.clipy-app.Clipy menuItemsAreMarkedWithNumbers -int 0
defaults write com.clipy-app.Clipy kCPYPrefNumberOfItemsPlaceInlineKey -int 20
defaults write com.clipy-app.Clipy kCPYPrefNumberOfItemsPlaceInsideFolderKey -int 20
defaults write com.clipy-app.Clipy kCPYPrefShowStatusItemKey -int 0
defaults write com.clipy-app.Clipy loginItem -int 1

echo "> Configure Rectangle"
defaults read com.knollsoft.Rectangle >/dev/null 2>&1 || open /Applications/Rectangle.app
defaults write com.knollsoft.Rectangle launchOnLogin -int 1
defaults write com.knollsoft.Rectangle hideMenubarIcon -int 1
defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks -int 1
defaults write com.knollsoft.Rectangle internalTilingNotified -int 1
defaults write com.knollsoft.Rectangle windowSnapping -int 2

echo "> Configure Owly"
defaults read com.fiplab.owly >/dev/null 2>&1 || open /Applications/Owly.app
defaults write com.fiplab.owly StartAtLogin -int 1
defaults write com.fiplab.owly ShowWelcomeWindow -int 0

echo "> Configure iTerm"
defaults write com.googlecode.iterm2 HideTab -int 0
defaults write com.googlecode.iterm2 StatusBarPosition -int 1

echo "> Configure VS Code"
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
if test -s "$VSCODE_SETTINGS"
then
    echo "VS Code settings file already exists, skipping"
else
    code --install-extension Shan.code-settings-sync
    cat <<EOF > "$VSCODE_SETTINGS"
    {
        "sync.removeExtensions": false,
        "sync.gist": "366789c5627379c6b831ecc4a624e4a4",
    }
EOF
fi
