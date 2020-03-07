MacBootPro
=================
Switching to a new laptop is never a fun process, so here's some help.

MacBootPro is a simple bootstrapping script to help with the initial setup of a MacBook:

 * uses a [Homebrew](https://brew.sh) Brewfile to install a predefined list of packages;
 * installs python packages from a `requirements.txt` file;
 * sets a number of macOS defaults like keyboard/trackpad settings, Hot Corners, etc (my personal preferences, YMMV);
 * configures some of the installed applications.

Future developments might include stuff like adding dotfiles (e.g. yadm).

# Usage
`./macbootpro.sh`
