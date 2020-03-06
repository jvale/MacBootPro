MacBootPro
=================
Switching to a new laptop is never a fun process, so here's some help.

MacBootPro is a simple bootstrapping script to help with the initial setup of a MacBook:

 * uses a [Homebrew](https://brew.sh) Brewfile to install a predefined list of packages to avoid the website -> download -> install -> remove installer cycle and having to remember all those little utilitles that you only realize you're missing when you try to run them;
 * sets a number of macOS defaults like keyboard/trackpad settings, Hot Corners, etc (my personal preferences, YMMV).

Future developments might include fetching dotfiles (e.g. from a git repo) and installing them.

# Usage
`./macbootpro.sh`
