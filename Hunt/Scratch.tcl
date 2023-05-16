#! /usr/bin/tclsh 

while {1} {
	after 1000

	set fn "Betty.txt"
	if {[file exists $fn]} {
		after 100
		set o [open $fn r]
		set contents [string trim [read $o]]
		close $o
		if {[string match -nocase "wanting was enough for me it was enough" $contents]} {
			puts "Correct. Now, please go to the directory of the album that"
			puts "was released in 2019. Read the text named after not 'her',"
			puts "'him', 'them', or 'you', but '__!'"
			catch {file delete $fn}
		} 
	}


	set fn "Lover/Cats.txt" 
	if {[file exists $fn]} {
		after 100
		set o [open $fn r]
		set contents [read $o]
		close $o
		if {$contents == "3"} {
			puts "Good job. Please go to the Reputation directory"
			puts "Read the file that is named after a word that is the opposite of Delicate"
			catch {file delete $fn}
		} else {
			puts "No, try again"
		}
	}

	set fn "Evermore/Dorothea.txt"
	if {[file exists $fn]} {
		after 100
		set o [open $fn r]
		set contents [string trim [read $o]]
		close $o
		if {$contents == "Tupelo"} {
			puts "Yes, she is from Mississippi. Now I want to tell you something but it might take awhile"
			puts "What would I say if I were to decide to sum it up? Make a new text file called Pedestal.txt that contains the phrase. No capital letters."
			catch {file delete $fn}
		}
	}

	set fn "Evermore/Pedestal.txt"
	if {[file exists $fn]} {
		after 100
		set o [open $fn r]
		set contents [string trim [read $o]]
		close $o 
		if {$contents == "long story short"} {
			puts "Well done. Long story short, it was a bad time."
			puts "Go to 1989, and read Weeds.txt"
			catch {file delete $fn}
		}
	}

	set fn "1989/Blaze.txt"
	if {[file exists $fn]} {
		after 100
		set o [open $fn r]
		set contents [string trim [read $o]]
		close $o
		if {$contents == "Ivy, Evermore"} {
			puts "Well done, you have finished the HJH Hunt 1."
			catch {file delete $fn}
		}
	}
}








