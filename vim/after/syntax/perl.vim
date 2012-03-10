hi! def link perlSubPrototypeError perlSubPrototype

let g:perl_compiler_force_warnings = 0

let perl_moose_stuff               = 1
let perl_no_scope_in_variables     = 1
let perl_no_sync_on_sub            = 1
let perl_no_sync_on_global_var     = 1
let perl_extended_vars             = 1
let perl_include_pod               = 1
let perl_string_as_statement       = 1
let perl_sync_dist                 = 1000
let perl_want_scope_in_variables   = 1
let perl_pod_formatting            = 1
let perl_pod_spellcheck_headings   = 1
"let perl_fold                      = 1
"let perl_fold_blocks               = 1
"let perl_nofold_packages           = 1
let perlhelp_prog                  = '/usr/bin/perldoc'

noremap K :!perldoc <cword> <bar><bar> perldoc -f <cword><cr>
set makeprg=perl\ -c\ %\ $*
set errorformat=%f:%l:%m
set keywordprg=perldoc\ -f
set formatprg=perl\ -MText::Autoformat\ -e'autoformat'
set formatoptions=qro
set tabstop=4
set expandtab
set tw=0

if !has('conceal')
	    finish
endif

syntax match perlLambda +\(=>\?\s*\)\@<=sub\(\W\)\@=+ conceal cchar=λ

syntax clear perlOperator
syntax keyword perlOperator is

syntax match perlNiceOperator "\<in\>"      conceal cchar=∈
syntax match perlNiceOperator "\<or\>"      conceal cchar=∨
syntax match perlNiceOperator "\<and\>"     conceal cchar=∧
syntax match perlNiceOperator "\<not "      conceal cchar=¬
syntax match perlNiceOperator "\<foreach\>" conceal cchar=∀
syntax match perlNiceOperator "\<for\>"     conceal cchar=∀
syntax match perlNiceOperator "\<exists\>"  conceal cchar=∃
"syntax match perlNiceOperator "\<warn\>"    conceal cchar=⚠
"syntax match perlNiceOperator "\<die\>"     conceal cchar=☠
syntax match perlNiceOperator "<="          conceal cchar=≤
syntax match perlNiceOperator ">="          conceal cchar=≥
syntax match perlNiceOperator "=="          conceal cchar=≡
syntax match perlNiceOperator "!="          conceal cchar=≠
syntax match perlNiceOperator "=\~"         conceal cchar=≅
syntax match perlNiceOperator "!\~"         conceal cchar=≆
syntax match perlNiceOperator "\->"         conceal cchar=▸
syntax match perlNiceOperator "=>"          conceal cchar=⇒

hi  link perlNiceOperator  Operator
hi  link perlNiceStatement Statement
hi! link Conceal           Operator

setl conceallevel=2
setl concealcursor=n
