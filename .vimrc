
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

Plugin 'jeetsukumaran/vim-buffergator'

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
colorscheme blue
"colorscheme evening
"colorscheme morning

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

" don't keep .*.swp? lock files. (they never help me, and seem to mess things up more then they help)
set nobackup
set nowritebackup
set noswapfile

"turn off bells on errors (like moving the cursor out of range)
set vb t_vb=

" want to stuff paste in. (problem: when paste mode is on then can't remap in
" insert and command mode; problem to turn it on by default)
"set paste
set nopaste


function! StatusLineGitBranch() 
    let s:branch_name = trim(system("git branch 2>/dev/null | grep '*' | tail -c +2")) 
    if s:branch_name == ""
        return ""
    endif
    return '[' . s:branch_name . ']'
endfunction    
    
set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)\ %{StatusLineGitBranch()}

"always show status line
set laststatus=2 

"show cursor pos in status line
set ruler


"======================================================
" utility functions
"======================================================
function! s:Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

function! s:BeepNow()
    :set novisualbell
    :set errorbells
    :exe "normal \<Esc>"
endfunction

function! s:GitCheckGitDir()
   let s:top_dir = s:Chomp( system("git rev-parse --show-toplevel") )
   if v:shell_error != 0 
       echo "current directory not in a git repository"
       return ""
   endif
   return s:top_dir
endfunction


"======================================================
" navigation keys
"======================================================
":map , <PageUp>
":map . <PageDown>

:vnoremap ,  :call RunMPGDV()<Return> 
:vnoremap .  :call RunMPGUV()<Return>

:nnoremap ,  :call RunMPGD()<Return>
:nnoremap .  :call RunMPGU()<Return>


"command! -nargs=* MyPageDown call s:RunMPGD()
"command! -nargs=* MyPageUp call s:RunMPGU()

function! RunMPGDV()
    normal gv
    call RunMPGD()
endfunction

function! RunMPGD()
    let s:pagesize = winheight(0)
    let s:filesize = line('$')
    let s:topline = line('w0')

    let s:move = s:pagesize  
    if s:topline + s:pagesize > s:filesize
        let s:move = s:filesize - s:topline
    endif

        "execute "normal" . s:move . "j"
"        let s:vm = visualmode()
"        if s:vm != ""
"            let s:pos = getpos("'>")
"            let s:pos[1] += s:move
"            call setpos("'>", s:pos)
"        else
            let s:curline = line('.') + s:move
            let s:col = col('.')
            call setpos(".", [0,  s:curline, s:col ] )
"        endif    
endfunction

function! RunMPGUV() 
    normal gv
    call RunMPGU()
endfunction

function! RunMPGU() 
    let s:curline = line('.')
    let s:pagesize = winheight(0)
    let s:topline = line('w0')
                
    let s:move = s:pagesize
    if s:curline < s:pagesize
        let s:move = s:curline
    endif

        "execute "normal" . s:pagesize . "k"
        "
"        let s:vm = visualmode()
"        if s:vm != ""
"            let s:pos = getpos("'>")
"            let s:pos[1] += s:pagesize
"            call setpos("'>", s:pos)
"        else
            let s:curline = s:curline - s:move
            let s:col = col('.')
            call setpos(".", [0,  s:curline, s:col ] )
"        endif     
endfunction

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
" enable spell checker for markdown and txt files
"======================================================
"
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell


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

if !exists("g:buffergator_viewport_split_policy")
    let g:buffergator_viewport_split_policy = "T"
endif

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

"map <F2> :FindHelp<CR>

":inoremap <F2> <Esc>:FindHelp<Return>

":vnoremap <F2> <Esc>:FindHelp<Return>

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

" <Ctrl+W> save 
"
":vnoremap <C-W> <Esc>:silent w!<Return>
"
":inoremap <C-W>  <Esc>:silent w!<Return>i
"
"
":nnoremap <C-W>t :silent w!<Return>
"


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

"======================================================
"open quickfix window, and make it a third of the screen
"======================================================

function!  s:OpenQuickFix()
	let size = &lines
	let size = size / 3
    let s:ccmdo = 'copen ' . size
    execute s:ccmdo
endfunction

command! -nargs=* OpenQuickFix call s:OpenQuickFix()



"F4 - show compiler errors (in normal mode)
":nnoremap <F4> OpenQuickFix<Return>

"F4 - show compiler errors (in visual mode)
":vnoremap <F4> <Esc>:OpenQuickFix<Return>

"F4 - show compiler errors (in insert mode)
":inoremap <F4> <Esc>OpenQuickFix<Return>


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
" toggle spelling
"======================================================
command! -nargs=* SpellOff setlocal nospell
command! -nargs=* SpellOn setlocal spell

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
        if has('macunix')
            call system("pbcopy", g:YankedText )
        else
            call system("xsel -i -b", g:YankedText )
        endif
endfunction

function! s:RunMyCPXCurrentWord()
        let g:YankedText=expand("<cword>")
        if has('macunix')
            call system("pbcopy", g:YankedText )
        else
            call system("xsel -i -b", g:YankedText )
        endif    
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

        if has('macunix')
            let g:YankedText = system("pbpaste")
        else
            let g:YankedText = system("xsel -o -b")
        endif    
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

command! -nargs=* B call s:RunBuild()
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
      OpenQuickFix
  endif
endfunction



" This callback will be executed when the entire command is completed
function! BackgroundCommandClose(channel)
  if exists("g:build_job")
      " Read the output from the command into the quickfix window
      "execute "cfile! " . g:buildCommandOutput
      execute "silent! cgetfile " . g:buildCommandOutput
      " Open the quickfix window
      OpenQuickFix

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

    OpenQuickFix

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

      OpenQuickFix
   endif
   call delete(tmpfile)

   OpenQuickFix

endfunction


"======================================================
" pretty print/format the current source file.
"======================================================

command! -nargs=* Format call s:RunFormat()

function! s:RunOnCurrentBuffer(cmd, opts)

    if executable(a:cmd)
        let s:file = expand('%:p')
        if filewritable(s:file)
            execute "silent! :w"
            let s:cmd = a:cmd . " " . a:opts . " " . s:file
            call system( s:cmd )
            execute "silent! e ". s:file
        else 
            echo "Error: file " . s:file . " is not writable"
        endif
    else
        echo "Error: " . a:cmd . " program is not in the current path"
    endif

endfunction

function! s:RunFormat()

    let s:extension = expand('%:e')

    " remove trailing spaces, in an case
    if s:extension == "go"
        echo "formatting go code"
        call s:RunOnCurrentBuffer("gofmt", "-w")
    elseif s:extension == "c" || s:extension == "cpp" || s:extension == "h" || s:extension == "hpp"
        echo "formatting c/c++ code"
        call s:RunOnCurrentBuffer("clang-format", "-i")
    elseif s:extension == "py"
        echo "formatting python code"
        call s:RunOnCurrentBuffer("black","")
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

    " save the current file
    execute "silent! :w"

    let s:extension = expand('%:e')

    let s:file = expand('%:p')
    let s:tmpfile = tempname()

    if s:extension == "sh"
        execute "silent! :w"

        let s:cmd = "shellcheck -f gcc " . s:file . " > " . s:tmpfile . " 2>&1"

        let old_efm = &efm
        set efm=%f:%l:%m

    elseif s:extension == "py"
        " remove trailing whitespaces (tha's one of the issues)
        :%s/\s\+$//e
        execute "silent! :w"

        " enable warnings and errors
        let s:cmd = "pylint --disable=C0301 --disable=C0116 --disable=C0115 --disable=C0114 " . s:file . " > " . s:tmpfile . " 2>&1"

        "let s:cmd = "pylint --reports=n --output-format=parseable %:p --disable=R,C " . s:file . " > " . s:tmpfile . " 2>&1"

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

    OpenQuickFix

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
    let s:file=expand('%:p')

    if has('win32') || has ('win64')
        let  s:VIMRC = $VIM."/.vimrc"
    else
        let  s:VIMRC = $HOME."/.vimrc"
    endif

    if s:extension == "vim" || s:file == s:VIMRC

        let s:cmt='"'

    elseif s:extension == "sh" || s:extension == "py" || s:extension == "pl" || s:extension == "yaml"

        let s:cmt="#"

    elseif s:extension == "java" || s:extension == "go" || s:extension == "cpp" || s:extension == "c" || s:extension == "h" || s:extension == "hpp"

        let s:cmt="//"

    else
        " default of the default.
        let s:cmt="#"

        "echo "can't comment out buffer with extension " . s:extension
        "return

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
    let s:file=expand('%:p')

    if has('win32') || has ('win64')
        let  s:VIMRC = $VIM."/.vimrc"
    else
        let  s:VIMRC = $HOME."/.vimrc"
    endif

    if s:extension == "vim" || s:file == s:VIMRC

        let s:cmt='"'
        let s:cmtlen=1

    elseif s:extension == "sh" || s:extension == "py" || s:extension == "pl" || s:extension == "yaml"

        let s:cmt="#"
        let s:cmtlen=1

    elseif s:extension == "go" || s:extension == "cpp" || s:extension == "c" || s:extension == "h" || s:extension == "hpp"

        let s:cmt="//"
        let s:cmtlen=2

    else

        let s:cmt="#"
        let s:cmtlen=1

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

function s:RunUseTags()

    let s:get_root="git rev-parse --show-toplevel 2>/dev/null"
    let s:top_dir = system(s:get_root)

    if s:top_dir == ""
        let s:top_dir = getcwd()
    endif

    let s:top_dir=s:Chomp(s:top_dir)
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


    let s:top_dir=s:Chomp(s:top_dir)
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
    let s:pattern = input("Find file name: ", '*')
    if s:pattern == ""
        return
    endif

    let s:tmpfile = tempname()
    let s:cmd = "find . -name \"" . s:pattern . "\" | tee " . s:tmpfile

    " --- run grep command ---
    let s:cmd_output = system(s:cmd)

    if s:cmd_output == ""
        echohl WarningMsg |
        \ echomsg "Error: Pattern " . s:pattern . " not found" |
        \ echohl None
        return
    endif

    " --- put output of grep command into message window ---
    let old_efm = &efm
    set efm=%f

   "open search results, but do not jump to the first message (unlike cfile)
   "execute "silent! cfile " . tmpfile
    execute "silent! cgetfile " . s:tmpfile

    let &efm = old_efm

    OpenQuickFix

    call delete(s:tmpfile)


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

      OpenQuickFix

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

  OpenQuickFix

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

    OpenQuickFix

    call delete(tmpfile)

endfunction


" copied from here: https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! s:Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let s:cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let s:output = systemlist(s:cmd)
		else
			let s:joined_lines = join(getline(a:start, a:end), '\n')
			let s:cleaned_lines = substitute(shellescape(s:joined_lines), "'\\\\''", "\\\\'", 'g')
			let s:output = systemlist(s:cmd . " <<< $" . s:cleaned_lines)
		endif
	else
		redir => s:output
		execute a:cmd
		redir END
		let  s:output = split(s:output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, s:output)

    let s:rename="file " . s:cmd
    execute s:rename
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call s:Redir(<q-args>, <range>, <line1>, <line2>)


command! -nargs=* GitGrep call s:RunGitGrep()

function! s:RunGitGrep()
    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
       return
    endif

    " --- No argument supplied. Get the identifier and file list from user ---
    let pattern = input("Grep for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let pattern = g:Grep_Shell_Quote_Char . pattern . g:Grep_Shell_Quote_Char


    let tmpfile = tempname()
    let grepcmd = 'git grep -n ' . pattern . " |  tee " . tmpfile

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

    OpenQuickFix

    call delete(tmpfile)

endfunction

command! -nargs=* GitLs call s:RunGitLs()

function! s:RunGitLs()

    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
       return
    endif

    let tmpfile = tempname()
    let grepcmd = "git ls-files  |  tee " . tmpfile

    " --- run grep command ---
    let cmd_output = system(grepcmd)

    if cmd_output == ""
        echohl WarningMsg |
        \ echomsg "Error: current directory must be a git repository" |
        \ echohl None
        return
    endif

    " --- put output of grep command into message window ---
    let old_efm = &efm
    set efm=%f

   "open search results, but do not jump to the first message (unlike cfile)
   "execute "silent! cfile " . tmpfile
    execute "silent! cgetfile " . tmpfile

    let &efm = old_efm

    OpenQuickFix

    call delete(tmpfile)

endfunction

"======================================================
" run git graph
"======================================================

command! -nargs=* Graph call s:RunGitGraph()

function! GitGraphGlobalShowCommit()
    let s:topline = line('.')
    while s:topline > 0

        let s:curline = getline(s:topline)
        let s:topline = s:topline - 1

        let s:tokens = split(s:curline)
        let s:token = ""
        let s:hash = ""

        for s:token in s:tokens
           if match(s:token,'^[0-9a-fA-F]*$') == 0
                let s:hash = s:token
                break
            endif
        endfor
 
        if s:hash == ''
            continue
        endif

        let s:firsthashchar=strpart(s:hash,0,1)
        if s:firsthashchar == "^"
            let s:hash = strpart(s:hash,1)
        endif

        let s:cmd = "git show " . s:hash . " 2>/dev/null"

        call system(s:cmd)
        if  v:shell_error == 0

            let s:output = systemlist(s:cmd)
            "let s:output = 'line: ' . s:topline . ' cmd: ' . s:cmd 


            belowright new
            let w:scratch = 1
            setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
            call setline(1, s:output)

            let s:rename="file " . s:cmd 
            setlocal nomodifiable


            break
        endif
    endwhile
endfunction

function! s:RunGitGraph()

    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
       return
    endif

    let s:file=expand('%:p')

    let s:idx = stridx(s:file, "git log --graph")
    if s:idx != -1

        call GitGraphGlobalShowCommit()
        
    else        
       let s:cmd='git log --graph --full-history --all --pretty=format:' . "'" . '%h \%an: (%ci) \%s' .  "'"

       call s:RunGitCommand(s:cmd, "", "GitGraphGlobalShowCommit", "Git\ Graph", 1) ", "%f")
    endif

endfunction

"======================================================
" run git diff
"======================================================
command! -nargs=* GitDiff call s:RunGitDiff(<f-args>)
command! -nargs=* GitDiffNoSpace call s:RunGitDiffNoSpace(<f-args>)


" has to be global function. strange.
function! GitDiffGlobalShowDiff()
    let s:line = getline(".")
    let s:tmpfile = tempname()

    "aboveleft new 
    tabnew

    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
       return
    endif
 
    call chdir(s:git_top_dir)

    let s:line = strpart(s:line, 0, strridx(s:line,":"))

    file "git show :" . s:line

    if s:GitDiffGlobalShowDiff_from_commit == ""
        execute "silent edit " . s:line

        let s:rename ="silent file [local]"
        execute s:rename

    else
        let s:show_cmd = "git show  " . s:GitDiffGlobalShowDiff_from_commit . ":" . s:line
        let s:cmd =  s:show_cmd . " >" . s:tmpfile
        call system(s:cmd)
        execute "silent edit " . s:tmpfile
        call delete(s:tmpfile)

        let s:rename ="silent file " .  s:GitDiffGlobalShowDiff_from_commit . ":" . s:line
        execute s:rename
        
        setlocal nomodifiable
    endif

    let s:top_hash = s:GitDiffGlobalShowDiff_to_commit
    if s:top_hash == ""
       let s:top_hash = s:Chomp( system("git rev-parse --short HEAD") )
    endif
 
    let s:show_cmd = "git show  " . s:GitDiffGlobalShowDiff_to_commit . ":" . s:line
    let s:cmd= s:show_cmd . " >" . s:tmpfile

"    if s:GitDiffGlobalShowDiffMode != ""
"        let old_diffopt = &diffopt
"        execute "normal! set diffopt=iwhite,iblank,iwhiteall"
"    endif

    call system(s:cmd)

    if s:GitDiffGlobalShowDiffMode != ""
        execute "set diffopt=iwhite,iblank,iwhiteall | silent vertical diffs " . s:tmpfile
    else 
        execute "set diffopt=internal,filler,closeoff | silent vertical diffs " . s:tmpfile
    endif

    call delete(s:tmpfile)

   
    let s:rename="silent file " . s:top_hash  . ":" . s:line
    execute s:rename
    
    setlocal nomodifiable

"    if s:GitDiffGlobalShowDiffMode != ""
"        let &diffopt = old_diffopt 
"    endif
"
    call chdir("-")

endfunction

function! s:RunGitDiffNoSpace(...)
    call s:RunGitDiffImpl("--ignore-all-space", a:000)
endfunction
 

function! s:RunGitDiff(...)
    call s:RunGitDiffImpl("", a:000)
endfunction


function! s:RunGitDiffImpl(mode, ...)
 
"    echo "mode: " . a:mode " f-args: " . type(a:1) . " : " . len(a:1) . " :: " . join(a:1,';')
"    return

    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
         return
    endif

    setlocal modifiable
    let s:GitDiffGlobalShowDiff_from_commit = ""
    let s:GitDiffGlobalShowDiff_to_commit = ""
    let s:to_commit = ""
    if len(a:1) == 2
        let s:GitDiffGlobalShowDiff_from_commit = a:1[0]
        let s:GitDiffGlobalShowDiff_to_commit = a:1[1]
    else
      if len(a:1) == 1
        let s:GitDiffGlobalShowDiff_to_commit = a:1[0]
      endif
    endif

    let s:GitDiffGlobalShowDiffMode = a:mode

   "let s:cmd=  "git diff --name-only "  . s:GitDiffGlobalShowDiff_from_commit . " " . s:GitDiffGlobalShowDiff_to_commit
   "let s:cmd=  "git diff --name-status " . s:GitDiffGlobalShowDiff_from_commit . " " . s:GitDiffGlobalShowDiff_to_commit . " | awk '{ print $2 \": \" $1 }'" 
    let s:cmd=  "git diff --name-status " . a:mode . " " . s:GitDiffGlobalShowDiff_from_commit . " " . s:GitDiffGlobalShowDiff_to_commit 
    
    let s:res = systemlist(s:cmd)
    if len(s:res) == 0
        if s:GitDiffGlobalShowDiff_from_commit == "" && s:GitDiffGlobalShowDiff_to_commit == ""
            echo "No changes between working tree and index"
        else
            echo "No changes between the two working trees"
        endif
        return
    endif

    let s:status_names = { 'A' : 'Added', 'C' : 'Copied', 'D' : 'Deleted', 'M' : 'Modified', 'R' : 'Renamed', 'T' : 'Changed', 'U' : 'Unmerged', 'X' : 'Unknown', 'B' : '[pairing Broken]', '*' : '[all or one]' }
    let s:report = ""
    for s:line in s:res
        let s:tokens = split(s:line,"\t")
        let s:status = ""
        
        if a:mode != ""
            let s:diff_check = system("git diff -w --ignore-blank-lines " . s:tokens[1])
            if s:diff_check == ""
                continue
            endif
        endif

        for s:item in split(s:tokens[0], '\zs')
            let s:status = s:status . s:status_names[ s:item ] . ' '
        endfor
        let s:report = s:report . s:tokens[1] . ": " . s:status . "  " . s:tokens[0] . "\n"
    endfor

    let s:title = "git\ diff\ " . a:mode . " " . s:GitDiffGlobalShowDiff_from_commit . "\ " . s:GitDiffGlobalShowDiff_to_commit

    call s:RunGitCommand("", s:report, "GitDiffGlobalShowDiff", s:title, 1) ", "%f:%m")

endfunction

command! -nargs=* GitStatus call s:RunGitStatus()

function! GitStatusGlobalShowStatus()
    
   let s:git_top_dir = s:GitCheckGitDir()
   if s:git_top_dir == ""
       return
   endif
   call chdir(s:git_top_dir)

   let s:topline = getline('.')
   let s:tokens = split(s:topline, " ")

   if len(s:tokens) != 0
     let s:fname = trim(s:Chomp(s:tokens[-1]))
     if filereadable(s:fname) || isdirectory(s:fname)

         " check if the file is tracked.
         let s:cmd = "git ls-files --error-unmatch " . s:fname
         call system(s:cmd)

         if v:shell_error != 0 
            " can't get the file status, this is an untracked file
            let s:cmd = "silent! belowright new " . s:fname
            exec s:cmd
         else 

            let s:cmd = "silent edit ". s:fname 

            let s:top_hash = trim( s:Chomp( system("git rev-parse --short HEAD") ) )
            let s:show_cmd = "git show  " . s:top_hash . ":" . s:fname
            let s:tmpfile = tempname()
            let s:cmd_git_show = s:show_cmd . " >" . s:tmpfile

            tabnew

            execute s:cmd
            let s:rename ="silent file [local]"
            execute s:rename
            setlocal nomodifiable


            call system(s:cmd_git_show)
            execute "silent vertical diffs " . s:tmpfile
            call delete(s:tmpfile)
            let s:rename="silent file " . s:top_hash  . ":" . s:fname
            execute s:rename
            setlocal nomodifiable
 
        endif
     endif
   endif

   call chdir("-")

endfunction

function! s:RunGitStatusImp(replace)

   let s:git_top_dir = s:GitCheckGitDir()
   if s:git_top_dir == ""
       return
   endif

   call chdir(s:git_top_dir)
   
   let save_a_mark = getpos(".")
   call s:RunGitCommand("git status", "", "GitStatusGlobalShowStatus", "git\\ status", a:replace) ", "%f")
   call setpos(".", save_a_mark)
 
   call chdir("-")
endfunction

function! s:RunGitStatus()
    call s:RunGitStatusImp(1)
endfunction

command! -nargs=* Stage call s:RunGitStage()
command! -nargs=* StageAll call s:RunGitStageAll()
command! -nargs=* Unstage call s:RunGitUnStage()
command! -nargs=* UnstageAll call s:RunGitUnStageAll()

function! s:RunGitStageImp(cmdArg,addCurrent)
    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
         return
    endif
    call chdir(s:git_top_dir)
    let s:file=bufname()
    let s:cmdcheck=s:file[0:10]

    if s:cmdcheck == "git status"

        if a:addCurrent != 0
            let s:topline = getline('.')
            let s:tokens = split(s:topline, " ")
            let s:fname = trim(s:Chomp(s:tokens[-1]))
            if filereadable(s:fname) || isdirectory(s:fname)
                let s:cmdgs = a:cmdArg . ' ' .s:fname
            else
                echo "Current line doe not mention a file"
                call chdir("-")
                return
            endif
        else
            let s:cmdgs = a:cmdArg
        endif

        call system(s:cmdgs)
        if  v:shell_error == 0
            setlocal modifiable

            " refresh the current window.
            call s:RunGitStatusImp(0)

            setlocal nomodifiable

            let s:msg = "command: " . s:cmdgs . " succeeded"
            echo s:msg
        else
            let s:msg = "command: " . s:cmdgs . " failed"
            echo s:msg
        endif

    else
        echo "You must be in buffer creaed by GitStatus command"
    endif
    call chdir("-")
endfunction

function! s:RunGitStage()
    call s:RunGitStageImp('git add', 1)
endfunction

function! s:RunGitUnStage()
    call s:RunGitStageImp('git restore --staged', 1)
endfunction

function! s:RunGitStageAll()
    call s:RunGitStageImp('git add -u', 0)
endfunction

function! s:RunGitUnStageAll()
    call s:RunGitStageImp('git reset', 0)
endfunction


"======================================================
" run git log
"======================================================

command! -nargs=* GitLog call s:RunGitLog()

function! GitLogGlobalShowLog()

    let s:topline = line('.')

    while s:topline > 0

        let s:curline = getline(s:topline)
        let s:topline = s:topline - 1

        let s:tok = split(s:curline)
        if len(s:tok) != 0 && s:tok[0] == "commit"
                let s:cmd = "git show " . s:tok[1]

                let  s:output = systemlist(s:cmd)

                belowright new
                let w:scratch = 1
                setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
                call setline(1, s:output)

                let s:rename="file " . s:cmd

                setlocal nomodifiable
                return
        endif

    endwhile
endfunction


function! s:RunGitCommand(command, msg, actionFunction, title, newBuffer)

        if winnr('$') > 1
            for win in range(1, winnr('$'))
                if getwinvar(win, 'gitcmdwnd')
                    execute  win . 'windo close'
                    "execute  win . "close!"
                endif
            endfor
        endif

        let s:git_top_dir = s:GitCheckGitDir()
        if s:git_top_dir == ""
          return
        endif

        let s:tmpfile = tempname()

        if a:msg == ""
            let s:cmd =  a:command . " >" . s:tmpfile
            call system(s:cmd)
        else 
            call writefile( split(a:msg,"\n"), s:tmpfile, "s")
        endif

        if a:newBuffer != 0
            new
        endif

       "let old_efm = &efm
       "set efm=errfmt
       "execute "silent! cgetfile " . s:tmpfile
        execute "silent 1,$d|0r " . s:tmpfile
       "let &efm = old_efm

        call delete(s:tmpfile)

        let s:rename ="silent file " . a:title
        execute s:rename
       
        "setlocal buftype=nofile nobuflisted noswapfile
        setlocal buftype=nofile noswapfile

        let w:gitcmdwnd = 1

        let s:cmd = "silent noremap <buffer> <silent> <CR>        :call " . a:actionFunction . "()<CR>"
        exec s:cmd
        set nomodified
        setlocal nomodifiable
endfunction   

function! s:RunGitLog()
        call s:RunGitCommand("git log --decorate --name-status --find-renames", "", "GitLogGlobalShowLog", "git\\ log", 1) ", "%f")
endfunction

command! -nargs=* BranchRemote call s:RunBranchRemote()

function! GitBranchGlobalChooseBranch()

        let s:title=bufname()  "expand('%:p')

        let s:tokens = split(s:title, " ")
    
        let s:curline = getline('.')
        let s:curline = s:Chomp( s:curline )

        if s:tokens[0] == "remote"
            let s:toks = split(s:curline, "/")
            let s:localbr = s:toks[-1]
            call system( "git rev-parse " . s:localbr)

            if  v:shell_error != 0
                let s:cmd = "git checkout " . s:curline . " -b " . s:localbr . " 2>&1"
            else 
                let s:cmd = "git checkout " . s:localbr . " 2>&1"
            endif

            let s:out = system(s:cmd)

        else 
            let s:cmd = "git checkout " . s:curline . " 2>&1"
            "echo  "cmd: " . s:cmd
            let s:out = system(s:cmd)

        endif

        if v:shell_error != 0 
            let s:lines = split(s:out, '\n')
            echo "Error: " . s:lines[0]
        else
            echo " "
            " force update of status line
            execute "let &stl=&stl"
        endif

endfunction

function! s:RunBranchRemote() 
        call s:RunGitCommand("git branch --remote", "", "GitBranchGlobalChooseBranch", "remote\\ branches", 1) ", "%f")
endfunction

command! -nargs=* BranchLocal call s:RunBranchLocal()

function! s:RunBranchLocal()
        call s:RunGitCommand("git branch | cut -c 2-", "", "GitBranchGlobalChooseBranch", "local\\ branches", 1) ", "%f")
endfunction



command! -nargs=* Blame call s:RunGitBlame()


function! GitBlameGlobalShowCommit()

            let s:curline = getline('.')

            if stridx(s:curline, "Not Committed Yet") == -1

                let s:eofhash = stridx(s:curline,' ')
                let s:hash = strpart(s:curline,0,s:eofhash)

                let s:firsthashchar=strpart(s:hash,0,1)
                if s:firsthashchar == "^"
                    let s:hash = strpart(s:hash,1)
                endif    

                let s:cmd = "git show " . s:hash

                let  s:output = systemlist(s:cmd)

                belowright new
                let w:scratch = 1
                setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
                call setline(1, s:output)

                let s:rename="file " . s:cmd
                setlocal nomodifiable
            else
                call s:BeepNow()
            endif

        endfunction

function! s:RunGitBlame()
    let s:git_top_dir = s:GitCheckGitDir()
    if s:git_top_dir == ""
          return
    endif

    let s:file=expand('%:p')
    let s:lineNum=line('.')

    if s:file != "" 


        let s:cmdcheck=s:file[0:8]
        if s:cmdcheck == "git blame"

            call GitBlameGlobalShowCommit()

        else     
                    
             let s:cmd="git blame " . expand('%:p') 
            
             call s:RunGitCommand(s:cmd, "", "GitBlameGlobalShowCommit", s:cmd, 1) ", "%f")
             let s:linecmd="normal ". s:lineNum . "gg"
             execute s:linecmd

             let s:curline = getline('.')
             let s:pos = stridx(s:curline,')')
             let s:pos = s:pos + 3
             call cursor(s:lineNum, s:pos)
        endif
    else
        echo "Error: current buffer must be a file"
    endif        
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
    let s:fname = expand("%")
    echo s:fname

	if s:extension == "go" || s:fname == "Makefile" || s:fname =='makefile' || s:extension == 'mk'
        " in go and makefiles they like tabs. strange but true.
		set noexpandtab
	else
		set expandtab
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

" show syntax, if possible.
syntax on
