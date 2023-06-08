set fn "encoded.txt"
set f [open $fn r]
set contents [split [string trim [read $f]] \n]
set contents [split $contents " "]
set outfile [open decoded.txt w]
foreach val $contents {
	set num1 [scan $val %c]
	set num2 [expr $num1 - 1]
	if {[expr $num1 == 97]} {
		set num2 "122"
	} elseif {[expr $num1 == 65]} {
		set num2 "122"
	} 
	if {$num2 <= 90} {
		set num2 [expr $num2 + 32]
	}
	set newletter [format %c $num2]
	puts $outfile $newletter
}
close $outfile
close $f