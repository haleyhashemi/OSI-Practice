

set fn "numbers.txt"
set f [open $fn w]
set values ""
set min 0
set max 10000
for {set i 0} { $i < $max} {incr i} {
		set num [expr 1.0 * $i / 10000] 
		lappend values [format "%.3f" $num]
	} 
puts $f $values
close $f


