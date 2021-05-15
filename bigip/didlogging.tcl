when HTTP_REQUEST {
    set logString ""
    set collectflag 0
    set collectauthcode 0
    # authcode = 0: not authentication request, 1: authentication ok, 2: wrong user/pass, 3: wrong captcha
    set authcode 0
    set setf5did 0
    
     if [HTTP::cookie exists "_imp_apg_r_"] {
        set deviceid [URI::decode [HTTP::cookie "_imp_apg_r_"]]
        set deviceida [lindex [regexp -inline -- (?:"diA":")(.*?)(?:") $deviceid] 1]
        set deviceidb [lindex [regexp -inline -- (?:"diB":")(.*?)(?:") $deviceid] 1]
      } else {
        set deviceida "NoDID"
        set deviceidb "NoDID"
    }
    
    if {$deviceida equals ""} {
        set deviceida "NoDID"
    }
     if {$deviceidb equals ""} {
        set deviceidb "NoDID"
    }
    
    
   if [HTTP::cookie exists "f5did"] {
        set uName [HTTP::cookie "f5did"]
   } else {
        set uName "empty"
   }
   
   set virtual [virtual name]
   set client_ip [IP::client_addr]
   set xff_ip [HTTP::header "X-Forwarded-For"]
   # below is for xff containing more than one IP, get the left-most
   if {$xff_ip contains ","} {
        set tmpstr1 [lindex [split $xff_ip ","] 0]
        set xff_ip $tmpstr1
   }
   # for whatever reason, if xff_ip is empty, set it to $client_ip
   if {$xff_ip equals ""} {
       set xff_ip $client_ip
   }
   set client_port [TCP::client_port]
   set http_host [HTTP::host]
   set http_method [HTTP::method]
   set http_request_uri [HTTP::path -normalized]
   set content_type [HTTP::header "Content-Type"]
   if {$content_type equals ""} {
       set content_type "nocontenttype"
   }

   set content_type "nocontenttype"
   
   set content_length [HTTP::header "Content-Length"]
   if {$content_length equals ""} {
       set content_length "0"
   }
   set http_user_agent [HTTP::header "User-Agent"]
    if { ([HTTP::method] equals "POST") && ([HTTP::uri] starts_with "/app1/login.php")} {
      HTTP::header remove "Accept-Encoding"
      if { [HTTP::header is_keepalive] } {
         HTTP::header replace "Connection" "Keep-Alive"
         HTTP::version "1.0"
      }      
      set collectflag 1
      HTTP::collect 500
    }
    if {[string tolower [HTTP::query]] contains "/app1/logout.php"} {
	  set setf5did 3
    }
}
when SERVER_CONNECTED {
   set lb_server "[LB::server addr]:[LB::server port]"
   if { [string compare "$lb_server" ""] == 0 } {
      set lb_server "0.0.0.0:0"
   }
}
when HTTP_REQUEST_DATA {
   if {$collectflag == 1} {
      set payload [HTTP::payload 500]
      if {$payload contains "_userName"} {
          set uid1 [lindex [split [HTTP::payload] "&"] 8]
          set uName [string range $uid1 [expr {[string first "=" $uid1] + 1 }] end]
          set collectauthcode 1
          HTTP::header remove "Accept-Encoding"
           if { [HTTP::header is_keepalive] } {
             HTTP::header replace "Connection" "Keep-Alive"
             HTTP::version "1.0"
           }
          if {[HTTP::cookie exists "f5did"]}{
            set setf5did 2
            } else {
            set setf5did 1
            }
      }
      HTTP::release
   }
}

when HTTP_RESPONSE {
   set status_code [HTTP::status]
   if {$setf5did == 1} {
        HTTP::cookie insert name "f5did" value $uName path "/"
   }
   if {$setf5did == 2} {
        HTTP::cookie remove "f5did"
        HTTP::cookie insert name "f5did" value $uName path "/"
   }
   if {$setf5did == 3} {
        HTTP::cookie remove "f5did"
        HTTP::cookie insert name "f5did" value "empty" path "/"
   }
   if {$collectauthcode == 0} {
       set timestamp [clock clicks -milliseconds]
       set logString "<190>#${timestamp}#${uName}#${virtual}#${client_ip}#${client_port}#${xff_ip}#${lb_server}#${http_host}#${http_method}#${http_request_uri}#${status_code}#${content_type}#${content_length}#${deviceida}#${deviceidb}#${http_user_agent}#$authcode#"
       log local0.info "$logString"
   } else {
        if {[HTTP::header "Content-Length"] ne "" && [HTTP::header "Content-Length"] <= 1048576}{
          set content_length [HTTP::header "Content-Length"]
        } else {
            set content_length 1048576
        }
        if { $content_length > 0} {
          HTTP::collect $content_length
        }   
   }
}
when HTTP_RESPONSE_DATA {
    if {$collectauthcode == 1} {
        set payload [HTTP::payload $content_length]
        set authcode 1
        if {$payload contains "invalid username/password"} {
            set authcode 2
        }
        if {$payload contains "invalid captcha"} {
            set authcode 3
        }
       HTTP::release
       set timestamp [clock clicks -milliseconds]
       set logString "<190>#${timestamp}#${uName}#${virtual}#${client_ip}#${client_port}#${xff_ip}#${lb_server}#${http_host}#${http_method}#${http_request_uri}#${status_code}#${content_type}#${content_length}#${deviceida}#${deviceidb}#${http_user_agent}#$authcode#"
       log local0.info "$logString"        
    }
}

