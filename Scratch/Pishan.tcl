


# Proc_scores opens a csv file in the current directory if the directory file name is
# a time in numerical "YMDHMS" form. This proc assumes the time is British Summer Time zone.
# This procudure assumes that this file a second is 25 frames, and that each frame denotes 
# a binary wake, sleep, background, or unknown value. Based on the values for each 25 frames,
# Proc_Scores will then assign a 1 or 0 for each category per second, 
# and the results will be printed to a text outfile called wakesleep.txt

proc scores_cmd {fn outfile} {
	set outfile $outfile
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	set data [lrange $contents 1 end]
	if { [regexp {([0-9]+)_labels} $fn a b]} {
		set unixtime [clock scan $b -format %Y%m%d%H%M%S -gmt 1]
		set unixtime [expr $unixtime + 600]
		puts $unixtime
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
				set background 1
			}
			puts $outfile "[format %.1f $unixtime] $wake $sleep $background"
			incr unixtime
	
		}
	} else {
		puts "File $fn is not a viable file for the scores procedure."
	}	
 }

# Fixtime procedure will take an .ndf file and assign each characteristic line its corresponding unix time stamp,
# Each line is written to an outfile to create a new list, with unix time, EEG, and EMG values.

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
	

		
# Match procedure sorts through two lists by comparing the values of their first elements in each line
# If value A > value B, the line containing value B is discarded, and vice verse
# If the elements match, both lines are written to a new file as a new line in a list. 
# Then, both of the lines containing the matching first element are discarded so the sorting 
# can continue.

proc match_cmd {fn1 fn2} {
	set outfile [open final.csv w]
	puts $outfile
	set open_s [open $fn1 r]
	set open_c [open $fn2 r]
	set A [split [string trim [read $open_s]] \n]
	set B [split [string trim [read $open_c]] \n]
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
			puts [llength $A]
			puts [llength $B]
		}
	}
	foreach line $outlist { 
		puts $outfile $line
	
	}
	close $outfile
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
set out [open NPvalues.txt w]
foreach fn [findfiles [pwd] $cfile_pattern] {
	fixtime_cmd $fn $out
}
close $out

set csv_pattern "*.csv"
foreach fn [findfiles [pwd] $csv_pattern] {
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	close $f
	puts "[file tail $fn] [llength $contents]"
}

set outfile [open wakesleep.txt w]
foreach fn [findfiles [pwd] $csv_pattern] {
	scores_cmd $fn $outfile
}	
close $outfile



while {1} {
	puts -nonewline "Neuroanalysis> "
	flush stdout
	gets stdin ans
	set cmd [lindex $ans 0]
	set args [lrange $ans 1 end]
	if {[catch {
		switch -nocase $cmd {
			"Fixtime" {
				fixtime_cmd $args
			}
			"Match" {
				match_cmd [lindex $args 0] [lindex $args 1]
			} 
			"scores" {
				eval "scores_cmd $args"
			}
			"exit" {
    			exit
			}
			default {
				puts "Unrecognized command"
			}
		}

	} error_message]} {
		puts "ERROR: $error_message"
	}
		
}



	
