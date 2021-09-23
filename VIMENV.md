## MY VIM envionment

Prior to working with linux i used to work on windows for quite some time and got used to all the editor shortcuts; Linux brought a big change in how texts are modified and i had to get used to vim.

Now I had to do some customizing, in order to get an environment that was somehow similar to what i was used to work with.
The result of this is my [.vimrc](https://github.com/MoserMichael/myenv/blob/master/.vimrc) file 


This might be useful for others who got windows withdrawal symptomps with vim; i actually think that it gives you the best of two worlds: VIM gets navigation in text better (like jumping to the next/previous word with w and b among other things; Also normal mode has it's point - when editing existing code you don't want to change stuff by accident; however the windows way also has its points.

all in all this set of tools makes vim look like turbo C under MSDOS. (for me that's still the best dev environment ever, except for Visual C++1.5 ;-) I don't know how other people work, as for me it's a big improvement that i don't have to switch to the shell in order to do some programming tasks; i think everything that saves you from switching contexts is a big deal in term of time and effort.


## How to use it

the next table sums up how to use this environment.

|Shortcut | Command | explanation 
-- | -- | ---
Tab        |                | indent a selected block of text (and leave selection on) - or indent current line
Shift-Tab  |                | unindent a selected block of text (and leave selection on) - or unindent the current line
-- | -- | ---
Shift-Left Shift-Right Shift-Up Shift-Down|                | start selecting the text from the current cursor position (enter visual mode). warning: some terminal can swallow it. for tmux you need to add the following to ~/.tmux.conf : set-window-option -g xterm-keys on  
-- | -- | ---
Ctrl+B  |					| start buffergator plugin for fast switching between active buffers
Ctrl+C  |                   | Copy. yanks and copies the current selection in visual mode; if not in visual mode then it will copy the current word. If xsel is installed then text is also put into the x selection (x windows clipboard)
Ctrl+X  |                   | Cut. cuts the current selection in visual mode; if not in visual mode then it cuts the current word. If xsel is installed then text is also put into the x selection (x windows clipboard)
Ctrl+V  |                   | Paste in stuff you copied with Ctrl+C or Ctrl+X (in all modes) In visual mode this deletes the current selection and replaces it with the copied text. In normal and insert mode the text is inserted. The implementation keeps the copied text in global variable, not in a register.
--      | Paste             | pastes from x selection (x windows clipboard). Needs xsel to be installed.
--      | ---               | ---
Ctrl+F  | FindCurrentWord   | find next occurence of word under cursor (&lt;cword&gt;) - just like * in normal mode, but also mapped to each editor mode.
Ctrl+A  |                   | force redraw of the screen.
Ctrl+G  | GotoLine          | promt line number and go to it.
Ctrl+U  |	            | Undo (multilevel undo)
Ctrl+R  |		    | Redp (multilevel redo)
F2      |                   | Display man page on current word in quickfix window. If the word occurs in multiple man pages then it asks which one to display.
F3      | DoGrep            | Grep in files from current directory down. Search results are put int o the quickfix window.
--      | GitGrep           | Grep in all files under git - from current directory down. Search results are put int o the quickfix window. 
--      | GitDiff           | git diff - shows the lists of files that changed. Enter on any file name will run vimdiff on the changed file.
--      | GitLog            | git log - shows the svn like log of commits, enter on a line will open that commit.
--      | BranchLocal       | list all local branch names in a window, pressing enter on a line switches to the branch name.
--      | BranchRemote      | list all remote branch names in a window, pressing enter on a line checks out that branch and switches to it. 
--      | Blame             | runs git blame on the file of the current window; while in the blame window, Blame now opens another window with the commit that changed the current line.
--      | Graph             | runs git log --graph and display a text graph of the commits. while in the same window, run enter on any line: this opens another buffer with the commit described by the current line in the window.
--      | GitLs             | list files under git into the quickfix window, clicking on a file will open it.
F5      | Build             | run asynchronous build (if current dir has ./make_override then run it, else make $MAKE_OPT. Compilation errors are put into quickfix window. (Sometimes asynchronous builds start to get screwy, that's the point where you need to restart vim)

Ctrl+F5 | StopBuild         | stop a asynchronous build that is running.
F4      | PrevBuildResult   | show the last build result in quickfix window. (nice if it got overwritten it by grep)
F6 F7   |                   | previous next compiler error.
F8	| 		    | Vertical split of the screen. (split)
F12 | SaveAndQuit   | if current buffer has been modified and is backed by a file name: save it and quit
--	| Format	    | applies code formatter to the current file (golang uses gofmt for C++ uses clang-format); for all other file extensions trailing spaces are removed and tabs are converted to spaces (good enough for python)
--  | Lint          | Depends on file extension of file in current buffer: for .sh files runs shellcheck; for .go files it runs make vet (assumes there is a makefile with vet target); for .py files it runs pylint on the file in current buffer.
--	| MakeTags	    | based on extension of file in the current buffer: for extension cpp h hpp runs ctags for c++; for extension go it runs gotags for golang; Set tags to root dir of current git repo, else takes current directory as tag directory; then finds all relevant files under tag directory and writes tags file in tag directory.
--	| UseTags	    | from current directory: if in git archive and the root directory contains a tag file then use it. This is also Run on vim start up.
--	| Entry		    | Put in a header with date and time & switches to insert mode (handy to edit plan.txt) (**)
--	| Comment	    | Comment a block of selected text in the current buffer (if current buffer is in c/go/shell/python/perl)
--	| Uncomment	    | Comment a block of selected text in the current buffer (if current buffer is in c/go/shell/python/perl)


** i usually keep a single plan.txt file in my home directory. Each entry has an identical header of the following form (this practice is very helpful in organizing my notes and thoughts)
the :Entry command puts this delimiting line:

```
---13/10/20 15:57:40----------------------
```


Note that some key combinations may not work because the emulator has swallowed some of them.
For example tmux needs to have the following line in ~/.tmux.conf 

```
set-window-option -g xterm-keys on
```

i also added a trick to change the cursor shape while in insert mode; now only works if vim is run in a gnome terminal or in an xterm terminal.

## Setup

Note that this .vimrc file uses [vundle](https://github.com/VundleVim/Vundle.vim) and the [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) plugin for code completion ; 

Now here in this repository there is a script to automate the installation of all of this goodness (alternatively you can set it all up in a docker), see the [README.me](https://github.com/MoserMichael/myenv/blob/master/README.md) file in this project for the details.


--      | GitDiff           | git diff - shows the lists of files that changed. Enter on any file name will run vimdiff on the changed file.
--      | Blame             | runs git blame on the file of the current window; while in the blame window, Blame now opens another window with the commit that changed the current line.
--      | Graph             | runs git log --graph and display a text graph of the commits. while in the same window, run enter on any line: this opens another buffer with the commit described by the current line in the window.
--      | GitLs             | list files under git into the quickfix window, clicking on a file will open it.
F5      | Build             | run asynchronous build (if current dir has ./make_override then run it, else make $MAKE_OPT. Compilation errors are put into quickfix window. (Sometimes asynchronous builds start to get screwy, that's the point where you need to restart vim)

Ctrl+F5 | StopBuild         | stop a asynchronous build that is running.
F4      | PrevBuildResult   | show the last build result in quickfix window. (nice if it got overwritten it by grep)
F6 F7   |                   | previous next compiler error.
F8	| 		    | Vertical split of the screen. (split)
F12 | SaveAndQuit   | if current buffer has been modified and is backed by a file name: save it and quit
--	| Format	    | applies code formatter to the current file (golang uses gofmt for C++ uses clang-format); for all other file extensions trailing spaces are removed and tabs are converted to spaces (good enough for python)
--  | Lint          | Depends on file extension of file in current buffer: for .sh files runs shellcheck; for .go files it runs make vet (assumes there is a makefile with vet target); for .py files it runs pylint on the file in current buffer.
--	| MakeTags	    | based on extension of file in the current buffer: for extension cpp h hpp runs ctags for c++; for extension go it runs gotags for golang; Set tags to root dir of current git repo, else takes current directory as tag directory; then finds all relevant files under tag directory and writes tags file in tag directory.
--	| UseTags	    | from current directory: if in git archive and the root directory contains a tag file then use it. This is also Run on vim start up.
--	| Entry		    | Put in a header with date and time & switches to insert mode (handy to edit plan.txt) (**)
--	| Comment	    | Comment a block of selected text in the current buffer (if current buffer is in c/go/shell/python/perl)
--	| Uncomment	    | Comment a block of selected text in the current buffer (if current buffer is in c/go/shell/python/perl)


** i usually keep a single plan.txt file in my home directory. Each entry has an identical header of the following form (this practice is very helpful in organizing my notes and thoughts)
the :Entry command puts this delimiting line:

```
---13/10/20 15:57:40----------------------
```


Note that some key combinations may not work because the emulator has swallowed some of them.
For example tmux needs to have the following line in ~/.tmux.conf 

```
set-window-option -g xterm-keys on
```

i also added a trick to change the cursor shape while in insert mode; now only works if vim is run in a gnome terminal or in an xterm terminal.

## Setup

Note that this .vimrc file uses [vundle](https://github.com/VundleVim/Vundle.vim) and the [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) plugin for code completion ; 

Now here in this repository there is a script to automate the installation of all of this goodness (alternatively you can set it all up in a docker), see the [README.me](https://github.com/MoserMichael/myenv/blob/master/README.md) file in this project for the details.


## Other interesting things


Interesting things happen if paste mode is on (set paste) "When the 'paste' option is switched on (also when it was already on): mapping in Insert mode and Command-line mode is disabled" - so i can't do 'set paste'; you never stop learning with vim; amazing. 

also you can't copy/paster to the clipboard by default if you install vim from the packet manager (on ubuntu and fedora); so you can have a workaround by running a command line tool: xsel
Now in my .vimrc script: if xsel is installed then Ctrl-C and Ctrl-X will also put the stuff into the x windows selection (x windows clipboard); To paste from the x windows selection you have the Paste command.

the next command checks if your vim is build with support for x windows (can copy to the x clipboard); if it says 0 then it can't do that.

```
vim --version | grep -E [+]\(xterm_\)?clipboard  | wc -l
```

## what i learned

interesting how everything that has to do with computers can easily turn into a science of its own... now that often happens when different systems or components are plugged together; that may well be a general rule in this business (the complex thing is that changing one little thingy easily breaks a different feature)

i guess the point of the regular vim interface is to get people used to some form of functional programming - by combining commands into sequences; an example of this is viwd which is the sequence to delete the current word. However i didn't manage to get any good at memorizing these incantations ; it also didn't quite help me having to think simulataneously about how to get my tasks done and which vim trick should be used right now (i would have think in the language of the domain and in the language of vim - both at the same time)

Anyway, i think you can customize your way through it, that also gives you some skills - and is also according to the unixy way of doing things.
