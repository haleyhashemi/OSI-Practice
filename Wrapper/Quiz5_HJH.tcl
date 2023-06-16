
# (1) Provide a file name entry box with a label "File:" to the left of it. The entry box should show me the value of a global variable "fn".

label .fnopen -text "File:" 
pack .fnopen -side left

entry .fn -textvariable fn -width 30
pack .fn -side left

# (2) Set fn to a default value "~/Desktop/Infile.txt".

set fn "~/Desktop/Infile.txt"

#(3) A Browse button that allows me to select a file and assign its name to fn.

button .browse -text Browse -command {
	set fn [tk_getOpenFile]
}
pack .browse -side left

# (4) A Read button that read the file "fn", counts the number of words in the file, 
# and prints a message to the console stating how many words are in the file.

button .read -text Read -command {
	set f [open $fn r]
	set contents [ split [string trim [read $f]] { }]
	puts "$fn contains [llength $contents] words."
	close $f
}
pack .read -side left

#(5) A Quit button that exits the program.

button .exit -text Quit -command {
	exit
	}

pack .exit -side right



