" Vim syntax file
" Language:	Gen_Config
" Maintainer:	Daniel Gryniewicz <dang@nexthop.com>
" Last change:	2002-02-21

if version < 600
    syntax clear
elseif exists ("b:current_syntax")
    finish
endif

" case off
syn case ignore
syn keyword cfgStatement		generate ip_gateway setvar test set_routing_domain
syn keyword cfgStatement		route_set import_all export_all internal external
syn keyword cfgStatement		interface network_gateway ipv6_gateway
syn keyword cfgTemplateStatement	main_template intf_template group_template
syn keyword cfgTemplateStatement	peer_template area_template
syn keyword cfgBlock			test_set sequence end routing_domain machine
syn keyword cfgBlock			machine cisco protocol area
syn keyword cfgPeer			bgp_peers isis_peers rip_peers ospf_peers
syn keyword cfgPeer			non_peer_routes bgp_peers_ipv6 isis_peers_ipv6
syn keyword cfgPeer			ospf3_peers
syn keyword cfgProto			ospf bgp isis rip isis_ipv6 bgp_ipv6 ripng ospf3
syn match unfReplace			":.\{-}:"
syn match  cfgVarStart		 "$[A-Za-z0-9]"
"syn match  cfgVarPlain		 "$[adefhilmopstwx]"
"syn match  cfgVarPlain		 "$[\\\"\[\]'&`+*.,;=%~!?@$<>(0-9-]"
syn region cfgVar			start="[$]" end="="me=e-1
syn region cfgBuiltin			start="[&]" end="("
syn match cfgBuiltinEnd			")"
syn match cfgMachine			"rack[0-9]*-box[a-o]"
syn match cfgMachine			"rack[0-9]*-box[a-o]N[0-9]"
syn match cfgMachine			"rack[0-9]*-box[a-o]P[0-9]"
syn match cfgMachine			"cf[0-9]*-box[a-o]"
syn match cfgMachine			"cf[0-9]*-box[a-o]N[0-9]"
syn match cfgMachine			"cf[0-9]*-box[a-o]P[0-9]"
syn match cfgMachine			"rack[0-9]*-cisco[0-9]"
syn match cfgMachine			"rack[0-9]*-cisco[0-9]N[0-9]"
syn match cfgMachine			"rack[0-9]*-cisco[0-9]P[0-9]"
syn match cfgMachine			"ipgw-[0-9]*-N[0-9]_[0-9]*"
syn match cfgMachine			"ipgw-cf[0-9]*-N[0-9]_[0-9]*"
syn match cfgMachine			"ipgw-anvil-N[1a-c]_[0-9]*"
syn match cfgMachine			"ipgw-default"
syn match cfgMachine			"alias-[0-9]*-N[0-9]_[0-9]*"
syn match cfgMachine			"alias-cf[0-9]*-N[0-9]_[0-9]*"
syn match cfgMachine			"alias-[0-9]*-P[0-9]_[0-9]*"
syn match cfgMachine			"alias-[0-9]*-[0-9]-[0-9]"
syn match cfgMachine			"alias-qar-N[1a-c]_[0-9]*"

"Parameters
"syn match   cfgParams    ".*="me=e-1 contains=cfgComment,cfgVar,cfgStatement,cfgBlock,cfgPeer,cfgMachine,cfgBuiltin,cfgBuiltinEnd,cfgProto
"syn match   cfgValues    "=.*"hs=s+1 contains=cfgComment,cfgString,cfgMachine,cfgBuiltin,cfgBuiltinEnd,cfgProto

" String
syn match  cfgString	"\".*\"" contained
syn match  cfgString    "'.*'"   contained

" Comments (Everything before '#' or '//' or ';')
syn match  cfgComment	"#.*"
syn match  cfgComment	"\/\/.*"

" Define the default hightlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
"if version >= 508 || !exists("did_cfg_syn_inits")
"    if version < 508
"	let did_cfg_syn_inits = 1
"	command -nargs=+ HiLink hi link <args>
"    else
"	command -nargs=+ HiLink hi def link <args>
"    endif
    hi link cfgProto			Label
    hi link cfgComment			Comment
    hi link cfgBlock			Type
    hi link cfgString			String
    hi link cfgStatement		Keyword
    hi link cfgTemplateStatement	Keyword
    hi link cfgPeer			Keyword
    "hi link cfgParams			PreProc
    "hi link cfgValues			Constant
    hi link cfgProto			Constant
    hi link cfgVar			Identifier
    hi link cfgBuiltin			Identifier
    hi link cfgBuiltinEnd		Identifier
    hi link cfgMachine			PreProc
    hi unfReplace			ctermfg=lightgreen

"    delcommand HiLink
"endif
let b:current_syntax = "cfg"
" vim:ts=8
