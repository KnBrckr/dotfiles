augroup gitlab
	" Remove all gitlab commands
	autocmd!

	" Use ^ to separate command and search segments
	command! GlabRefsToOrgLink
		\ silent! exe "g^\\(\\i\\|-\\)\\+#\\d\\+^v^https^s^\\(\\f\\+/\\(\\(\\i\\|-\\)\\+\\)\\)#\\(\\d\\+\\)^[[https://gitlab.ilts.com/\\1/-/issues/\\4][\\2#\\4]]^" |
		\ silent! exe "g^\\(\\i\\|-\\)\\+!\\d\\+^v^https^s^\\(\\f\\+/\\(\\(\\i\\|-\\)\\+\\)\\)!\\(\\d\\+\\)^[[https://gitlab.ilts.com/\\1/-/merge_requests/\\4][\\2#\\4]]^" |
		\ exe "g/\\[\\[.*\\]\\]/s/\\(\\[\\[.*\\]\\]\\)\\s\\+\\(.*\\)\\s\\+(.*\\(P::\\d\\).*/\\3 \\1 \\2/"
augroup END
