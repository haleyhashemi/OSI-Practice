#! /usr/bin/tclsh

# The Hunt Manager manages the Linux tutorial that takes the form of several
# treasure hunts through the subdirectories of the Hunt. That "hash-bang" line
# above causes this script to run in the Tcl interpreter. We should run the
# script with "./manager.sh &" so as to get it running in the background, which
# frees up our terminal to do the hunt. In order to work the manager must have
# the Tcl interpreter at /usr/bin/tclsh and the TclTk interpreter at
# /usr/bin/wish.

# We define start and finish times. The Hunt Manager will stop after some number of 
# seconds. We use the clock command to give us the Unix time, and later to format
# the Unix time into a date string. The Unix time is the number of seconds since the
# start of 1970.
set runtime 10000
set start [clock seconds]
set finish [expr $start + $runtime]
puts "Hunt manager started at [clock format $start]."
puts "Will stop automatically at [clock format $finish]."
puts "Stop manager process with command \"kill [pid]\"."
puts "Press return to see your terminal prompt again. If your prompt does"
puts "not return, press CTRL-C and run again with \"./mnanager &\". That"
puts "ampersand is essential: it gets the manager to run in the background."

# Here we look at the story file and do some counting.
set f [open Ocean/Story.txt r]
set contents [read $f]
close $f
set ocount 0
set Ecount 0
for {set i 0} {$i < [string length $contents]} {incr i} {
	set c [string index $contents $i]
	if {$c == "o"} {incr ocount}
	if {$c == "E"} {incr Ecount}
}
set o_to_E [expr $ocount / $Ecount]

# Our while loop runs until the finish time. The loop contains a 1-s delay (1000 ms)
# so that it does not occupy the processor more than necessary. It checks the various
# files that the hunters will write to disk, and responds to them. It deletes files
# to make way for the next hunter.
while {[clock seconds] < $finish} {
	after 1000
	
	# This is a message to remind the hunters that the Hunt Manager is running.
	if {[clock seconds] % 1000 == 0} {
		puts "Hunt manager running, time is [clock format [clock seconds]]."
	}

	# Here we check to see if the sum.txt file is present, and check it contains the
	# correct value. If so, we wait a bit and delete the file, 
	set fn "Lagoon/sum.txt"
	if {[file exists $fn]} {
		set f [open $fn r]
		set contents [read $f]
		close $f
		if {$contents == 123} {
			after 100
			catch {file delete $fn}			
			catch {[file delete "Mountain/newclue.txt"]}
			puts "Congratulations, you have completed Hunt Two. The"
			puts "Hunt Manager will wait until you have collected your gold coin."
			exec /usr/bin/wish "Ocean/gc.tcl"
		}
	}
	
	set fn "Ocean/roman.txt"
	if {[file exists $fn]} {
		set f [open $fn r]
		set contents [string trim [read $f]]
		close $f
		if {$contents == "LXXXII"} {
			after 100
			catch {file delete $fn}
			set f [open Mountain/newclue.txt w]
			puts $f "Well done getting the LXXXII correct. Your final number is"
			puts $f "forty-one. Add this to your existing sum and make a file"
			puts $f "called sum.txt in the Lagoon that contains this number."
			close $f
		}
	} 
	
	set fn "Lagoon/sum1000.txt"
	if {[file exists $fn]} {
		set f [open $fn r]
		set contents [string trim [read $f]]
		if {$contents == 500500} {
			after 100	
			catch {file delete $fn}
			puts "Congratulations, you have completed Hunt Three. The"
			puts "Hunt Manager will wait until you have collected your gold coin."
			exec /usr/bin/wish "Ocean/gc.tcl"
		}
	}

	set fn "Ocean/o_div_E.txt"
	if {[file exists $fn]} {
		set f [open $fn r]
		set contents [string trim [read $f]]
		if {$contents == [expr $o_to_E]} {
			after 100	
			catch {file delete $fn}
			puts "Hunt Manager Message:"
			puts "Correct: there are $ocount o's and $Ecount E's in the story."
			puts "Now count how many times the word \"Sallina\" appears in the"
			puts "story. Run sum-checker in the Jungle and enter your value."
		}
	}
}

# We are about to exit. It could be that there is no terminal to write to any more,
# which will lead to the loss of the announcement below.
puts "Hunt Manager Stopping at [clock format [clock seconds]]."
