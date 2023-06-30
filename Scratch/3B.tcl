

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


#Read list A. Add the first element of list A tolist B, setting list A to
#consist of the second element onward. Do this each time the first element of
#list A is added to list B. If the first element of list A is less than the
#first element of list B, add it to list B as the new first element. If it is
#greater, add it to list B as the final element.  If none of those statements
#are true, check to see if the first element of list A is less than each
#element in list B, starting from the second element of list B. Once it is
#less than an element in list B, insert the first element of list A into list
#B in the position directly before the element it is less than.

proc haleysort {fn} {
	set outfile [open haleysorted.txt w]
	set f [open $fn r]
	set contents [split [string trim[ read $f]] \n]
	set B [list]
	set first [lindex $contents 0]
	lappend B $first
	set contents [lrange $contents 1 end]
	while {$contents != ""} {
		set first [lindex $contents 0]
		set contents [lrange $contents 1 end]
		if {$first < [lindex $B 0]} {
			set B [linsert $B 0 $first]
		} elseif {$first > [lindex $B end]} {
			lappend B $first
		} else {
			foreach val $B {
				if {$first < $val} {
					set B [linsert $B [lindex $val] $first]
				} elseif {$first == $val} {
					set B [linsert $B [lindex $val] $first]
				} 
			}
		}
	}

}

