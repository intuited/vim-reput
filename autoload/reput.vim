" reput.vim
" Author: Ted Tibbetts
" License: Licensed under the same terms as Vim itself.
" Provide convenient refreshing of variable dumps and other expressions.

" Given an argument, stores it in b:RePut_expr
" Otherwise it will try to read b:RePut_expr
" Parameters:
"   a:1: (optional) [String]
"     The argument is evaluated each time this function is called.
"     If its evaluated value is a List or Dictionary, the current buffer is replaced with a dump of its contents.
"       This dump will use PrettyPrint() if available.
"     Otherwise the buffer is replaced with the value itself.
" Exceptions:
"   If no argument is provided and no pre-existing expression is stored for this buffer,
"     throws a stringified Dictionary with the error message stored in the 'error' key.
"   If there is an error when evaluating the expression,
"     throws a stringified Dictionary with
"       error: [String] an error message explaining the situation
"       exception: [String] the original exception
"       throwpoint: [String] the throwpoint of the original error
" Return:
"   Returns the string which was put into the buffer.
funct! reput#RePut(...)
  " Parse parameters
    if a:0
      let expr = a:1
    elseif exists('b:RePut_expr')
      let expr = b:RePut_expr
    else
      throw string({ 'error': 'reput#RePut must be called with an expression before it can be called without one, for each buffer it is used in.' })
    endif

  " Attempt to evaluate the expression
    try
      let value = eval(expr)
    catch
      throw string({ 'error': 'error occurred during evaluation of reput#RePut expression.', 'exception': v:exception, 'throwpoint': v:throwpoint })
    endtry

  " If the expression evaluated without errors, save it as the new buffer expression
    if a:0
      let b:RePut_expr = a:1
    endif

  " Save position and clear the buffer
    let pos = getpos('.')
    normal ggdVG

  " Generate the dump and put it
    if type(value) == type({}) || type(value) == type([])
      if exists('*PrettyPrint')
        let dump = PrettyPrint(value)
      else
        let dump = string(value)
      endif
    else
      let dump = value
    endif
    put =dump

  " Restore position
    call setpos('.', pos)

  return dump
endfunct

" Parse the bang and call reput#RePut with the appropriate silence level.
funct! reput#Cmd_RePut(...)
  if a:1 == '!'
    silent! return call(function('reput#RePut'), a:000[1:])
  else
    return call(function('reput#RePut'), a:000[1:])
  endif
endfunct
