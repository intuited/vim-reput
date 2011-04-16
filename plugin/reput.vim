" reput.vim
" Author: Ted Tibbetts
" License: Licensed under the same terms as Vim itself.
" Provide convenient refreshing of variable dumps and other expressions.

" When the |:RePut| command is used in a given buffer with an argument,
" that argument is saved.
" The argument is evaluated as an expression,
" and the buffer's contents are replaced with the argument's value.
" If |:RePut| is invoked without an argument, the previous argument is used.
" Passes its arguments on to the RePut function.
" Bang: With !, calls RePut silently, suppressing error messages
"   including the warning issued if no previous RePut has been called on this buffer.
command! -nargs=? -bang RePut call reput#Cmd_RePut(<q-bang>, <f-args>)

" :RePutShell
" Executes its arguments as a system command,
" storing the system call expression to be re-run
" when :RePut is run again in the current buffer.
" The current buffer's contents
" are replaced with the output from the system command.
command! -nargs=1 -bang RePutShell call reput#Cmd_RePut(<q-bang>,
      \ printf('system(%s)', string(<q-args>)))
