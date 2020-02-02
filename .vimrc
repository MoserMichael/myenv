
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

"specify tag file
"set tags=~/orion/tags

"turn off vi startup screen
set shm=I

"next line will causes colors to look like good ol' norton editor
"blue background is making people friendlier and better. Serious.
"colorscheme blue
"colorscheme evening
colorscheme morning

"show current file name in title bar
set title

"preserve indentation level if you press enter - start of line
"is now indented just as the previous line. 
"amazing that this is _not_ the default behavior.
set autoindent

"set spaces to local coding convention
set sts=4
set sw=4
set expandtab

"turn off bells on errors (like moving the cursor out of range)
set vb t_vb=

"always show status line
set laststatus=2

"show cursor pos.
:set ru

"======================================================
"search customization
"======================================================

"Case sensitive search    
":set noignorecase

"Case insensitive search
:set ignorecase 

:set hlsearch

"======================================================
"key assignments for grep (find in files) script
"======================================================

:nnoremap <F3> :DoGrep<Return>
  
:vnoremap <F3> <Esc>:DoGrep<Return>

:inoremap <F3> <Esc>:DoGrep<Return>

"======================================================
"key assignments for find file by name script
"======================================================

:nnoremap <F10> :FindFile<Return>
  
:vnoremap <F10> <Esc>:FindFile<Return>

:inoremap <F10> <Esc>:FindFile<Return>

"======================================================
"key assignments for Find 
"======================================================
:inoremap <C-F> <Esc>:FindCurrentWord<Return>

:nnoremap <C-F> :FindCurrentWord<Return> 

:vnoremap <C-F> <Esc>:FindCurrentWord<Return> 

"======================================================
"key assignments for Build/make script
"======================================================
:nnoremap <F5> :Build<Return>

:vnoremap <F5> <Esc>:Build<Return>

:inoremap <F5> <Esc>:Build<Return>

"======================================================
"key assignments for Build/make script
"======================================================
:nnoremap <C-F5> :StopBuild<Return>

:vnoremap <C-F5> <Esc>:StopBuild<Return>

:inoremap <C-F5> <Esc>:StopBuild<Return>

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
"key assignments
"======================================================

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
"Problem: Default key mapping on RXVT terminal. XTERM is ok.
"

:nnoremap <S-Left> v<Left>
:inoremap <S-Left> <Esc>v<Left>
:vnoremap <S-Left> <Left>
:nnoremap <S-Right> v<Right>
:vnoremap <S-Right> <Right>
:inoremap <S-Right> <Esc>v<Right>
:vnoremap <S-Right> <Right>
:nnoremap <S-Up> v<Up>
:vnoremap <S-Up> <Up>
:inoremap <S-Up> <Esc>v<Up>
:nnoremap <S-Down> v<Down>
:inoremap <S-Down> <Esc>v<Down>
:vnoremap <S-Down> <Down>

"Ctlr+A - quit (in insert mode only) 
"Can't override Ctrl+Q and all other combinations are already set
:inoremap <C-A> <Esc>:q<Enter>

"Ctlr+A - quit (in normal mode only)
"Can't override Ctrl+Q and all other combinations are already set
:nnoremap <C-A> :q<Enter>

"Ctlr+A - quit (in visual mode only)
"Can't override Ctrl+Q and all other combinations are already set
:vnoremap <C-A> <Esc>:q<Enter>

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

"Ctrl+R - redo (in all modes)
:inoremap <C-R> <Esc>:red<Return>i

"Ctrl+U - undo (in normal mode only)
:nnoremap <C-U> :u<Return>

"Ctrl+U - undo (in visual mode - return to normal mode and undo>
:inoremap <C-U> <Esc>:u<Return>i

"Ctrl+V - paste (in normal mode only)
:nnoremap <C-V> P 

"Ctrl+V - paste (in normal mode only)
:vnoremap <C-V> P  

"Ctrl+V - paste (in insert mode only)
:inoremap <C-V> <Esc>Pi

"Ctrl+C - copy (in visual mode only)
:vnoremap <C-C> y

"Ctrl+X - cut (in visual mode only)
:vnoremap <C-X> x

"F3 - show next search hit
":nnoremap <F3> /<Return>

"F3 - show next search hit (in visual mode)
":vnoremap <F3> <Esc>/<Return>

"F3 - show next search hit (in insert mode)
":inoremap <F3> <Esc>/<Return>

"Ctlr+G - goto line (insert mode)
":inoremap <C-G> <Esc>:
:inoremap <C-G> <Esc>:GotoLine<Return>

"Ctlr+G - goto line (command mode)
":nnoremap <C-G> :
:nnoremap <C-G> :GotoLine<Return>

"Ctlr+G - goto line (visual mode)
":vnoremap <C-G> <Esc>:
:vnoremap <C-G> <Esc>:GotoLine<Return>


"---
"

:inoremap <C-A> <Esc>:redraw!<Return>

:nnoremap <C-A> :redraw!<Return>

"Ctlr+G - goto line (visual mode)
":vnoremap <C-G> <Esc>:
:vnoremap <C-A> <Esc>:redraw!<Return>



"Tab - indent a block of text (one tab deep) 
:nnoremap <Tab> >>
:vnoremap <Tab> >

"F4 - show compiler errors (in normal mode)
:nnoremap <F4> :copen<Return>

"F4 - show compiler errors (in visual mode)
:vnoremap <F4> <Esc>:copen<Return>

"F4 - show compiler errors (in insert mode)
:inoremap <F4> <Esc>:copen<Return>


"F6 - goto previous compiler error (normal mode)
:nnoremap <F6> :cp<Return>

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

"F8 - split windows
:nnoremap <F8> :split<Return>

"F8 - split windows (in visual mode)
:vnoremap <F8> <Esc>:split<Return>

"F8 - split windows (in insert mode)
:inoremap <F8> <Esc>:split<Return>i

"Shift-Tab - unindent a block of text (one tab down)
"This one is commented out, Shift-Tab also covers Alt-Tab - then you can' switch
"windows any longer.
":inoremap <S-Tab> <C-O><LT><LT>
":nnoremap <S-Tab> <LT><LT>
":vnoremap <S-Tab> <LT>

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
    "	let sbuffers = sbuffers . bufnumber . " " . bname . "\n"
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
      execute "silent! cgetfile " . g:buildCommandOutput
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

    " temporary file name for build results.
    let tmpfile = tempname()
 

    " run build command --- 
    if filereadable("./make_override")
        let buildcmd = './make_override'
    else
        let buildcmd = "make " . $MAKE_OPT
    endif

    echo "Running: " . buildcmd . " (asynchronous) ... " 
 
    let buildcmd = buildcmd . " 2>&1"

    let g:buildCommandOutput = tempname()
    let g:build_job = job_start(["bash", "-c", buildcmd], {'close_cb': 'BackgroundCommandClose', 'out_io': 'file', 'out_name': g:buildCommandOutput})

    botright copen

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
        let buildcmd = "make " . $MAKE_OPT . " > " . tmpfile . " 2>&12>&1"
    endif

    let fname = expand("%")
    let fnameidx = strridx(fname,".")
    if fnameidx != -1
      let ext = fname[ fnameidx : ]
     if ext == ".pl" || ext == ".perl"
    	let buildcmd = "perl -c " . fname . ' 2>&1 | perl -ne ''$_ =~ s#.*line (\d+).*#' . fname . ':$1: $&#g; print $_;'' | tee ~/uuu >' . tmpfile 
      endif
    endif

    " --- run build command --- 
    echo "Running make ... " 
    
    let cmd_output = system(buildcmd)
    
   if getfsize(tmpfile) == 0
    
     cclose
     execute "silent! cfile " . tmpfile
     echo "Build succeded" 
   
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
  let curw = expand("<cword>")
  if curw != ""
    "let g:hlsearch="on"
    let [lnum, ncol] = searchpos( expand("<cword>") )
    if lnum != 0 && ncol != 9 
        call col(ncol)
    endif

    "execute "/" . curw
  endif 
endfunction



"======================================================
" find tag file up the current directory and add it to 
" tag search path.
"======================================================
" 

command! -nargs=* GotoTag call s:RunGotoTagFile()

function! s:RunGotoTagFile()
  let tagdir = system("~/bin/tagsdir.pl")
  if tagdir != ""
   let cmd = "set tags=" . tagdir
   echom cmd
   execute cmd
  endif 
endfunction


"call s:RunGotoTagFile()

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

    call delete(tmpfile)

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

"############################################
" omnicppcomplete 
"############################################
set nocp
filetype plugin on
