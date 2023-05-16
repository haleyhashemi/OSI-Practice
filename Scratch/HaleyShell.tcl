#! /usr/bin/tclsh 

#EXIT cmd



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
			puts $h}
	} elseif {[lindex $ans 0] == "GOTO"} {
		set dir [lindex $ans 1]
		if {![file exists $dir]} {
			puts "ERROR: Directory $dir does not exist."
		} else {
			puts "Moving to $dir"
			cd $dir}
		}  elseif {[lindex $ans 0] == "DIVISIBLE"} {
			set N1 [lindex $ans 1]
			set N2 [lindex $ans 2]
			if {$N1 % $N2 == 0} {
			set div [expr $N1 / $N2]
			puts "$N1 divided by $N2 is an integer, the value is $div"
		} else {
			puts "$N1 is not divisible by $N2"
			}
	}	elseif {[lindex $ans 0] == "PERCENT"} {
			set N1 [lindex $ans 1]
			set N2 [lindex $ans 2]
			set div [expr {$N1 / double ($N2)}]
			set percent [expr $div * 100]
			puts "$percent"	

	} elseif {[lindex $ans 0] == "CHANGE"} {
			set N1 [lindex $ans 1]
			set N2 [lindex $ans 2]
			set diff [expr $N2 - $N1]
			set change [expr {$diff / double ($N1)} * 100]
			if {$change > 0} {
				puts " There is a $change % increase"
				} else {
				puts "There is a $change % decrease"
				}
	} else {
			puts "$ans not recognized."
	} 
}
puts "Bye!"

