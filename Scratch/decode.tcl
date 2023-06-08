
set fn "original.txt"
set f [open $fn r]
set contents [string trim [read $f]]
puts $contents 
set outfile [open encoded.txt w]
foreach val $contents {
	set num1 [scan $val %c]
	set num2 [expr $num1 + 1]
	if {$num1 == 122} {
		set num2 "97"
	} elseif {$num1 == 90} {
		set num2 "97"
	} 
	if {$num2 <= 90} {
		set num2 [expr $num2 + 32]
	}
	set newletter [format %c $num2]
	puts $outfile $newletter
}
close $outfile
close $f

