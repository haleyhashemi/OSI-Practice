#! /usr/bin/wish

# Create a label widget with the current time in some human-readable format, updated once per second. 
# I will set the variable unix to a human readable time.

# Here, I create a label that is packed (using pack) on the far left of my root window. 
label .tmlabel -text "Time:"
pack .tmlabel -side left

# Here, I create an entry space that will contain the value of a global variable, which will be
# presented to the screen. I pack it into the root window. The global variable it 
# is presenting is called "unixtime". I have made the width of the window 20, to the left of the 
# "Time:" label. 
entry .tm -textvariable unixtime -width 20
pack .tm -side left

# My quit button: when pressed, the exit command is executed.
button .exit -text Quit -command {
	exit
}
pack .exit -side right

# My while loop, which is always true (ie ; == 1). I set the variable unixtime to the following series of commands:
# First, clock seconds gives the unix time value at that exact second. The clock format
# command takes this string of numbers and then formats it into 
# a readable time stamp, which is formatted based on the characters that follow "-format".
# In this case, the -format refers to a time stamp that would look like Hours:Minutes:Seconds.
# After 1000, I call an update to the while loop, and then the loop is executed again.
# Therefore, every 1 second, the unixtime value changes. This value is reflected in the entry box above.

while {1} {
set unixtime [clock format [clock seconds] -format %H:%M:%S]
after 1000 
update
}


