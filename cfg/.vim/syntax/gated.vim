" Vim syntax file
" Language:	gated.log
" Maintainer:	Daniel Gryniewicz <dang@ghs.com>
" Last change:	2011-02-24

if version < 600
    syntax clear
elseif exists ("b:current_syntax")
    finish
endif

" case off
" syn case ignore
"
" Prefixes
syn match addressV4	#[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}#
syn match addressV6	#\([0-9a-fA-F]\{1,4}:\)\{7}[0-9a-fA-F]\{1,4}\|\([0-9a-fA-F]\{1,4}:\)\{1,7}:\([0-9a-fA-F]\{1,4}:\)\{0,7}\([0-9a-fA-F]\{1,4}\)\{0,1}\|::\([0-9a-fA-F]\{1,4}:\)\{0,6}[0-9a-fA-F]\{1,4}#
syn match prefixV4	#\([1-9][0-9]\{0,2}\(\.[0-9]\{1,3}\)\{0,3}/[0-9]\{1,2}\>\(\.[0-9]\{1,3}\)\{0,3}\)\|\(0\(\.0\)\{0,3}/0\>\)#
syn match prefixV6	#\(\([0-9a-fA-F]\{1,4}:\)\{7}[0-9a-fA-F]\{1,4}\|\([0-9a-fA-F]\{1,4}:\)\{1,7}:\([0-9a-fA-F]\{1,4}:\)\{0,7}\([0-9a-fA-F]\{1,4}\)\{0,1}\|::\([0-9a-fA-F]\{1,4}:\)\{0,6}[0-9a-fA-F]\{1,4}\)/[0-9]\{1,3}\>#

" OSPF log messages
syn keyword logPktIn	RECV contained
syn keyword logPktOut	SEND contained
syn keyword logMsgType	STATE SPF DB QREF FLOOD CREATE ADD DR ELECTION contained

syn match logO3NEvts	"EvtStart\|EvtHelloRecv\|Evt2Way\|EvtNegDone\|EvtExchDone\|EvtLoadDone\|EvtAdjOK?\|EvtBadLSReq\|EvtSeqNumMis\|Evt1Way\|EvtKillNbr\|EvtInacTimer\|EvtLLDown"
syn match logO3NStates	"\<Down\>\|\<Attempt\>\|\<Init\>\|\<2 Way\>\|\<Exch Start\>\|\<Exchange\>\|\<Loading\>\|\<Full\>\|\<Restarting\>"
syn match logO3IStates	"\<Down\>\|\<Loopback\>\|\<Waiting\>\|\<P2P\>\|\<DR\>\|\<BDR\>\|\<Backup DR\>\|\<DR Other\>"
syn match logDate	"^[A-Z][a-z][a-z] [0-9]\{2} [0-9]\{2}:[0-9]\{2}:[0-9]\{2}"
syn match logPktType	"Hello\|Database Description\|LS Request\|LS Update"
syn match logSequence	"Sequence [0-9]\+"

syn region logFlags	matchgroup=logFlagsStart start="Options <\|Flags <" end=">"
syn region logProto	start=" OSPF\| OSPF3\| RIP\| RIPng\| BGP\| KRT" end=":" contains=logPktIn,logPktOut,logMsgType oneline

" Timers
syn region logTimerName	matchgroup=LogTimer start="calling" start="returned from" start="timer" start="created timer" start="resetting" start="deleting" start="set on" end="," contained
syn match logTimerSkip	"timer now inactive"
syn match logTimerLate	"late by [0-9]\+\.[0-9]\+" contained
syn match logTimerSet	"to fire in [0-9]\+\.[0-9]\+" contained
syn match logTimerBad	"late by [1-9]\.[0-9]\+\|late by [1-9][0-9]\+\.[0-9]\+" contained
syn keyword logTimerNoMatch	task_timer_hiprio_dispatch
syn region logTimer	matchgroup=logTimerStart start="\(SIGIO\)\@<!ITIMER:" start="task_timer[a-z_]\+:" end="$" contains=addressV4,addressV6,logTimerLate,logTimerSet,logTimerBad,logTimerName keepend

" OSPF LSAs
syn keyword lsType	RTR NTW AIP ABR AEX NSSA OPQ9 OPQ10 OPQ11 IAP IAR GRP NSA NAP LNK GRC contained
syn keyword lsTags	len seq cksum age
syn match lsLSID	"[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}" contained
syn match lsAdvRt	"\[[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}]" contained
syn match lsLSAHdr		"\<LS\> [A-Z]\+[0-9]*:\_.\{-}\]" contains=logDate,lsType,lsTags,lsLSID,lsAdvRt
syn match lsVTXHdr		"\<VTX\> [A-Z]\+[0-9]*:\_.\{-}\]" contains=logDate,lsType,lsTags,lsLSID,lsAdvRt

" Events
syn keyword evtEmit	Emitting contained
syn keyword evtDeliver	Delivering contained
syn match evtRegister	"Client registered" contained
syn keyword evtKey	class id key prio evtdata contained
syn region evtTuple	start="<" end=">" contains=evtKey contained
syn keyword evtFW	EVTFW contained
syn region logEVT	start="EVTFW:" end="$" contains=evtFW,evtEmit,evtDeliver,evtRegister,evtTuple oneline

" String
syn match  logString	"\".*\"" contained
syn match  logString    "'.*'"   contained

" Define the default hightlighting.
    hi link prefixV4		Comment
    hi link prefixV6		Comment
    hi link addressV4		Comment
    hi link addressV6		Comment
    hi link logProto		Statement
    hi link logPktIn		SpecialKey
    hi link logPktOut		Title
    hi link logMsgType		Type
    hi link logString		String
    hi link logDate		Special
    hi link logPktType		PreProc
    hi link logO3NEvts		PreProc
    hi link logO3NStates	Identifier
    hi link logO3IStates	Identifier
    hi link logFlagsStart	PreProc
    hi link logFlags		Constant
    hi link logSequence		PreProc
    hi link logTimer		PreProc
    hi link logTimerStart	Constant
    hi link logTimerLate	Underlined
    hi link logTimerSet		Underlined
    hi link logTimerBad		Error
    hi link logTimerName	Comment
    hi link lsLSAHdr		Identifier
    hi link lsVTXHdr		Identifier
    hi link lsType		Statement
    hi link lsTags		PreProc
    hi link lsLSID		Question
    hi link lsAdvRt		Ignore
    hi link logEVT		Normal
    hi link evtFW		Statement
    hi link evtEmit		SpecialKey
    hi link evtDeliver		Title
    hi link evtRegister		Type
    hi link evtTuple		PreProc
    hi link evtKey		Comment

let b:current_syntax = "gated"
" vim:ts=8
