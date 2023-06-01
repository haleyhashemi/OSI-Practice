

# unix_cmd will take an input file with time stamps from 0
# and will convert these time stamps to unix time based on the file name
# which is the time in GMT
# NOTE I still need to figure out how to convert every file name to unix


proc scores_cmd {fn outfile} {
	set outfile $outfile
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	set data [lrange $contents 1 end]
	regexp {([0-9]+)_labels} $fn a b
	set unixtime [clock scan $b -format %Y%m%d%H%M%S -gmt 1]
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
		puts $outfile "$unixtime $wake $sleep $background"
		incr unixtime
	}
}	
 


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

proc index_cmd {fn} {
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	close $f
	set index [lsearch -index 0 $contents "1680184627.0"]
	puts $index	
	set contents [lrange $contents $index end]
	set outfile [open FinalNPvalues.txt w]
	foreach line $contents {
		puts $outfile $line
	}
	close $outfile
	
}
		
#lindex list N 
proc match_cmd {fn1 fn2} {
	set outfile [open final.csv w]
	set open_scores [open $fn1 r]
	set open_characteristics [open $fn2 r]
	set content_scores [split [string trim [read $open_scores]] \n]
	set content_characteristics [split [string trim [read $open_characteristics]] \n]
	puts [lindex $content_characteristics 4]
	
	for {set i 0} {$i < [llength $content_scores]} {incr i} {
			set line [lindex $content_scores 0]
			set line2 [lindex $content_characteristics 0]
			lappend finalline "$line $line2"
			set content_scores [lrange $content_scores 1 end]
			set content_characteristics [lrange $content_characteristics 1 end]	
	}

	foreach line $finalline { 
		set one [lrange $line 0 3]
		set two [lrange $line 5 6]
		lappend newline "$one $two"
	}
	
	foreach line $newline {
		puts $outfile $line
	}
	
	close $open_scores
	close $open_characteristics
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

foreach fn [findfiles [pwd] "*LWDAQ.txt"] {
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	close $f
	puts "[file tail $fn] [llength $contents]"
}
set out [open NPvalues.txt w]
foreach fn [findfiles [pwd] "*LWDAQ.txt"] {
	fixtime_cmd $fn $out
}
close $out


foreach fn [findfiles [pwd] "*.csv"] {
	set f [open $fn r]
	set contents [split [string trim [read $f]] \n]
	close $f
	puts "[file tail $fn] [llength $contents]"
}

set outfile [open wakesleep.txt w]
foreach fn [findfiles [pwd] "*.csv"] {
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
			"index" {
				index_cmd $args
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
	
