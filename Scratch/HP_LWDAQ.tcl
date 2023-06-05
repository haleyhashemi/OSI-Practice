
		
# HP_LWDAQ procedure will calculate the EEG and EMG values from an ndf file in the neuroplayer.
if { $info(channel_num)%2  == "0"} {
	set scale 1.3
} else {
	set scale 0.41
}

set sum 0
set diff 0
set N 0
foreach val $info(values) {
	set sum [expr $val + $sum]
	incr N 1	
}
set mean [expr 1.0 * $sum / $N]
foreach val $info(values) {
	set diff [expr ($val - $mean) * ($val - $mean) + $diff]
}
set stdev [expr $scale * sqrt($diff / $N)]
append result "[format "%.1f" $stdev] "


set fn "Wake.txt"
if {[file exists $fn]} {
	set f [open $fn r]
	set data [read $f]
	set column [split $data "\n"]
	foreach {val} $column {
		set newcolumn [split $val " "]
		set wake [lindex $newcolumn 4]
		puts $wake		
		}
}
	

