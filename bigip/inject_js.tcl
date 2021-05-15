when HTTP_REQUEST {
   STREAM::disable
   if { [HTTP::version] eq "1.1" } {
      if { [HTTP::header is_keepalive] } {
        HTTP::header replace "Connection" "Keep-Alive"
      }
   }
}
when HTTP_RESPONSE {
   if {[HTTP::header Content-Type] starts_with "text/html"} {
      STREAM::expression {@</head>@<script async defer src="https://dip.zeronaught.com/__imp_apg__/js/f5cs-a_aabz35oIkM-6b92a1c3.js" id="_imp_apg_dip_" _imp_apg_cid_="f5cs-a_aabz35oIkM-6b92a1c3" _imp_apg_api_domain_="https://dip.zeronaught.com"></script></head>@}
      STREAM::enable
   }
}
when STREAM_MATCHED {
	
   STREAM::disable
}

