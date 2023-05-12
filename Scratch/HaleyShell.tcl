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
	} elseif {$ans == "FOLK"} {
		set folk "Cardigan August Betty Hoax Mirrorball"
		set rank "1 2 3 4"
		foreach x [list $folk $rank] {
		puts "$x"}
	} elseif {$ans == "ALBUMS"} {
		foreach {key value} {Folklore 1 Evermore 2 1989 3 Reputation 4 Lover 5} {
		puts "$key: $value"} 
	} elseif {$ans == "LYRICS"} {
		set song "Hoax Cardigan RWYLM WCS"
		set rank "1 2 3 4 5"
		foreach val1 $song val2 $rank {
		puts "$val1: $val2"}
	} elseif {$ans == "MIDNIGHTS"} {
		set rank "{1-Karma} {2-Bejeweled} {3-Midnight Rain} {4-You're on your own kid} {5-Maroon}"
		foreach b $rank {
			puts "$b"} 
	} elseif {[lindex $ans 0] == "GOTO"} {
		set dir [lindex $ans 1]
		if {![file exists $dir]} {
			puts "ERROR: Directory $dir does not exist."
		} else { 
			puts "Moving to $dir"
			cd $dir}
	} else {
		puts "$ans not recognizež."
	}
}
puts "Bye!"

elseif {$ans == "Q1"} {
	puts "What is the name of the TS Cardigan Haley owns? Enter the letter associated."
	set clue1 "{A:Folklore Cardigan} {B:Cardigan Cardigan} {C:Evermore Cardigan}"
	foreach x $clue1 {
		puts $x} 
	while {[gets stdin] != "B"} {
		puts "No! Again!"
	} puts "Yes!"



	}
}

 elseif {[lindex $ans 0] == "IFPRIME"}
  set n [lindex $ans 1] 
  for {set i 3} {$i < $n} {incr i} {
  	if { $n % $i == 0} {
  		puts "Not a prime number"
  	} else {
  		puts "This is a prime number"}
  }