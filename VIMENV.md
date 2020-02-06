## MY VIM envionment

Prior to working with linux i used to work on windows for quite some time and got used to all the editor shortcuts; Linux brought a big change in how texts are modified and i had to get used to vim.

Now I had to do some customizing, in order to get an environment that was somehow similar to what i was used to work with.
The result of this is my [.vimrc](https://github.com/MoserMichael/myenv/blob/master/.vimrc) file (might be useful for others who got windows redrawal symptomps with vim).

So here is how to use it

|Shortcut | Command | explanation 
-- | -- | ---
Tab        |                | indent a selected block of text (and leave selection on) - or indent current line
Shift-Tab  |                | unindent a selected block of text (and leave selection on) - or unindent the current line
-- | -- | ---
Shift-Left Shift-Right Shift-Up Shift-Down|                | start selecting the text from the current cursor position (enter visual mode). warning: some terminal can swallow it. for tmux you need to add the following to ~/.tmux.conf : set-window-option -g xterm-keys on  
-- | -- | ---
Ctrl+C  |                   | Copy (in visual mode only, that's where you select stuff)
Ctrl+X  |                   | Cut (in visual mode only, that's where you select stuff)
Ctrl+V  |                   | Paste (in all modes)
Ctrl+F  | FindCurrentWord   | find next occurence of word under cursor (<cword>)
Ctrl+A  |                   | force redraw of the screen.
Ctrl+G  | GotoLine          | promt line number and go to it.
F2      |                   | Display man page on current word in quickfix window.
F3      | DoGrep            | Grep in files from current directory down. Search results are put int o the quickfix window.
F5      | Build             | run asynchronous build (if current dir has ./make_override then run it, else make $MAKE_OPT. Compilation errors are put into quickfix window.
Ctrl+F5 | StopBuild         | stop a asynchronous build that is running.
F4      | PrevBuildResult   | show the last build result in quickfix window. (nice if it got overwritten it by grep)
F6 F7   |                   | previous next compiler error.
--	| Format	    | applies code formatter to the current file (golang uses gofmt for C++ uses clang-format)
--	| MakeTags	    | based on extension of current open file: for extension cpp h hpp runs ctags for c++; for go runs ctags for golang. Set tags to root dir of current git repo, else takes current directory as tag directory.

Note that some key combinations may not work because the emulator has swallowed some of them.
For example tmux needs to have the following line in ~/.tmux.conf 

```
set-window-option -g xterm-keys on
```

all in all this set of tools makes vim look like turbo C under MSDOS. (now that reference shows how old i am, and it is still the best dev environment ever, except for Visual C++1.5 ;-)

I don't know how other people work, as for me it's a big improvement that i don't have to switch to the shell in order to do some programming tasks...
