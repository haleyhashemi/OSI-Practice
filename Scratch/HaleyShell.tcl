#! /usr/bin/tclsh 

#EXIT cmd


proc rand_cmd {args} {
	set fn $args
	set f [open $fn w]
	set values ""
	set min 0
	set max 100000
	for {set i 0} { $i < $max} {incr i} {
			lappend values [expr $i / 10000]
		} 
	puts $f $values
}


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

# This code counts the amount of words in a file. 
# fn in yellow is the argument variable, and that name of the file that is entered 
# next to "WORDCOUNT" is content of the variable/argument. Here I have a standard
# If clause following the defined argument. 
# Use string trim to count the words and ignore empty space at the beginning of the end of the text.
# Use split { } to remove the places in the text where there are two spaces, which
# Will be confuse string trim. The curly brackets include a space in the middle.
# Close the file. 
proc wordcount_cmd {fn} {
	if {[file exists $fn]} {
		set f [open $fn r]
		set contents [split [string trim [read $f]] { }]
		puts "$fn contains [llength $contents] words."
#		foreach w $contents {puts $w}
		close $f
	}
} 


# Root mean square command below.
proc rms_cmd {args} {
	set args [join $args]
	set getinfile 0
	set infile ""
	set getoutfile 0
	set outfile ""
	set newargs $args
	foreach a $args {
		if {$getinfile} {
			set infile $a
			set getinfile 0
			puts "set infile to $a"
		} elseif {$getoutfile} {
			set outfile $a
			set getoutfile 0
			puts "outfile is $a"
		} elseif {$a == "-i"} {
			set getinfile 1
		} elseif {$a == "-o"} {
			set getoutfile 1
		} else {
			puts "breaking out of loop"
			break
		} 
		set newargs [lrange $newargs 1 end]
	}

	puts "infile = \"$infile\""
	puts "outfile = \"$outfile\""

	if {$infile != ""} {
		set f [open $infile r]
		set contents [read $f]
		set sqr 0
		set total 0
		foreach val $contents {
			set sqr [expr {$val * $val} + $sqr]
			incr total 1
		}
		set meansquare [expr $sqr / $total]
		set rms [expr {sqrt ($meansquare)}]
		puts $rms
	}
	if {$outfile != "" } {
		set f [open $outfile w]
		puts $f $rms
		close $f
	} else {
		puts $rms
	}
		
}



# Standard deviation command below. 

proc stdev_cmd {args} {
	set args [join $args]
	set getinfile 0
	set infile ""
	set getoutfile 0
	set outfile ""
	set newargs $args
	foreach a $args {
		if {$getinfile} {
			set infile $a
			set getinfile 0
			puts "set infile to $a"
		} elseif {$getoutfile} {
			set outfile $a
			set getoutfile 0
			puts "outfile is $a"
		} elseif {$a == "-i"} {
			set getinfile 1
		} elseif {$a == "-o"} {
			set getoutfile 1
		} else {
			puts "breaking out of loop"
			break
		} 
		set newargs [lrange $newargs 1 end]
	}

	puts "infile = \"$infile\""
	puts "outfile = \"$outfile\""

	if {$infile != ""} {
		if {![file exists $infile]} {
			error "File \"$infile\" does not exist"
		}
		set f [open $infile r]
		set contents [read $f]
		set sum 0
		set diff 0
		set N 0
		foreach val $contents {
			set sum [expr {$val + $sum}]
			incr N 1
		}
		puts $sum
		set mean [expr {$sum / double ($N)}]
		puts $mean
		puts $N
		foreach val $contents {
			set diff [expr ($val - $mean) * ($val - $mean)  +$diff]
		}
		puts $diff
		set stdev [expr {sqrt ($diff /$N)}]
		puts $stdev
	} 

	if {$outfile != "" } {
		if {![file exists $outfile]} {
		error "File \"$outfile\" does not exist"
		}
		set f [open $outfile w]
		puts $f $stdev
		close $f
	}
	
}

# From ASCII command below.

proc fromascii_cmd {args} {
	set args [join $args]
	set getinfile 0
	set infile ""
	set getoutfile 0
	set outfile ""
	set newargs $args
	foreach a $args {
		puts $a 
		if {$getinfile} {
			set infile $a
			set getinfile 0 
			puts "set infile to $a"
		} elseif {$getoutfile} {
			set outfile $a
			set getoutfile 0
			puts "set outfile to $a"
		} elseif {$a == "-i"} {
			set getinfile 1
			puts "ready to get infile"
		} elseif {$a == "-o"} {
			set getoutfile 1
			puts "Ready to get outfile"
		} else {
			puts "breaking out of loop"
			break
		}
		set newargs [lrange $newargs 1 end]
		puts "Setting args list to $newargs"
	}
	puts "infile = \"$infile\""
	puts "outfile - \"$outfile\""

	if {$infile != "" } {
		if {![file exists $infile]} {
			error "file \"$infile\" does not exist"
		}
		set f [open $infile r]
		set contents [read $f]
		close $f
	} else {
		set contents $newargs
	}
	
	set ascii ""
	foreach val $contents {
		set char [format %c $val]
		lappend ascii $char}
		
	if {$outfile != ""} {
		if {![file exists $outfile]} {
			error "file \"$outfile\" doesn't exist"}
		set f [open $outfile w]
		puts $f $ascii 
		close $f
	} else {
		puts $ascii
	}
	puts [exec sh -c "diff -w $infile $outfile |grep \\"]
	
}	


# To ASCII command below with explanations.

proc toascii_cmd {args} {
	# Convert args into flat string.
	set args [join $args]

	# Deal with options.
	# Code below explained:
	# Using foreach, the loop will run through each arg and execute commands 
	# Based on the value of the arg.
	# Because the first value should be -i, and getoutfile / getinfile are false,
	# The foreach loop will skip those two components.
	# If $a is -i, it will set the getinfile to true
	# The variable newargs has the contents of args, so the foreach loop sets the new contents of newargs
	# To $newargs with the first argument removed, so that the foreach loop
	# Can repeat itself with the second argument, and so forth.
	# Now, with the second argument that should be a text name,
	# The foreach loop will execute the first if command because the new value of 
	# Getinfile has been set to true by the previous loop
	# It will then set the variable infile to have the contents of the second argument, which is a text file
	# Then, the getinfile is set back to 0 so the loop won't go through that iteration again.
	# Now it will go through the loop again, with the argumnet "-o"
	# Once the argument -o is recognized, the foreach loop sets the getoutfile to true (1).
	# To be continued on monday..
	set getinfile 0
	set infile ""
	set getoutfile 0
	set outfile ""
	set newargs $args
	foreach a $args {
		puts $a
		if {$getinfile} {
			set infile $a
			set getinfile 0
			puts "set infile to $a"
		} elseif {$getoutfile} {
			set outfile $a
			set getoutfile 0
			puts "set outfile to $a"
		} elseif {$a == "-i"} {
			set getinfile 1
			puts "ready to get infile"
		} elseif {$a == "-o"} {
			set getoutfile 1
			puts "ready to get outfile"
		} elseif {$a != ""} {
			puts "breaking out of loop"
			break
		}
		set newargs [lrange $newargs 1 end]
		puts "setting arg list to $newargs"
	}

	puts "infile = \"$infile\""
	puts "outfile = \"$outfile\""


	# Get the input. If infile name is not blank, and it exists, it will read the contents
	# And set the contents to be equal 
	if {$infile != ""} {
		if {![file exists $infile]} {
			error "file \"$infile\" does not exist"
		}
		set f [open $infile r]
		set contents [read $f]
		close $f
	} else {
		set contents $newargs
	}

	puts "contents = $contents"

	
	# Create list of ascii values.
	set ascii ""
	for {set i 0} {$i < [string length $contents]} {incr i} {
		lappend ascii [scan [string index $contents $i] %c]
	}

	puts "ascii = $ascii"

	# Write list to output.
	if {$outfile != ""} {
		set f [open $outfile w]
		puts $f $ascii 
		close $f
	} else {
		puts $ascii
	} 
	puts [exec sh -c "diff -w $infile $outfile |grep \\<"]

}


while {1} {
	puts -nonewline "HHSH> "
	flush stdout
	gets stdin ans
	if {$ans == "EXIT"} {
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
	} elseif {[lindex $ans 0] == "FROMASCII"} {
		fromascii_cmd [lrange $ans 1 end]
	} elseif {[lindex $ans 0] == "TOASCII"} {
		toascii_cmd [lrange $ans 1 end]
	} elseif {[lindex $ans 0] == "RMS"} {
		rms_cmd [lrange $ans 1 end]
	} elseif {[lindex $ans 0] == "STDEV"} {
		stdev_cmd [lrange $ans 1 end]
	} elseif {[lindex $ans 0] == "No52"} {
		No52_cmd [lindex $ans 1]
	} else {
		puts "$ans not recognized."
	}
}
 


puts "Bye!"
-
