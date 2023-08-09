
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

" XAML is basically XML
au BufNewFile,BufRead *.xaml setf xml

" PICO-8 files are mostly lua
au BufNewFile,BufRead *.p8 setf lua
