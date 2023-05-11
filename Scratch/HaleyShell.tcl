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
	} elseif {[lindex $ans 0] == "GOTO"} {
		set dir [lindex $ans 1]
		if {![file exists $dir]} {
			puts "$dir does not exist."
		} else { 
			puts "Moving to $dir"
			cd $dir
		}
	} else {
		puts "$ans not recognized."
	}
}
puts "Bye!"


