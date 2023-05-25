
set fn "Scores.csv"
set f [open $fn r]
set contents [split [string trim [read $f]] \n]
set data [lrange $contents 1 end]
set counter 0
set f [open out.csv w]

while {[llength $data] >= 25} {
	set interval [lrange $data 0 24]
	set data [lrange $data 25 end]
	set wake 0
	set sleep 0
	foreach line $interval {
		set line [split $line "," ]
		if {[lindex $line 3] == 1} {incr wake}
		if {[lindex $line 2] == 1} {incr sleep}
	} 
	if {$wake >= 13} {set wake 1}
	if {$sleep >= 13} {set sleep 1}
	incr counter	
	puts $f "$counter $sleep $wake"
}
	
close $f

set fn "M1680177475_HP_LWDAQ.txt"
set f [open $fn r]
set lines [split [string trim [read $f]] ]
regexp {M([0-9]+).ndf} $lines a b
foreach line $lines {
	puts $line
	set line [lreplace $line 0 0 $b]
	}
#foreach line $chop {}
	 #set ftime [expr $b + [lindex $line 1]]
	#puts $line "$ftime [lindex $line 2] [lindex $line 3]"

#puts $line
#set lines [split [string trim [read $f]] ]

#foreach line $lines {
	#set line [split line ","]

	


#M1680177475.ndf