set fn "original.txt"
set f [open $fn r]
set contents [split [string trim [read $f]] \n]
set contents [split $contents " "]
set outfile [open encoded.txt w]
foreach val $contents {
	set num1 [ scan $val %c]
	set num2 [expr $num1 + 1]
	if {[expr $num1 == 122]} {
		set num2 [expr $num1 - 25]
	} elseif {[expr $num1 == 90]} {
		set num2 [expr $num1 -25]
	} 
	if {$num2 <= 90} {
		set num2 [expr $num2 + 32]
	}
	set newletter [format %c $num2]
	puts $outfile $newletter
}
close $outfile
close $f

