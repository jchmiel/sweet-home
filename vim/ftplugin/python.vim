iab Zc class :<CR>def __init__(self):<CR>pass<UP><UP><Left>
iab Zf for in :<CR><Up><Right><Right>
iab Zfi for i in xrange():<Left><Left>
iab Zfu def ():<Left><Left><Left>
iab Zi if :<Left>
iab Zm def (self):<CR><Up><Right><Right>
iab Zw while :<Left>
iab Zmain def main():<CR>pass<CR><CR>if __name__ == '__main__':<CR>main()<CR><Up><Up><Up><Up><Esc><Right>
iab Zt # TODO(jchmiel): 
iab Zte try:<CR>pass<CR>except


setlocal softtabstop=2
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function! GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"
map <F8> :Lint<CR>
