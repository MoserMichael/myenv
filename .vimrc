
"
" Has this already been loaded?
"
if exists("loaded_vc_like_mappings")
  finish
endif
let loaded_vc_like_mappings=1

"============================================================
"Change of common settings
"============================================================

"turn of vi compatibility mode
set nocompatible

"===
"get in vundle
"===
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


Plugin 'git://github.com/ycm-core/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

filetype on

"===
"eof vundle
"===

"turn off vi startup screen (?)
"set shortmess+=I
set shortmess=I " Read :help shortmess for everything else.

"next line will causes colors to look like good ol' norton editor
"blue background is making people friendlier and better. Serious.
"colorscheme blue
"colorscheme evening
colorscheme morning

"show current file name in title bar
set title


" underline the current line when in insert mode. (some like that)
":autocmd InsertEnter * set cul
":autocmd InsertLeave * set nocul

" I like to have a special underscore cusor in insert mode. (works with gnome)
:autocmd InsertEnter * :SetCursorEdit
:autocmd InsertLeave * :SetCursorNormal

"
"preserve indentation level if you press enter - start of line
"is now indented just as the previous line.
"amazing that this is _not_ the default behavior.
set autoindent

"set spaces to local coding convention
set tabstop=4           " width that a <TAB> character displays as

" religious issue of tabs vs spaces. each project seems to have an opinion...
"set expandtab           " convert <TAB> key-presses to spaces
set shiftwidth=4        " number of spaces to use for each step of (auto)indent
set softtabstop=4       " backspace after pressing <TAB> will remove up to this many spaces

"turn off bells on errors (like moving the cursor out of range)
set vb t_vb=

" want to stuff paste in. (problem: when paste mode is on then can't remap in
" insert and command mode; problem to turn it on by default)
"set paste
set nopaste

"always show status line
set laststatus=2

"show cursor pos in status line
set ruler

"======================================================
"search customization
"======================================================

"Case sensitive search
":set noignorecase

"Case insensitive search
:set ignorecase

" highlight all  search matches.
:set hlsearch

"======================================================
"key assignments for grep (find in files) script
"======================================================

:inoremap <F3> <Esc>:DoGrep<Return>

:nnoremap <F3> :DoGrep<Return>

:vnoremap <F3> <Esc>:DoGrep<Return>



"======================================================
"key assignments for find file by name script
"======================================================

:nnoremap <F10> :FindFile<Return>

:vnoremap <F10> <Esc>:FindFile<Return>

:inoremap <F10> <Esc>:FindFile<Return>


"======================================================
"key assignments for save and quit
"======================================================

:nnoremap <F12> :SaveAndQuit<Return>

:vnoremap <F12> <Esc>:SaveAndQuit<Return>

:inoremap <F12> <Esc>:SaveAndQuit<Return>

"======================================================
"key assignments for Find
"======================================================
:inoremap <C-F> <Esc>:FindCurrentWord<Return>

:nnoremap <C-F> :FindCurrentWord<Return>

:vnoremap <C-F> <Esc>:FindCurrentWord<Return>


"======================================================
"open Buffergator plugin (fast buffer switching)
"======================================================
:inoremap <C-B> <Esc>:BuffergatorOpen<Return>

:nnoremap <C-B> :BuffergatorOpen<Return>

:vnoremap <C-B> <Esc>:BuffergatorOpen<Return>


"======================================================
"key assignments for Build/make script
"======================================================
:nnoremap <F5> :Build<Return>

:vnoremap <F5> <Esc>:Build<Return>

:inoremap <F5> <Esc>:Build<Return>

"======================================================
"key assignments for stop Builds cript
"======================================================
:nnoremap <C-F5> :StopBuild<Return>

:vnoremap <C-F5> <Esc>:StopBuild<Return>

:inoremap <C-F5> <Esc>:StopBuild<Return>

"======================================================
"key assignments for show previous build results
"======================================================
"F4 - show compiler errors (in normal mode)
:nnoremap <F4> :PrevBuildResults<Return>

"F4 - show compiler errors (in visual mode)
:vnoremap <F4> <Esc>:PrevBuildResults<Return>

"F4 - show compiler errors (in insert mode)
:inoremap <F4> <Esc>:PrevBuildResults<Return>

"======================================================
"key assignments to add timestamped entry
"======================================================
":nnoremap <F12> :Entry<Return>
":vnoremap <F12> <Esc>:Entry<Return>
":inoremap <F12> <Esc>:Entry<Return>


"======================================================
"Load C header file (if current line is #include something)
"======================================================

map <F9> :call LoadHeaderFile( getline( "." ), 0 )<CR>

map <C-F9> :call LoadHeaderFile( getline( "." ), 1 )<CR>

"======================================================
"Display man page on word under the cursor
"======================================================

map <F2> :FindHelp<CR>

:inoremap <F2> <Esc>:FindHelp<Return>

:vnoremap <F2> <Esc>:FindHelp<Return>

"======================================================
" goto line (prompts for number)
"======================================================

"Ctlr+G - goto line (insert mode)
":inoremap <C-G> <Esc>:
:inoremap <C-G> <Esc>:GotoLine<Return>

"Ctlr+G - goto line (command mode)
":nnoremap <C-G> :
:nnoremap <C-G> :GotoLine<Return>

"Ctlr+G - goto line (visual mode)
":vnoremap <C-G> <Esc>:
:vnoremap <C-G> <Esc>:GotoLine<Return>


"======================================================
"key assignments
"======================================================

" <Ctrl+A> force redraw the screen.
" at some stage you need to force redraw the window; don't know why.

:vnoremap <C-A> <Esc>:redraw!<Return>

:inoremap <C-A> <Esc>:redraw!<Return>i

:nnoremap <C-A> :redraw!<Return>


" old remap
":vnoremap <C-C> y
":vnoremap <C-X> x
":nnoremap <C-V> P
":vnoremap <C-V> P
":inoremap <C-V> <Esc>Pi

"Ctrl+C - copy
:vnoremap <C-C> y:<Esc>:MyCPXAfterYank<Return>
:nnoremap <C-C> :MyCPXCurrentWord<Return>
:inoremap <C-C> <Esc>:MyCPXCurrentWord<Return>i

"Ctrl+X - cut
:vnoremap <C-X> x:<Esc>:MyCPXAfterYank<Return>
:nnoremap <C-X> :MyCPXCurrentWord<Return>diw
:inoremap <C-X> <Esc>:MyCPXCurrentWord<Return>diwi

"Ctrl+V - paste
:vnoremap <C-V> dy:<Esc>:MyCPXPaste<Return>l
:nnoremap <C-V> :MyCPXPaste<Return>l
:inoremap <C-V> <Esc>:MyCPXPaste<Return>li


"Ctrl+R - redo (in insert mode)
:inoremap <C-R> <Esc>:red<Return>i

"Ctrl+U - undo (in normal mode only)
:nnoremap <C-U> :u<Return>

"Ctrl+U - undo (in insert mode - return to normal mode and undo>
:inoremap <C-U> <Esc>:u<Return>i

"F8 - split windows
:nnoremap <F8> :split<Return>

"F8 - split windows (in visual mode)
:vnoremap <F8> <Esc>:split<Return>

"F8 - split windows (in insert mode)
:inoremap <F8> <Esc>:split<Return>i



"Control + cursor key will goto next/previous word
":nnoremap <C-Left> B
":vnoremap <C-Left> B
":inoremap <C-Left> <Esc>Bi
"
":nnoremap <C-Right> W
":vnoremap <C-Right> W
":inoremap <C-Right> <Esc>Wi
"


"
"Shift + cursor key will start selection of text
"results in selection of text.
"
"Problem: some terminal key mapping kill this (like RXVT terminal) XTERM is ok.
"in tmux you need to add the following line:
"set-window-option -g xterm-keys on

:nnoremap <S-Left> v<Left>
:inoremap <S-Left> <Esc>v<Left>
:vnoremap <S-Left> <Left>
:nnoremap <S-Right> v<Right>
:vnoremap <S-Right> <Right>
:inoremap <S-Right> <Esc>v<Right>
:vnoremap <S-Right> <Right>
:nnoremap <S-Up> v<Up>
:inoremap <S-Up> <Esc>v<Up>
:vnoremap <S-Up> <Up>
:nnoremap <S-Down> v<Down>
:inoremap <S-Down> <Esc>v<Down>
:vnoremap <S-Down> <Down>


"Can't override Ctrl+Q and all other combinations are already set
":inoremap <C-A> <Esc>:q<Enter>

"Ctlr+A - quit (in normal mode only)
"Can't override Ctrl+Q and all other combinations are already set
":nnoremap <C-A> :q<Enter>

"Ctlr+A - quit (in visual mode only)
"Can't override Ctrl+Q and all other combinations are already set
":vnoremap <C-A> <Esc>:q<Enter>

"Ctrl+W - save (in insert mode only>
":inoremap <C-W> <Esc>:w<Return>a
"
"Ctrl+W - save (in normal mode only)
":nnoremap <C-W> :w<Return>
"
"ALt+W - save & overwrite read only file (in insert mode only>
":inoremap <A-W> <Esc>:w+<Return>a
"
"Alt+W - save overwrite read only file (in normal mode only)
":nnoremap <A-W> :w+<Return>

"F3 - show next search hit
":nnoremap <F3> /<Return>

"F3 - show next search hit (in visual mode)
":vnoremap <F3> <Esc>/<Return>

"F3 - show next search hit (in insert mode)
":inoremap <F3> <Esc>/<Return>

"---
"


"Tab - indent a block of text (one tab deep)
:nnoremap <Tab> >>
:vnoremap <Tab> >gv

:nnoremap <S-Tab> <<
:vnoremap <S-Tab> <gv


"F4 - show compiler errors (in normal mode)
":nnoremap <F4> :copen<Return>

"F4 - show compiler errors (in visual mode)
":vnoremap <F4> <Esc>:copen<Return>

"F4 - show compiler errors (in insert mode)
":inoremap <F4> <Esc>:copen<Return>


"F6 - goto previous compiler error (normal mode)
":nnoremap <F6> :cp<Return>

"F6 - goto previous compiler error (in visual mode)
:vnoremap <F6> <Esc>:cp<Return>

"F6 - goto previous compiler error (in insert mode)
:inoremap <F6> <Esc>:cp<Return>

"F7 - goto next compiler error (normal mode)
:nnoremap <F7> :cn<Return>

"F7 - goto next compiler error (in visual mode)
:vnoremap <F7> <Esc>:cn<Return>

"F7 - goto next< compiler error (in insert mode)
:inoremap <F7> <Esc>:cn<Return>

"Shift-Tab - unindent a block of text (one tab down)
"This one is commented out, Shift-Tab also covers Alt-Tab - then you can' switch
"windows any longer.
":inoremap <S-Tab> <C-O><LT><LT>
":nnoremap <S-Tab> <LT><LT>
":vnoremap <S-Tab> <LT>

"======================================================
" internal: plugin install and exit
"======================================================

command! -nargs=* MyPInstall call s:RunMyPInstall()

function! s:RunMyPInstall()
    PluginInstall
    execute "q!"
    execute "q!"
endfunction

"======================================================
" Copy and paste
"
" if xsel is installed then copy also puts to x clipboard.
"======================================================
command! -nargs=* MyCPXAfterYank call s:RunMyCPXAfterYank()
command! -nargs=* MyCPXCurrentWord call s:RunMyCPXCurrentWord()
command! -nargs=* MyCPXPaste call s:RunMyCPXPaste()
command! -nargs=* MyCPXPasteWord call s:RunMyCPXPasteWord()

function! s:RunMyCPXAfterYank()
        let g:YankedText=getreg("")
        call system("xsel -i -b", g:YankedText )
endfunction

function! s:RunMyCPXCurrentWord()
        let g:YankedText=expand("<cword>")
        call system("xsel -i -b", g:YankedText )
endfunction

function! s:RunMyCPXPaste()
    if exists("g:YankedText")
        set paste
        execute "normal! i" . g:YankedText
        set nopaste
    endif
endfunction

function! s:RunMyCPXPasteWord()
   if exists("g:YankedText")
        " in normal mode: delete the current text and put in the yanked text
        execute "normal! viwdi" . g:YankedText
    endif
endfunction

"======================================================
" paste from x clipboard into vim (without paste)
" set paste doesn't allow to override keys in inserv/visul mode.
" and most installations come without xwindows support.
"
" needs xsel installed
"======================================================
command! -nargs=* Paste call s:RunYpaste()

function! s:RunYpaste()
    let g:YankedText = system("xsel -o -b")
    if g:YankedText != ""

        " in normal mode: delete the current text and put in the yanked text
        set paste
        execute "normal! i" . g:YankedText
        set nopaste
        call setreg("", g:YankedText)
    endif
endfunction

"======================================================
" List buffers in error window in chose one of them
"======================================================
"command! -nargs=* Cb call s:ChooseBuffer()
"
"
"
"function! s:ChooseBuffer()
    "let bufnumber = 1
    "let sbuffers = ""
    "
    "while  bufexists( bufnumber )
    "    let bname = bufname( bufnumber )
    "   let sbuffers = sbuffers . bufnumber . " " . bname . "\n"
    "    let bufnumber = bufnumber + 1
    "endwhile
    "
    "
    "let outfile = tempname()
    "
    ""shit - this one is disabled for security reasons
    "call writefile( sbuffers, outfile )
    "
    "execute "silent! cgetfile " . outfile
"endfunction


"======================================================
" check if there is a makefile here; 
" optionally checks if target exists.
"======================================================

function! s:MakeHasTarget(targetName)
    " name of default makefiles:  
    let s:makefilenames = [ 'GNUmakefile', 'makefile', 'Makefile' ]

    for s:item in s:makefilenames 
        if filereadable(s:item)
            if a:targetName == ''
                return 1
            endif
            let s:cmd = "grep -cE '^" . a:targetName . ":'" 
            let s:hasTarget=system(s:cmd) 
            if s:hasTarget != "0"
                return 1
            endif
        endif
    endfor
endfunction

"======================================================
"Build  script
"======================================================

command! -nargs=* Build call s:RunBuild()
command! -nargs=* StopBuild call s:StopBuild()
command! -nargs=* PrevBuildResults call s:SetPrevBuildResults()

" bring back the result of the last build (restores quickfix window)
function! s:SetPrevBuildResults()
  if exists("g:buildCommandOutput")
      " Read the output from the command into the quickfix window
      "execute "cfile! " . g:buildCommandOutput
      "
      let old_efm = &efm
      set efm=%f:%l:%m
      execute "silent! cgetfile " . g:buildCommandOutput
      let &efm = old_efm
      " Open the quickfix window
      copen
  endif
endfunction



" This callback will be executed when the entire command is completed
function! BackgroundCommandClose(channel)
  if exists("g:build_job")
      " Read the output from the command into the quickfix window
      "execute "cfile! " . g:buildCommandOutput
      execute "silent! cgetfile " . g:buildCommandOutput
      " Open the quickfix window
      copen

      "don't delete build results (PrevBuildResults can bring them back)
      "call delete( g:buildCommandOutput )
      "unlet g:buildCommandOutput

      unlet g:build_job
  endif
endfunction

function! s:RunBuild()

    " save the current file
    execute "silent! :w"

    " delete previous build results
    if exists("g:buildCommandOutput")
      call delete( g:buildCommandOutput )
      unlet g:buildCommandOutput
    endif


    " run build command ---
    if filereadable("./make_override")
        let buildcmd = './make_override'
    else
        if s:MakeHasTarget('') == 0
            echo "build expects either a makefile in the search path or  script ./make_override in the current directory"
            return
        endif
 

        let buildcmd = "make " . $MAKE_OPT
    endif

    echo "Running: " . buildcmd . " (asynchronous) ... "

    let buildcmd = buildcmd . " 2>&1"

    let g:buildCommandOutput = tempname()

    let g:build_job = job_start(["bash", "-c", buildcmd], {'close_cb': 'BackgroundCommandClose', 'out_io': 'file', 'out_name': g:buildCommandOutput})

    botright copen

    " clean out previous buid results
    execute "silent! cgetfile " . g:buildCommandOutput


endfunction


function! s:StopBuild()
    if exists("g:build_job")
       echo "stopping build"
       call job_stop(g:build_job)
       unlet g:build_job
       call delete( g:buildCommandOutput )
       unlet g:buildCommandOutput
    else
       echo "no build running"

    endif

endfunction


function! s:RunOldBuildSynchronously()

    " save the current file
    execute "silent! :w"

    let tmpfile = tempname()


    "build and surpresses build status messages.
    "(those are not very informative and may be very very long)
    "Error messages are redirected to temporary file.

    if filereadable("./make_override")
        let buildcmd = "./make_override " . $MAKE_OPT . " > " . tmpfile . " 2>&1"
    else
        let buildcmd = "make " . $MAKE_OPT . " > " . tmpfile . " 2>&1"
    endif

    "let fname = expand("%")
    "let fnameidx = strridx(fname,".")
    "if fnameidx != -1
    "let ext = fname[ fnameidx : ]
    "if ext == ".pl" || ext == ".perl"
    "   let buildcmd = "perl -c " . fname . ' 2>&1 | perl -ne ''$_ =~ s#.*line (\d+).*#' . fname . ':$1: $&#g; print $_;'' | tee ~/uuu >' . tmpfile
    "   endif
    "endif

    " --- run build command ---
    echo "Running make ... "

    let cmd_output = system(buildcmd)

   if getfsize(tmpfile) == 0

     cclose
     execute "silent! cfile " . tmpfile
     echo "Build failed"

   else
      let old_efm = &efm
      set efm=%f:%l:%m
      execute "silent! cfile " . tmpfile
      let &efm = old_efm

      botright copen
   endif
   call delete(tmpfile)

   botright copen

endfunction


"======================================================
" pretty print/format the current source file.
"======================================================

command! -nargs=* Format call s:RunFormat()

function! s:RunFormat()

    let s:extension = expand('%:e')

    " remove trailing spaces, in an case
    if s:extension == "go"
        echo "formatting go code"
        execute "silent! :w"
        let s:file = expand('%:p')
        let s:cmd = "gofmt -w " . s:file
        call system( s:cmd )
        execute "silent! e ". s:file
    elseif s:extension == "c" || s:extension == "cpp" || s:extension == "h"
    echo "formatting c/c++ code"
        execute "silent! :w"
        let s:file = expand('%:p')
        let s:cmd = "clang-format -i " . s:file
        call system( s:cmd )
        execute "silent! e ". s:file
    else
        echo "for extension ". s:extension " : tabs to spaces & removing trailing spaces only."
        "tabs to spaces
        :retab
        "remove trailing newlines
        :%s/\s\+$//e
        :set ff=unix
        execute "silent! :w"
    endif
endfunction


"======================================================
"" check/lint the current source file.
"======================================================

command! -nargs=* Lint call s:RunLint()


function! s:RunLint()

    let s:extension = expand('%:e')

    let s:file = expand('%:p')
    let s:tmpfile = tempname()

    if s:extension == "sh"
        execute "silent! :w"

        let s:cmd = "shellcheck -f gcc " . s:file . " > " . s:tmpfile . " 2>&1"

        let old_efm = &efm
        set efm=%f:%l:%m

    elseif s:extension == "py"
        execute "silent! :w"

        " enable warnings and errors
        let s:cmd = "pylint --disable=R,C " . s:file . " > " . s:tmpfile . " 2>&1"

        " enable errors only
        "let s:cmd = "pylint -E " . s:file . " > " . s:tmpfile . " 2>&1"

        let old_efm = &efm
        set efm=%f:%l:%m

    elseif s:extension == "go"
        execute "silent! :w"

        if s:MakeHasTarget('vet') 
            let s:cmd = "make vet > " . s:tmpfile . " 2>&1"

            let old_efm = &efm
            set efm=%f:%l:%m
        else
            echo "for go it assumes a Makefile with target vet in the search path"
        endif
    else
        echo "no action for file extension ". s:extension
        call delete(s:tmpfile)
        return
    endif

    call system( s:cmd )
    let &efm = old_efm

    botright copen

	execute "silent! cgetfile " . s:tmpfile
    call delete(s:tmpfile)

    if getfsize(s:tmpfile)  == 0
        echohl WarningMsg |
        \ echomsg "*** no lint errors found ***" |
        \ echohl None
        return
    endif
endfunction

"======================================================
" comment out a selection of lines
"======================================================

command! -nargs=* Comment call s:RunComment()
command! -nargs=* Uncomment call s:RunUncomment()



function! s:RunComment()

    let s:extension = expand('%:e')

    if s:extension == "sh" || s:extension == "py" || s:extension == "pl"

        let s:cmt="#"

    elseif s:extension == "go" || s:extension == "cpp" || s:extension == "c" || s:extension == "h" || s:extension == "hpp"

        let s:cmt="//"

    else

        echo "can't comment out buffer with extension " . s:extension
        return

    endif

    let [s:line_start, s:column_start] = getpos("'<")[1:2]
    let [s:line_end, s:column_end] = getpos("'>")[1:2]


    let s:cur = s:line_start
    while s:cur <= s:line_end
    "
        let s:line = s:cmt . getline(s:cur)
        call setline(s:cur, s:line)
        let s:cur = s:cur + 1
    endwhile
endfunction

function! s:RunUncomment()

    let s:extension = expand('%:e')

    if s:extension == "sh" || s:extension == "py" || s:extension == "pl"

        let s:cmt="#"
        let s:cmtlen=1

    elseif s:extension == "go" || s:extension == "cpp" || s:extension == "c" || s:extension == "h" || s:extension == "hpp"

        let s:cmt="//"
        let s:cmtlen=2

    else

        echo "can't comment out buffer with extension " . s:extension
        return

    endif

    let [s:line_start, s:column_start] = getpos("'<")[1:2]
    let [s:line_end, s:column_end] = getpos("'>")[1:2]


    let s:cur = s:line_start
    let s:extractlen=s:cmtlen-1
    while s:cur <= s:line_end
    "
        let s:line = getline(s:cur)

        if s:line[0:s:extractlen] == s:cmt
            call setline(s:cur, s:line[s:cmtlen:])
        endif
        let s:cur = s:cur + 1
    endwhile
endfunction




"======================================================
" Use tags (search in git root, else in current dir)
"======================================================
command! -nargs=* UseTags call s:RunUseTags()

function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

function s:RunUseTags()

    let s:get_root="git rev-parse --show-toplevel 2>/dev/null"
    let s:top_dir = system(s:get_root)

    if s:top_dir == ""
        let s:top_dir = getcwd()
    endif

    let s:top_dir=Chomp(s:top_dir)
    let s:tag_file = s:top_dir . "/tags"

    if filereadable(s:tag_file)
        let s:set_cmd = "set tags=". s:tag_file
        execute s:set_cmd
        "echo "set tags ". s:tag_file
    endif

endfunction

call s:RunUseTags()

"======================================================
" Build tags based on the extenson of file open in the editor
"======================================================
command! -nargs=* MakeTags call s:RunMakeTags()

function! s:RunMakeTags()

    let s:extension = expand('%:e')

    if s:extension == "go"

        echo "building go tags"
        execute "silent! :w"
        let s:cmd="find . -type f ( -name \'*.go\' ) -print0 | xargs -0 /usr/bin/gotags >tags"

    elseif s:extension == "c" || s:extension == "cpp" || s:extension == "cxx" || s:extension == "h" || s:extension == "hpp" || s:extension == "hxx"

        echo "building c/c++ tags"
        execute "silent! :w"
        let s:cmd="find . -type f ( -name \'*.c\' -o -name \'*.cpp\' -o -name \'*.cxx\' -o -name \'*.hpp\' -o -name \'*.hxx\' -o -name \'*.h\' ) | xargs ctags -a --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"

    elseif s:extension == "py"

        echo "building python tags"
        execute "silent! :w"
        let s:cmd="find . -type f ( -name \'*.py\' ) | xargs ctags -a --language-force=Python"

    else
        echo "can't build ctags for open file with extension: " . s:extension
        return
    endif

    let s:get_root="git rev-parse --show-toplevel 2>/dev/null"
    let s:top_dir = system(s:get_root)

    if s:top_dir == ""
    let s:top_dir = getcwd()
    endif


    let s:top_dir=Chomp(s:top_dir)
    let s:cmd=escape(s:cmd,'()')
    let s:script= '/bin/bash -c "cd ' . s:top_dir . ";" . s:cmd  . '"'

    if s:cmd != ""
        "echo s:script
        call system( s:script )
        let s:set_tags = "set tags=". s:top_dir . "/tags"
        execute s:set_tags
    else
        echo "no command to make tags; current editor file must be either in go or c++"
    endif

endfunction


"======================================================
" Goto line script
"======================================================
command! -nargs=* GotoLine call s:RunGotoLine()

function! s:RunGotoLine()
    let linenr = input("Line number to jump to: ")
    if linenr == ""
        return
    endif

    execute "normal " . linenr . "gg"
endfunction


"======================================================
" search for word that appears at cursor.
"======================================================
"
command! -nargs=* FindCurrentWord call s:RunFindCurrentWord()

function! s:RunFindCurrentWord()
  call feedkeys("*")

  "let curw = expand("<cword>")
  "if curw != ""
  "  "let g:hlsearch="on"
  "  let [lnum, ncol] = searchpos( expand("<cword>") )
  "  if lnum != 0 && ncol != 9
  "      call col(ncol)
  "  endif
  "
  "  "execute "/" . curw
  "endif
endfunction


"======================================================
"Find file by name script
"======================================================
command! -nargs=* FindFile call s:RunFindFile()

function! s:RunFindFile()
    let pattern = input("Find file name: ", expand("<cword>"))
    if pattern == ""
        return
    endif

    let tmpfile = tempname()
    let cmd = "find . -name \"*" . pattern . "*\" | xargs xargs stat -c \"%n:1: %A %010U %010s %F \" | tee " . tmpfile

    echo cmd

    " --- run grep command ---
    let cmd_output = system(cmd)

    if cmd_output == ""
        echohl WarningMsg |
        \ echomsg "Error: Pattern " . a:pattern . " not found" |
        \ echohl None
        return
    endif

    " --- put output of grep command into message window ---
    let old_efm = &efm
    set efm=%f:%l:%m

   "open search results, but do not jump to the first message (unlike cfile)
   "execute "silent! cfile " . tmpfile
    execute "silent! cgetfile " . tmpfile

    let &efm = old_efm

    botright copen

    "call delete(tmpfile)


 endfunction

"======================================================
"Find help script
"======================================================
command! -nargs=* FindHelp call s:RunFindHelp()

function! s:RunFindHelp()

  let searchterm = expand("<cword>")
  if searchterm == ""
    return
  endif

  let sections_found=""
  let numsections_found=0

  "=== find all man pages where search term is mentioned ===
  let section=1
  while section<=9
      let errorfile = tempname()

      let command = 'man '.section.' '.searchterm.' 2>'. errorfile
      let output = system(command)

      if getfsize(errorfile) == 0 && output != ""
     "if stridx(,'No entry for')
         let numsections_found = numsections_found + 1
     let sections_found=section.' '.sections_found
      endif

      let section = section + 1

      call delete(errorfile)

  endwhile

  if numsections_found == 0
      let answer = input('no help topic found for '.searchterm . " Run apropos? (y, n) ",'y')
      if answer != 'y'
        return
      endif

      let outfile = tempname()
      let command = 'apropos ' . searchterm . ' | tee '.outfile
      let output = system(command)
      execute "silent! cgetfile " . outfile
      call delete(outfile)

      botright copen

      return
  endif

  if numsections_found > 1
      let displaystring = strpart(sections_found,0, strlen(sections_found)-1)
      let section = input("Topic found in pages (".displaystring.") select page to view: " , "")

      if stridx(sections_found, section.' ') == -1
        echo 'wrong selection'
    return
      endif
  else
      let section = sections_found
  endif

  "=== run man command ====
  let outfile = tempname()
  let command = 'man '.section.' '.searchterm.' | col -b | tee '.outfile
  let output = system(command)

  execute "silent! cgetfile " . outfile
  call delete(outfile)

  botright copen

endfunction

"======================================================
"put an entry with the date/time (for keeping plan.txt)
"======================================================

command! -nargs=* Entry call s:RunEntry()

function! s:RunEntry()
  let s:tm = "\n---" . strftime("%d/%m/%y %H:%M:%S") . "----------------------\n"

  execute "normal! i" . s:tm
  " enter insert mode because it's time  to write stuff now.
  call feedkeys("i")
endfunction

"======================================================
"grep script
"Courtesy of Yegappan Lakshmanan
"
"(with my modifications)
"======================================================
command! -nargs=* DoGrep call s:RunGrep()

if !exists("Grep_Default_Filelist")
    let Grep_Default_Filelist = '*.cc *.c *.cpp *.cxx *.h *.inl *.hpp *.hxx *.py *.go'
endif

if !exists("Grep_Default_Dir")
    let Grep_Default_Dir = '.'
endif

" Character to use to quote patterns and filenames before passing to grep.
if !exists("Grep_Shell_Quote_Char")
    if has("win32") || has("win16") || has("win95")
        let Grep_Shell_Quote_Char = ''
    else
        let Grep_Shell_Quote_Char = "'"
    endif
endif

function! s:RunGrep()
   " --- No argument supplied. Get the identifier and file list from user ---
    let pattern = input("Grep for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let pattern = g:Grep_Shell_Quote_Char . pattern . g:Grep_Shell_Quote_Char

    let filenames = input("Grep in files: ", g:Grep_Default_Filelist)
    if filenames == ""
        return
    endif

"   if filenames != g:Grep_Default_Filelist
"     let g:Grep_Default_Filelist = filenames
"   endif

    let searchdir = input("Grep in directory: ", g:Grep_Default_Dir)
    if searchdir == ""
        return
    endif
    if searchdir != g:Grep_Default_Dir
      let g:Grep_Default_Dir = searchdir
    endif


    " --- build find command ---
    let txt = filenames . ' '
    let find_file_pattern = ''

    while txt != ''
        let one_pattern = strpart(txt, 0, stridx(txt, ' '))
        if find_file_pattern != ''
            let find_file_pattern = find_file_pattern . ' -o'
        endif
        let find_file_pattern = find_file_pattern . ' -name ' . g:Grep_Shell_Quote_Char . one_pattern . g:Grep_Shell_Quote_Char

        let txt = strpart(txt, stridx(txt, ' ') + 1)
     endwhile

    let tmpfile = tempname()
    let grepcmd = 'find ' . searchdir . " " . find_file_pattern . " | xargs grep -n " . pattern . " |  tee " . tmpfile

    " --- run grep command ---
    let cmd_output = system(grepcmd)

    if cmd_output == ""
        echohl WarningMsg |
        \ echomsg "Error: Pattern " . pattern . " not found" |
        \ echohl None
        return
    endif

    " --- put output of grep command into message window ---
    let old_efm = &efm
    set efm=%f:%l:%m

   "open search results, but do not jump to the first message (unlike cfile)
   "execute "silent! cfile " . tmpfile
    execute "silent! cgetfile " . tmpfile

    let &efm = old_efm

    botright copen

    call delete(tmpfile)

endfunction


"======================================================
" save and quit 
"======================================================
command! -nargs=* SaveAndQuit call s:RunSaveAndQuit()

" if the current buffer has been modified - save it and quit
function! s:RunSaveAndQuit()

    " if current buffer has been modified
    if &mod == 1
        if @% == ""
            echo "can't save and quit unnamed buffer"
            return
        endif
        w!
    endif
    q
endfunction
 
"======================================================
" set cursor in gnome
"======================================================

command! -nargs=* SetCursorNormal call s:SetCursorNormal()
command! -nargs=* SetCursorEdit call s:SetCursorEdit()

function! s:SetCursorNormal()
    
    if stridx(&term,"xterm")==0 || stridx(&term,"screen") == 0
        " for gnome terminal and xterm ?
        silent !echo -ne '\e[1 q'
        redraw!
    endif
endfunction
 

function! s:SetCursorEdit()
    if stridx(&term,"xterm")==0 || stridx(&term,"screen") == 0
        " for gnome terminal and xterm ?
        silent !echo -ne '\e[3 q'
        redraw!
    endif
endfunction
 
"======================================================
"Load header file included from the current line.
"Courtesy of Garner Halloran (garner@havoc.gtf.org)
"
"(with my modifications)
"======================================================
function! LoadHeaderFile( arg, loadSource )
  if match( a:arg, "#include" ) >= 0
    " find either a starting < or "
    let start = match( a:arg, "<\\|\"" )

    if start < 0
      return
    endif

    let start = start + 1

    let $filename = strpart( a:arg, start )

    " find either an ending > or "
    let end = match( $filename, ">\\|\"" )

    if end > 0
      " get the final filename to open
      let $filename = strpart( $filename, 0, end )

      " if loadSource is 1, then replace .h with .cpp and load that file instead
      if a:loadSource == 1
      let $filename = substitute( $filename, "\\V.h", ".cpp", "" )
    " if loadSource is 2, then replace .h with .c and load that file instead
    elseif a:loadSource == 2
      let $filename = substitute( $filename, "\\V.h", ".c", "" )
    endif

    "my change directory aliases in .bashrc set this environment variable.
    "add project root directory to search path
    if $PROJECT_DIR != ''
      set path+=$PROJECT_DIR
    endif

    sfind $filename
    return
    "endif
  endif
endfunction

"############################################
" set tabs vs spaces depending on buffer type
"############################################
command! -nargs=* SetModeForBuffer call s:SetModeForBuffer()

function! s:SetModeForBuffer()

    let s:extension = expand('%:e')

	if s:extension != "go"
		set expandtab
	else
		set noexpandtab
	endif
endfunction

autocmd BufEnter * :SetModeForBuffer

"############################################
" folding log files
"############################################
"function! FBuildLogFold(num)
"    let str = getline(a:num)
"    if (str =~ '^[0-9][0-9]*)')
"        return 0
"    elseif (str =~ '^perl ')
"        return 0
"    elseif (str =~ '^V[XC] tests ')
"        return 0
"    " elseif (str =~ '^\[')
"    "    return 0
"    else
"        return 1
"    endif
"endfunction
"
"function! FBuildLogFoldOn()
"    execute "set foldexpr=FBuildLogFold(v:lnum)"
"    execute "set foldmethod=expr"
"endfunction
"com! BuildFoldOn :call FBuildLogFoldOn()

filetype plugin on
