" syntax coloring for make output
syn match cMLogMissing  "[\./a-zA-Z0-9_]\+\.[a-zA-Z_]\+: No such .*$"
syn match cMLogMissing  "undefined reference to .*$"
syn match cMLogSource   "[\./a-zA-Z0-9_]\+\.[hci][pxn]\?[lp]\?\(:[0-9]\+\)\+:"
syn match cMLogCurDir   "Entering directory .*$" 
syn match cMLogFunction "In function .*$" 

syn match cMLogWarn "\<[wW]arn[iu]ng:.*$"
syn match cMLogErr  "error:.*$"
syn match cMLogErr  "No such .*$"

"syn match cMLogMissing  ".*$" contains=cMLogErr,cMLogSource


hi cMLogWarn    ctermfg=yellow
hi cMLogErr     ctermfg=darkred
hi cMLogSource  ctermfg=Blue
hi cMLogCurDir  ctermfg=Blue
hi cMLogMissing ctermfg=Red
hi cMLogFunction ctermfg=green

