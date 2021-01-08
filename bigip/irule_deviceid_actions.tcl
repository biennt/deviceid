when HTTP_REQUEST {
    set host [HTTP::host]
    set uri [HTTP::uri]
    HTTP::header remove captcharequire
    set blockmode 0
    set letgo 0
    set redir 0
    if {[HTTP::cookie exists "_imp_apg_r_"]} {
        set deviceid [URI::decode [HTTP::cookie "_imp_apg_r_"]]
        set deviceida [lindex [regexp -inline -- (?:"diA":")(.*?)(?:") $deviceid] 1]
        set deviceidb [lindex [regexp -inline -- (?:"diB":")(.*?)(?:") $deviceid] 1]
      } else {
        set deviceida "NoDID"
        set deviceidb "NoDID"
      }
       #below is for device that block fingerprinting
      if {$deviceidb equals ""} {
          set deviceidb "NoDID"
    }
    
    binary scan [md5 $deviceida] H* hashvalA
    binary scan [md5 $deviceidb] H* hashvalB
    
    if {$host equals "elk.bienlab.com"} {
        if { $deviceidb ne "NoDID" } {
            set tbllook [table lookup -subtable deviceK $hashvalB]
            if {$tbllook ne ""} {
                set blockmode 1
            }
        }
    }
    if {$host equals "cloeapp.bienlab.com"} {
          if { $deviceida ne "NoDID" } {
        set tbllook [table lookup -subtable deviceA $hashvalA]
        if {$tbllook ne ""} {
          set letgo 1
        }
      }
      if { $deviceidb ne "NoDID" } {
        set tbllook [table lookup -subtable deviceB $hashvalB]
        if {$tbllook ne ""} {
          set letgo 1
        }
      }
    }
    if {($host equals "ebook.bienlab.com") && ($uri equals "/") } {
        if { $deviceidb ne "NoDID" } {
            set tbllook [table lookup -subtable deviceL $hashvalB]
            if {$tbllook eq "1"} {
                # Vietnamese
                set redir 1
                set nexturl "https://ebook.bienlab.com/language/new/vie"
            }
            if {$tbllook eq "2"} {
                # English
                set redir 2
                set nexturl "https://ebook.bienlab.com/language/new/eng"
            }
        }
    }
    if {$redir != 0} {
        HTTP::respond 302 Location $nexturl
    }    
    if {$blockmode == 1} {
        HTTP::respond 403 content { You are too fast. See me in 10 minutes}
    }
    if {$letgo == 1} {
        HTTP::header insert "captcharequire" "no"
    }
}
