when HTTP_REQUEST {
set content "i do not understand\n"
    switch -glob [string tolower [HTTP::path]] {
       "/insert*" {
            set didtype [URI::query [HTTP::uri] type]
            set item [URI::query [HTTP::uri] key]
            set value [URI::query [HTTP::uri] value]
            log local0.info "-- $item -- $didtype -- $value"
            if { $didtype eq "A" } {
                table set -subtable deviceA -excl $item 600
                set content "$item (device$didtype) has been inserted"
            }
            if { $didtype eq "B" } {
                table set -subtable deviceB -excl $item 600
                set content "$item (device$didtype) has been inserted"
            }
            if { $didtype eq "K" } {
                table set -subtable deviceK -excl $item 600
                set content "No worried, i will block $item for 10 minutes.\n"
            }
            if { $didtype eq "L" } {
                table set -subtable deviceL $item $value 600
                set content "$item (device$didtype) has been inserted, value=$value\n"
            }
        }
       "/count" {
            set totalA [table keys -subtable deviceA -count]
            set totalB [table keys -subtable deviceB -count]
            set totalK [table keys -subtable deviceK -count]
            set totalL [table keys -subtable deviceL -count]
            set content "DeviceA: $totalA\nDeviceB: $totalB\nDeviceK: $totalK\nDeviceL: $totalL\n"
        }
        default {
        }
    }
    HTTP::respond 200 content $content
    return
}
