""
"" This file is managed globally by update-dotfiles and may be overwritten
"" Local configuration should be stored in .vimrc.local
"" See https://github.com/samhocevar/dotfiles for more information
""
"" Copyright © 1998–2025 Sam Hocevar <sam@hocevar.net>
""
"" This file is free software. It comes without any warranty, to
"" the extent permitted by applicable law. You can redistribute it
"" and/or modify it under the terms of the Do What The Fuck You Want
"" to Public License, Version 2, as published by the WTFPL Task Force.
"" See http://www.wtfpl.net/ for more details.
""

""
"" Look and feel
""

syntax on
set background=dark
"colorscheme slate

" Smart backspace
set backspace=indent,eol,start

" Do not automatically add a newline at EOF (important for binary files)
set nofixendofline

""
"" Syntax stuff
""

" XAML is basically XML, and so are MSBuild .props and .targets files
au BufNewFile,BufRead *.xaml setf xml
au BufNewFile,BufRead *.props,*.targets setf xml

" PICO-8 files are mostly lua
au BufNewFile,BufRead *.p8 setf lua

"""
""" Import local configuration
"""

try
  source ~/.vimrc.local
catch
endtry
