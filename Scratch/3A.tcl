


set fn "numbers.txt"
set f [open $fn r]
set contents [read $f]
	set sum 0
	set diff 0
	set N 0
	foreach val $contents {
		set sum [expr {$val + $sum}]
		incr N
	}
	set mean [expr {$sum / double ($N)}]
	foreach val $contents {
		set diff [expr ($val - $mean) * ($val - $mean)  +$diff]
	}
	set stdev [expr {sqrt ($diff /$N)}]
	puts "$N [format "%.3f" $mean] [format "%.3f" $stdev]"
	close $f  

	