#generator will assign sleep a value of 1 and wake a value of 0 for 5 seconds, then sleep a value of 0 and wake a value of 1 for two seconds.
set start_time [clock scan 20230230135707 -format %Y%m%d%H%M%S]
set filelen 60
set framerate 25
for {set i 0} {$i < 10} {incr i} {
	set timestamp [clock format $start_time -format %Y%m%d%H%M%S]
	set f [open $timestamp\_labels.csv w]
	puts $f ",background,sleep,wake,unknow"
	for {set j 0} {$j < $filelen*$framerate} {incr j} {
			set sleep [expr ($j % 200) < 150]
			set wake [expr !$sleep]

		puts $f "$j,0,$sleep,$wake,0"
	}
	close $f
	set start_time [expr $start_time + $filelen]
}
puts [expr 101 % 200]
set start_time [clock scan 20230230135507 -format %Y%m%d%H%M%S]
set filelen 600
for {set i 0} {$i < 3} {incr i} {
	set f [open M$start_time\_ECP.txt w]
	for {set j 0} {$j < $filelen} {incr j} {
		set EMG [expr 100*abs(sin($j*6.3/$filelen))]
		set EEG [expr 400*abs(sin($j*12.6/$filelen))]
		puts $f "M$start_time\.ndf [format %.1f $j]\
			[format %.1f $EEG] [format %.1f $EMG]"
	}
	close $f
	set start_time [expr $start_time + $filelen]
}
