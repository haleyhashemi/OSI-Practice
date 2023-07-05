#! /usr/bin/tclsh 

#EXIT cmd

proc help_cmd {args} {
	puts "Haley Shell commands are executed by the following standard input:"
	puts "isprime: if isprime is followed by a number the command will return"
	puts "a string determining if the number is a prime number"
	puts "list: the list command will print a list of files and directories"
	puts "in the current directory"
	puts "rand: the rand command will generate a file called \"numbers.txt\""
	puts "that contains 10000 real numbers from 0-1"
	puts "change: the change command will determine the percent increase or decrease"
	puts "between the first and second integer following the word \"change\""
	puts "percent: the percent command will determine the percent value for the"
	puts "first integer of a second integer in the input string"
	puts "divisible: the divisible command will determine whether the first"
	puts "integer in the input string is divisible by the second integer in the string"
	puts "goto: the goto command will navigate to the directory name given by"
	puts "the input string"
	puts "wordcount: the wordcout command will count the number of words in the"
	puts "text file given by the input string"
	puts "rms: the rms command will calculate the root mean square value"
	puts "of the integers in the input string. If you'd like to read integers"
	puts "from a file, and print the rms value to a new file, enter:"
	puts "rms -i <infile.txt> -o <outfile.txt>" 
	puts "stdev: the stdev command will calculate the standard deviation value"
	puts "of the integers in the input string. If you'd like to read integers"
	puts "from a file, and print the stdev value to a new file, enter:"
	puts "putsstdev -i <infile.txt> -o <outfile.txt>"
	puts "toascii: the toascii command will convert the characters in the input string"
	puts "to ascii values. If you'd like to read integers" 
	puts "from a file, and print the ascii values to a new file, enter:" 
	puts "toascii -i <infile.txt> -o <outfile.txt>"
	puts "fromascii: the fromascii command will convert the characters in the input string"
	puts "to ascii values. If you'd like to read integers "
	puts "from a file, and print the characters to a new file, enter:"
	puts "fromascii -i <infile.txt> -o <outfile.txt> "
			
}


# Haley sort: Read list A. Add the first element of list A tolist B, setting list A to
# consist of the second element onward. Do this each time the first element of
# list A is added to list B. If the first element of list A is less than the
# first element of list B, add it to list B as the new first element. If it is
# greater, add it to list B as the final element.  If none of those statements
# are true, check to see if the first element of list A is less than each
# element in list B, starting from the second element of list B. Once it is
# less than an element in list B, insert the first element of list A into list
# B in the position directly before the element it is less than.

proc haleysort {fn} {
	set outfile [open haleysorted.txt w]
	set f [open $fn r]
	set contents [split [string trim [read $f] ] " "]
	set B [list]
	lappend B [lindex $contents 0]
	set contents [lrange $contents 1 end]
	while {[llength $contents] > 0} {
		set first [lindex $contents 0]
		set contents [lrange $contents 1 end]
		if {$first < [lindex $B 0]} {
			set B [concat $first $B]
		} elseif {$first > [lindex $B end]} {
			set B [concat $B $first]	
		} elseif {($first > [lindex $B 0]) && ($first < [lindex $B end])} {
			set blength [llength $B]	
			for {set i 1} {$blength == [llength $B]} {incr i} {
				if {$first < [lindex $B $i]} {
					set data [lrange $B $i end]
					set B [lrange $B 0 [expr $i-1]]
					set B [concat $B $first $data]
					
					}
				}
			}
		
	}
	foreach value $B {
		puts $outfile $value 
	}
}



# Randomlist: Generates a randomlist of 1000000 numbers, then calls the
# bubblesort procedure to sort different ranges of values from the list in
# increasing order.

proc randomlist {} {
	set randomlist ""
	puts $randomlist
	for {set i 0} {$i < 1000000} {incr i} {
		lappend randomlist [expr round (rand () *10000)]
	}
	puts [llength $randomlist]
	foreach ll {100 10000 100000 1000000} {
		set sort_list [lrange $randomlist 0 [expr $ll -1]]
		set starttime [clock milliseconds]
		bubblesort sort_list
		puts "$ll took [expr [clock milliseconds] - $starttime] miliseconds to sort."

	}
}

# Bubblesort : Set an index to point to the first element in the list. Clear a swap flag.
# Compare indexed element to next element. If they are not in correct order,
# swap them and set the swap flag. Increment the index and repeat until we get
# to the end of the list. If the swap flag is set, go back to start of list
# and repeat the process. Otherwise, we are done

proc bubblesort {contents} {
	set outfile [open haleysorted.txt w]
	set swap 1
	while {$swap} {
		set swap 0
		for {set i 0} {$i < [expr [llength $contents] -1]} {incr i} {
			if {[lindex $contents $i] > [lindex $contents [expr $i+1]]} {
				set temp [lindex $contents $i]
				lset contents $i [lindex $contents [expr $i+1]]
				lset contents [expr $i+1] $temp
				set swap 1
			}
		}
	}
	foreach value $contents {
		puts $outfile $value
	}
	close $outfile
}
		




# Bubblesortfile : opens a list that is passed to it in the form of a file.
# Set an index to point to the first element in the list. Clear a swap flag.
# Compare indexed element to next element. If they are not in correct order,
# swap them and set the swap flag. Increment the index and repeat until we get
# to the end of the list. If the swap flag is set, go back to start of list
# and repeat the process. Otherwise, we are done

proc bubblesortfile {fn} {
	set outfile [open haleysorted.txt w]
	set f [open $fn r]
	set contents [split [string trim [read $f] ] " "]
	set swap 1
	while {$swap} {
		set swap 0
		for {set i 0} {$i < [expr [llength $contents] -1]} {incr i} {
			if {[lindex $contents $i] > [lindex $contents [expr $i+1]]} {
				set temp [lindex $contents $i]
				lset contents $i [lindex $contents [expr $i+1]]
				lset contents [expr $i+1] $temp
				set swap 1
			}
		}
	}
	foreach value $contents {
		puts $outfile $value
	}
	close $f
	close $outfile
}
		
			


# numbers will generate a list of 10000 real numbers from 0-1. 

proc numbers {} {
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
}


# Proc_scores opens a csv file in the current directory if the directory file
# name is a time in numerical "YMDHMS" form. This proc will prompt the user
# to enter the TCL-name for the timezone, and will generate unix time values
# for each time point in the file. This procudure assumes that this file a
# second is 25 frames, and that each frame denotes a binary wake, sleep,
# background, or unknown value. Based on the values for each 25 frames,
# Proc_Scores will then assign a 1 or 0 for each category per second, and the
# results will be printed to a text outfile called wakesleep.txt


proc scores_cmd {fn outfile timezone interval} {
	set outfile $outfile
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	set data [lrange $contents 1 end]
	if {[regexp {([0-9]+)_labels} $fn a b]} {
		if {$timezone == "gmt"} {
			set unixtime [clock scan $b -format %Y%m%d%H%M%S -gmt 1]
		} elseif {$timezone == "bst"} {
			set unixtime [clock scan $b -format %Y%m%d%H%M%S -gmt 1]
			set unixtime [expr $unixtime + 600]
		} else {
			set unixtime [clock scan $b -format %Y%m%d%H%M%S -timezone "$timezone"]
		}
		# puts $unixtime
		if {$interval == "1"} {
			while {[llength $data] >= 25} {
				set interval [lrange $data 0 24]
				set data [lrange $data 25 end]
				set wake 0
				set sleep 0
				set background 0
				foreach line $interval {
					set line [split $line "," ]
					if {[lindex $line 3] == 1} {incr wake}
					if {[lindex $line 2] == 1} {incr sleep}
				} 
				if {$wake >= 13} {
					set wake 1
					set sleep 0
				} elseif {$sleep >= 13} {
					set sleep 1
					set wake 0
				} elseif {$wake > $sleep} {
					set wake 1
					set sleep 0
				} elseif {$wake < $sleep} {
					set sleep 1
					set wake 0
				} else {
					set background 8
				}
				puts $outfile "[format %.1f $unixtime] $wake $sleep $background"
				incr unixtime 
			}
		} elseif {$interval == "8"} {
			while {[llength $data] >= 200} {
				set interval [lrange $data 0 199]
				set data [lrange $data 200 end]
				set wake 0
				set sleep 0
				set background 0
				foreach line $interval {
					set line [split $line "," ]
					if {[lindex $line 3] == 1} {incr wake}
					if {[lindex $line 2] == 1} {incr sleep}
				} 
				if {$wake >= 104} {
					set wake 1
					set sleep 0
				} elseif {$sleep >= 104} {
					set sleep 1
					set wake 0
				} elseif {$wake > $sleep} {
					set wake 1
					set sleep 0
				} elseif {$wake < $sleep} {
					set sleep 1
					set wake 0
				} else {
					set background 1
				}
				puts $outfile "[format %.1f $unixtime] $wake $sleep $background"
				incr unixtime 8
			}
		}
		
	} else {
		puts "File $fn is not a viable file for the scores procedure."
	}	
 }

# Read the characteristics file that has been generated through the "Fixtime"
# procedure. Open and read each line of the file, creating a list. Calculate
# the average EMG and EEG scores for the first 8 lines of the list. Write the
# average values, along with the first element of the first line in the list
# (the time stamp) to a new file. Remove the first 8 elements from the
# original list, so that the Nth element (your interval processing number) is
# now the first element of the list. Repeat this process until there are no
# longer 8 or more characteristic lines in the list.

proc interval_cmd {fn} {
	set outfile [open interval.txt w]
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	while {[llength $contents] >= 8} {
		set interval [lrange $contents 0 7]
		set contents [lrange $contents 8 end]
		set eeg ""
		set emg ""
		set tstamp ""
		foreach val $interval {
			lappend eeg [lindex $val 1]
			lappend emg [lindex $val 2]
			lappend tstamp [lindex $val 0]
		}
		if {$emg != ""} {
			set t [lindex $tstamp 0]
			set sum 0
			set N 0
			foreach val $eeg {
				set sum [expr $val + $sum]
				incr N 1
			}
			set eeg_avg [expr $sum / double ($N)]
			set sum 0
			set N 0
			foreach val $emg {
				set sum [expr $val + $sum]
				incr N 1
			}
			set emg_avg [expr $sum / double ($N)]
			
			puts $outfile " $t [format %.1f $eeg_avg] [format %.1f $emg_avg]"
		}
	}
	close $f
	close $outfile
}


# States procedure takes a list containing EEG and EMG values and assigns a behavioral state to every second of recorded values.
# In this case, the recorded values are every 8 seconds.
# Lets do every 30 values. 
# If the avaerge eeg value is greater than 70, and the average value of emg is less than 80, incremenet REM. 
# If the average eeg value is less than 70, and the averafe emg value is greater than 80, incr awake.
# if the average eeg value is less than 70, and the average emg value is less than 80, incr NREM.
# If the average eeg value and emg values are high, do nothing 
# Do this before interval
proc states_cmd {fn} {
	set outfile [open scores.txt w]
	set f [open $fn r]
	set contents [split [string trim [read $f]] "\n"]
	while {[llength $contents] >= 15} {
		set interval [lrange $contents 0 14]
		set contents [lrange $contents 15 end]
		set awake 0 
		set REM 0
		set NREM 0
		set sum 0 
		set N 0
		set newlist [list]
		foreach value $interval {
			set sum [expr [lindex $value 1] + $sum]
			incr N 1
		}
		set eeg_avg [expr $sum / double ($N)]
		set sum 0
		set N 0
		foreach value $interval {
			set sum [expr [lindex $value 2] + $sum]
			incr N 1
		}
		set emg_avg [expr $sum / double ($N)]

		if {($eeg_avg < 75) && ($emg_avg < 85)} {
			set NREM 1
		} elseif {($eeg_avg > 75) && ($emg_avg < 85)} {
			set REM 1
		} elseif {($emg_avg > 85) && ($eeg_avg < 75)} {
			set awake 1
		} elseif {($emg_avg > 85) && ($eeg_avg > 75)} {
			if {$emg_avg > $eeg_avg} {
				set awake 1
			} else {
				set REM 1
			}
		}
		foreach line $interval {
			lappend newlist "$line $awake $REM $NREM"
		}
		foreach line $newlist {
			puts $outfile $line
	}
	}
	close $outfile
	close $f
}



		


						


# Fixtime procedure will take any .ndf files in the currenty directory, and
# assign each characteristics line its corresponding unix time stamp. Each
# line of each .ndf file is written to the same outfile to create a new list
# containing all of the unix time stamps and their corresponding EEG and EMG
# values.

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
	close $outfile
}


# Match procedure sorts through two lists by comparing the values of their
# first elements in each line If value A > value B, the line containing value
# B is discarded, and vice verse If the elements match, both lines are
# written to a new file as a new line in a list. Then, both of the lines
# containing the matching first element are discarded so the sorting can
# continue.

proc match_cmd {fn1 fn2} {
	set outfile [open final.txt w]
	set open_s [open $fn1 r]
	set open_c [open $fn2 r]
	set A [split [string trim [read $open_s]] \n ]
	set B [split [string trim [read $open_c]] \n ]
	close $open_s
	close $open_c
	set outlist ""
	while {[llength $A] > 0 && [llength $B] > 0 } {
		set a [lindex $A 0]
		set b [lindex $B 0]
		if {[lindex $a 0] > [lindex $b 0]} {
			set B [lrange $B 1 end]
			
		} elseif {[lindex $b 0] > [lindex $a 0]} {
			set A [lrange $A 1 end]
			puts [llength $A]
			puts [llength $B]
		} else {
			lappend outlist "$a [lrange $b 1 end]"
			set A [lrange $A 1 end]
			set B [lrange $B 1 end]
		}
	}
	
	foreach line $outlist { 
		puts $outfile $line
		puts $line
	
	}
	close $outfile
}



proc isprime_cmd {args} {
	set is_prime 1
 	for {set i 2} {$i < $args} {incr i} {
 		if {$args % $i == 0} {
 			set is_prime 0
 			break
 		} 	 
 		if {$i % 1000000 == 0} {
 			puts -nonewline "."
 			flush stdout
 		} 
	} 
	if {$is_prime} {
		puts "The number \"$args\" is prime."
	} else {
		puts "The number \"$args\" is not prime."
	}
}



proc list_cmd {args} {
	set args [glob *]
	foreach a $args {
					puts "$a"}
}

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

# This code counts the amount of words in a file. fn in yellow is the argument
# variable, and that name of the file that is entered next to "WORDCOUNT" is
# content of the variable/argument. Here I have a standard If clause
# following the defined argument. Use string trim to count the words and
# ignore empty space at the beginning of the end of the text. Use split{ } to
# remove the places in the text where there are two spaces, which Will be
# confuse string trim. The curly brackets include a space in the middle.
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
			set sum [expr $val + $sum]
			incr N 1
		}
		puts $sum
		set mean [expr $sum / double ($N)]
		puts $mean
		puts $N
		foreach val $contents {
			set diff [expr ($val - $mean) * ($val - $mean)  +$diff]
		}
		puts $diff
		set stdev [expr sqrt ($diff /$N)]
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

	if {$infile != "" } {
		if {![file exists $infile]} {
			error "no file named \"$infile\" exists"
		} else {
			set f [open $infile r]
			set contents [read $f]
			close $f
		} 
	} else {
		set contents $newargs
	}
	puts $contents
	
		
	
	set ascii ""
	foreach val $contents {
		set char [format %c $val]
		append ascii $char
	}
		
	if {$outfile != ""} {
		set f [open $outfile w]
		puts $f $ascii 
		close $f
	} else {
		puts "\"$ascii\""
	}

}	


# To ASCII command below with explanations.

proc toascii_cmd {args} {
	# Convert args into flat string.
	set args [join $args]

	# Deal with options. Code below explained: Using foreach, the loop will
	# run through each arg and execute commands Based on the value of the
	# arg. Because the first value should be -i, and getoutfile / getinfile
	# are false, The foreach loop will skip those two components. If $a
	# is -i, it will set the getinfile to true The variable newargs has the
	# contents of args, so the foreach loop sets the new contents of newargs
	# To $newargs with the first argument removed, so that the foreach loop
	# Can repeat itself with the second argument, and so forth. Now, with the
	# second argument that should be a text name, The foreach loop will
	# execute the first if command because the new value of Getinfile has
	# been set to true by the previous loop It will then set the variable
	# infile to have the contents of the second argument, which is a text
	# file Then, the getinfile is set back to 0 so the loop won't go through
	# that iteration again. Now it will go through the loop again, with the
	# argumnet "-o" Once the argument -o is recognized, the foreach loop sets
	# the getoutfile to true (1). To be continued on monday..
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
	}
		set newargs [lrange $newargs 0 end]
		puts "setting arg list to $newargs"
	

	puts "infile = \"$infile\""
	puts "outfile = \"$outfile\""


	# Get the input. If infile name is not blank, and it exists, it will read the contents
	# And set the contents to be equal 
		if {$infile != "" } {
			if {![file exists $infile]} {
			error "file \"$infile\" does not exist"
		} else {
			set f [open $infile r]
			set contents [read $f]
			close $f}
		} else {
		set contents $newargs
	}	
	puts $contents
	

	
	# Create list of ascii values.
	set ascii ""
	for {set i 0} {$i < [string length $contents]} {incr i} {
		lappend ascii [scan [string index $contents $i] %c]
	}

	puts "ascii = $ascii"

	# Write list to output.
	if {$outfile != ""} {
		if {![file exists $outfile]} {
			error "file \"$outfile\" does not exist"
			} else {
				set f [open $outfile w]
				puts $f $ascii 
				close $f
				set diff [catch {exec diff $infile $outfile} ]
				puts $diff
			}
		} else {
			puts $ascii
		} 

	
}


proc findfiles {dir {pattern "*"}} {
	set file_list [list]
	set dir_list [glob -directory $dir *]
	foreach a $dir_list {
		if {[file isdirectory $a]} {
			set subdir_list [findfiles $a $pattern]
			set file_list [concat $file_list $subdir_list]
		} else {
			if {[string match $pattern $a]} {
				lappend file_list $a
			}
		}
	}
	set file_list [lsort -increasing $file_list]
	return $file_list
	
}
set cfile_pattern "*M*.txt"
foreach fn [findfiles [pwd] $cfile_pattern] {
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	close $f
	puts "[file tail $fn] [llength $contents]"
}

set csv_pattern "*.csv"
foreach fn [findfiles [pwd] $csv_pattern] {
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	close $f
	puts "[file tail $fn] [llength $contents]"
}

proc callfix_cmd {args} {
	set cfile_pattern "*M*.txt"
	set out [open NPvalues.txt w]
	foreach fn [findfiles [pwd] $cfile_pattern] {
		fixtime_cmd $fn $out
	}
	close $out
}
	

	
proc callscores_cmd {timezone interval} {
	set timezone $timezone
	set interval $interval
	set csv_pattern "*.csv"	
	set outfile [open wakesleep.txt w] 
	foreach fn [findfiles [pwd] $csv_pattern] {
		scores_cmd $fn $outfile $timezone $interval
	}
	close $outfile
}
# Switch $ans -

while {1} {
	puts -nonewline "HHSH> "
	flush stdout
	gets stdin ans
	set cmd [lindex $ans 0]
	set args [lrange $ans 1 end]
	if {[catch {
		switch -nocase $cmd {
			"EXIT" {exit}
			"LIST" {
				list_cmd $cmd
			}
			"ISPRIME" {
				isprime_cmd $args	
	  		}
			"HELP" {
				help_cmd $args
			}
			"GOTO" {
				goto_cmd $args
			}
			"DIVISIBLE" {
				divisible_cmd [lindex $args 0] [lindex $args 1]
			} 
			"PERCENT" {
				percent_cmd [lindex $args 0] [lindex $args 1]
			} 
			"CHANGE" {
				change_cmd [lindex $args 0] [lindex $args 1]
			}
			"WORDCOUNT" {
				wordcount_cmd $args
			}
			"FROMASCII" {
				fromascii_cmd $args
			} 
			"TOASCII" {
				toascii_cmd $args
			}
			"SCORES" {
				puts "Please enter the abbreviated time zone for your files." 
				set timezone [gets stdin]
				puts "Thanks, now please enter the interval processing length for the program."
				set interval [gets stdin]
				callscores_cmd $timezone $interval
				
			}
			"FIXTIME" {
				callfix_cmd $args
			}
			"RMS" {
				rms_cmd $args
			}
			"STDEV" {
				stdev_cmd $args
			}
			"Match" {
				match_cmd [lindex $args 0] [lindex $args 1]
			}
			"No52" {
				No52_cmd $args
			}
			"Interval" {
				interval_cmd $args
			}
			"States" {
				states_cmd $args
			}
			"Haleysort" {
				haleysort $args
			}
			"Numbers" {
				numbers
			}
			"Rand" {
				randomlist
			}
			default {
				error "no such command \"$cmd\""
			}
		}
	} error_message]} {
		puts "ERROR: $error_message\."
	}
}
 


