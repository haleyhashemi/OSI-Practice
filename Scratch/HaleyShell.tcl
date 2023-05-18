#! /usr/bin/tclsh 

#EXIT cmd

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

proc percent_cmd {N1 N2} {
	set div [expr {$N1 / double ($N2)}]
	set percent [expr $div * 100]
	puts "$percent"	
}

proc divisible_cmd {N1 N2} {
	set div [expr $N1 / double ($N2)]
	if {$N1 % $N2 == 0} {
		puts "$N1 divided by $N2 is an integer, the value is $div"
	} else {
		puts "$N1 is not divisible by $N2, the value is $div"
	}
}

proc goto_cmd {A} {
	if {![file exists $A]} {
		puts "ERROR: Directory $A does not exist."
	} else {
		puts "Moving to $A"
		cd $A
	}
}

proc wordcount_cmd {fn} {
	if {[file exists $fn]} {
		set f [open $fn r]
		set contents [split [string trim [read $f]] { }]
		puts "$fn contains [llength $contents] words."
#		foreach w $contents {puts $w}
		close $f
	}
} 

proc fromascii_cmd {numlist} {
	foreach number $numlist {
		puts [format %c $number]
	}
}

proc toascii_cmd {charlist} {
	foreach char $charlist {
		puts [scan $char %c]
	}
}

while {1} { 
	puts -nonewline "HHSH> "
	flush stdout
	gets stdin ans
	if { $ans == "EXIT"} {
		break 
	} elseif {$ans == "LIST"} {
		set direc [glob *]
		foreach a $direc {
			puts "$a"
		} 
	} elseif { [lindex $ans 0] == "ISPRIME"} {
		set N [lindex $ans 1]
		set is_prime 1
  	 	for {set i 2} {$i < $N} {incr i} {
  	 		if {$N % $i == 0} {
  	 			set is_prime 0
  	 			break
  	 		} 	 
  	 		if {$i % 1000000 == 0} {
  	 			puts -nonewline "."
  	 			flush stdout
  	 		} 
  		} 
  		if {$is_prime} {
  			puts "The number \"$N\" is prime."
  		} else {
  			puts "The number \"$N\" is not prime."
  		}
  	} elseif {$ans == "HELP"} {
		set help " Here! Hi {1:Go to README file} {2:Ask Haley} {3:Listen to Bejeweled by TS}"
		foreach h $help {
			puts $h
		}
	} elseif {[lindex $ans 0] == "GOTO"} {
		goto_cmd [lindex $ans 1]

	}  elseif {[lindex $ans 0] == "DIVISIBLE"} {
			divisible_cmd [lindex $ans 1] [lindex $ans 2]
	} elseif {[lindex $ans 0] == "PERCENT"} {
		percent_cmd [lindex $ans 1] [lindex $ans 2]
	} elseif {[lindex $ans 0] == "CHANGE"} {
		change_cmd [lindex $ans 1] [lindex $ans 2]
	} elseif {[lindex $ans 0] == "WORDCOUNT"} {
		wordcount_cmd [lindex $ans 1]
	} elseif {[lindex $ans 0] == "TOASCII"} {
		toascii_cmd [lrange $ans 1 end]
	} elseif {[lindex $ans 0] == "FROMASCII"} {
		fromascii_cmd [lrange $ans 1 end]
	} else {
		puts "$ans not recognized."
	}

}
puts "Bye!"

