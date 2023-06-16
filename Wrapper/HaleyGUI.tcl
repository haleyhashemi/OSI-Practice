

proc change_cmd {N1 N2} {
	set diff [expr $N2 - $N1]
	set change [expr {$diff / double ($N1)} * 100]
	if {$change > 0} {
		puts "There is a [format %.1f $change] % increase"
	} else {
		puts "There is a [format %.2f $change] % decrease"
	}
	return $change
}

proc fixtime_cmd {fn out} {
	set outfile $out 
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	set startime 0
	if {[regexp {M([0-9]+)} $contents a b]} {
		foreach val $contents {
			set ftime [expr $b + [lindex $val 1]]
			set val [lreplace $val 0 1 $ftime]
			puts $out $val
		}
	} else {
		puts "error"
	}
}

label .fnopen -text "File" 
pack .fnopen -side left

# Use the open button to browse available files on disc. Once you select a file,
# depending on it's contents, you can use other buttons that will
# execute commands.
button .open -text Open -command {
	set fn [tk_getOpenFile]
}
pack .open -side left

entry .fn -textvariable fn -width 30
pack .fn -side left


# If the file selected from the "Open" button contains two numbers, you can use the 
# change button to calculate the percent increase or decrease between the first and 
# second number written to that file. 
button .change -text Change -command {
	set f [open $fn r]
	set contents [split [read $f] " "]
	set args [lrange $contents 0 end]
	change_cmd [lindex $args 0] [lindex $args 1]
}
pack .change -side left

button .fxtime -text "Fix time" -command {
	set out [open NPvalues.txt w]
	fixtime_cmd $fn $out
}
pack .fxtime -side left 

button .read -text Read -command {
	set f [open $fn r]
	set contents [ string trim [read $f]]
	puts $contents
}
pack .read -side left

button .exit -text Exit -command {
	exit
	}

pack .exit -side right

proc console_execute {} {
	set cmd [read stdin]
	if {[catch {
		set result [uplevel $cmd]
		puts $cmd
		if {$result != ""} {
			puts stdout $result
		}
	} error_result]} {
		puts "ERROR: $error_result"
	} 
}


fconfigure stdin -blocking 0 -buffering line
fileevent stdin readable console_execute





