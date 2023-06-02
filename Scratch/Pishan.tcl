

# unix_cmd will take an input file with time stamps from 0
# and will convert topehese time stamps to unix time based on the file name
# which is the time in GMT
# NOTE I still need to figure out how to convert every file name to unix

# Scores command works by opening each csv file in the directory, and calculating the 
# wake/sleep/background value for every second. Each second is 25 lines in the file.
# It then writes the value per second to a new outfile as a list. 
# Regexp is used to identify the start time of the scoring for each file by 
# looking for the pattern of numbers in the file name.
# Clock scan command takes these numbers and formats them to unix time, assuming the 
# the standard times were recorded in the GMT time zone.
# However, these values were recorded in British Summer Time which is one hour ahead of GMT.
# It was tricky to find the British Summer Time timezone indicator for tcl, so 
# the unix start time is set to GMT time, and then 600s (one hour) is added to this to 
# bring it back to BST.

proc scores_cmd {fn outfile} {
	set outfile $outfile
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	set data [lrange $contents 1 end]
	regexp {([0-9]+)_labels} $fn a b
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
}	
 

# Fixtime procedure will take an .ndf file and assign each characteristic line a unix time stamp,
# based on the initial unix time the recording began. 
# Using regexp, the integers in the first value of the first line of the list are extracted and 
# assigned to variable b
# Then, for each line of the characteristics file, the first and second element are replaced with
# the initial unix time plus the time elapsed in seconds since the recording began.
# Each line is written to an outfile to create a new list.

proc fixtime_cmd {fn out} {
	set outfile $out 
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	set startime 0
	regexp {M([0-9]+)} $contents a b
	foreach val $contents {
		set ftime [expr $b + [lindex $val 1]]
		set val [lreplace $val 0 1 $ftime]
		puts $out $val
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
set cfile_pattern "*LWDAQ.txt"
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



#set start [clock scan "30-Mar-2023 13:57:07 GMT" -format {%d-%b-%Y %H:%M:%S %z}]
	
