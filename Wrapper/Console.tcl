#! /usr/bin/wish

# Your job is to take the terminal shell program you have developed in the course of our
# work so far, whatever it may be, and provide a GUI wrapper for the shell. The shell
# will continue to behave as before in the terminal, but it will be accompanied by
# another window that contains buttons, labels, and entries that allow the user
# to excecute the commands with the mouse. In the shell, you type in a file name.
# In the GUI, you press a button and browse for the file name. 

# This script illustrates the creation of buttons, labels, and entries using the
# Tk graphical tool kit that works with the Tcl tool command language. We can
# start the program either from the terminal, with the help of the hash-bang
# that calls the wish Windowing Shell program, or with "wish GUI.tcl".

# Create a button with text in the button and a command that is executed when we
# press the button. Windows in Tk have a heirarchical naming system, where the
# root of the window system is ".". A "window" is a rectangular construction on
# the screen that we can move around and adjust with our mouse. Within windows
# we can pack graphical devices, such as buttons, labels, entries, checkboxes,
# and menubuttons. We call these devices "widgets". Widgets are named with the
# same heirarchical system. We start with ".hello", a widget "hello" within the
# root window ".".
if {[gets stdin] == "console init"} {

button .hello -text Hello -command {puts "Hello World"}
pack .hello -side left

# We create a label that presents text in our root window. We pack it into the
# root window, pushing it to the left. The widget does not appear on the screen
# until we place it, which we can do with various placement managers. The one we
# use here is the "pack" manager. There is also a "grid" manager. For now, just
# use "pack".
label .fnlabel -text "File:" 
pack .fnlabel -side left

# An entry that presents the value of a global variable. All widgets operate
# upon global variables. Even if you create a widget within a procedure, the
# variable you name in the widget declaration will be implemented by the widget
# at the global scope.
entry .fnentry -textvariable infile_name -width 30
pack .fnentry -side left

# This program is running right now at the global scope, so I can set
# infile_name right now. But if this code were running within a procedure, I'd
# have to do "global infile_name".
set infile_name GUI.tcl

# Here is a more complicated button, in which the commmand is specified in
# braces and refers to our global infile_name variable, which it uses to read
# the named file and print its contents to the terminal.
button .read -text Read -command {
	set f [open $infile_name r]
	set contents [read $f]
	close $f
	puts $contents
}
pack .read -side left

# Browse for a file name. We use the tk_getOpenFile routine to open a file
# browser, get a file name, and return the name.
button .browse -text Browse -command {
	set infile_name [tk_getOpenFile]
}
pack .browse -side left

# Quit button, when selected this will execute the exit command.

button .exit -text Quit -command {
	exec stty -raw echo
	exit
	}

pack .exit -side right


# Define the prompt.
set prompt "GUI$ "

# Reconfigure the terminal using the stty command. We want to configure
# the standard input and output so that key presses are passed immediately
# into the input buffer and not echoed by the terminal.
exec stty raw -echo 
puts -nonewline stdout $prompt

# Use the "fconfigure" command to configure the stdin channel so that it does
# not block our process when we try to read from it. We set the blocking flag to
# zero. We also set "buffering" to "line", even though "line-by-line" buffering
# is the default for stdin. The stdin channel will become "readable" when a
# complete line of text has been written into the other end of the channel by
# the terminal or whatever external process is connected to the other end of
# stdin. By "a complete line of text" we mean a line of text terminated with a
# newline character.
fconfigure stdin -buffering none -blocking 0

# When the standard input has a complete line of text ready to read out, we say
# it has become "readable". When stdin is readable, we want to read out the line
# and execute the command therein. We set up a "file event" to call our
# command-handling procedure, which in this case we name "console_execute".
fileevent stdin readable console_execute

}
# Set a global command variable to an empty string.
set command ""

# Start a list of commands, it's empty at first. We append a command to the list
# only when we are about to execute the command, having received a newline, and
# only if the command contains something other than just white spaces.
set command_list [list]
set leftstate 0
set match 0
set newcommand ""
# Set up a global console state variable.
set cstate "insert"
set c ""
set indexstate "firstup"
set index ""
set length [llength $command_list]
# Here is console execute, a procedure that reads the standard input, executes
# the command at the global scope with "uplevel", prints any non-empty result
# and catches errors.
proc console_execute {} {
	global command command_list cstate leftstate c indexstate index prompt
	if {[catch {
	
		# The stdin channel is readable, so read exactly one character.
		set c [read stdin 1]
		
		# The character should not be empty. If it is, generate an error
		# so we can investigate.
		if {$c == ""} {
			error "Received empty string from stdin."
		} elseif {$c == "\n"} {
		
		# If we receive a newline, then we will execute whatever command we have
		# accumulated so far. We capture the "exit" command locally so that we
		# can restore the terminal before exiting. We print the result of the
		# commmand, but only if it's not empty. Empty results are what we get
		# when the user keeps pressing return. We clear the command string,
		# restore the console state to "insert", and printe a new prompt.
			puts stdout ""			
			set command [string trim $command]
			set leftstate 0
			if {$command == "exit"} {
				exec stty -raw echo
				exit
			}
			if {$command != ""} {lappend command_list $command}
			set result [uplevel $command]

			if {$result != ""} {puts stdout $result}
			set command ""
			set cstate "insert"
			puts -nonewline $prompt
		} else {
		# The character is neither a newline nor empty. Handling alpha-numeric
		# characters is easy: we print them straight to the screen. But the
		# delete and escape sequence characters are more complicated. We will
		# use our "cstate" to navigate through this complexity. First we determine
		# the ASCII value of our character.
			scan $c %c ascii
	
			# The escape state indicates that our previous state was insert
			# and our previous character was an escape character (decimal 27).
			# If we now get a left bracket (decimal 91), we move to the arrow
			# state. If we get an escpe, we go back to the insert state. If
			# we get any other character, we make a bell sound (hex 07) and
			# go back to the insert state.
			if {$cstate == "escape"} {
				if {$ascii == 91} {
					set cstate "arrow"
				} elseif {$ascii == 27} {
					set cstate "insert"		
				} elseif {$ascii == 84} {
					puts "OUCH!"
					set cstate "insert"
				} else {
					puts -nonewline "\x07"			
					set cstate "insert"
				}
				
			} elseif {$cstate == "arrow"} {
			# In the arrow state, we are waiting for a character to specify
			# which arrow. If we get a valid arrow specifier, we call the
			# appropriate arrow handling routine.
		
				switch $c {
					"A" {
						console_up
					}
					"B" {
						console_down 
					}
					"C" {
						if {$leftstate > 0} {
							console_right
						}
					}
					"D" {
						console_left
					}
					default {error "Unknown arrow argument \"$c\"."}
				}
				set cstate "insert"

			} elseif {$cstate == "insert"} {
				if {$ascii == 3} {
					exit
				} elseif {$ascii == 27} {
				# If we see an escape (decimal 27), we enter the escape state
				# and do nothing else.
					set cstate "escape"
					
				} elseif {$ascii == 127} {
				# If we get a delete (decimal 127) and we have at least one
				# character in our commmand, we delete the last character from our
				# command and remove it from the terminal too, with a "backspace,
				# space, backspace".
					delete
					
					
				} else {
				# It's just a simple character, so print it and add it to our
				# command.
	
					if {$leftstate > 0} {
						insert_cmd
						puts -nonewline $command
						for {set i 0} {$i < $leftstate} {incr i} {
							backspace
						}
						
					} else {
						puts -nonewline stdout $c
						append command $c
					}
				}
			} else {
				error "Unknown console state \"$cstate\"."
			}
			flush stdout
		}
	} error_result]} {
		puts "ERROR: $error_result"
		set command ""
		puts -nonewline $prompt
		set cstate "insert"
	}

	flush stdout
}



# If the command list is not empty, enact the remove space command.
# If the global variable "length" is equal to the command list,
# and the index state is "firstup", the uparrow command will print the 
# last element of the command list to the terminal, setting the 
# index state to "nextup", and decrementing the index itself to point to 
# the next previous command in the list. Regardless of index state,
# set the length variable equal to the length of the command list.
# If the index state for the next up arrow press is "nextup", the 
# index will keep decrementing until the first command in the list shown.
# Once the very first command is shown, another arrow press will set the index to point to the 
# most recent command at the end of the list.
# If the up arrow is followed by a carriage return, which appends a new command 
# to the command list, then the length variable is no longer equal to the 
# original length of the list, which then triggers the index to be reset
# to point to the new final element of the list when the next up arrow is pressed.


proc console_up {} {
	global command command_list indexstate index length c
	if {$indexstate == "firstup"} {
			set index [llength $command_list]
			set command [lindex $command_list $index-1]
			puts -nonewline $command
			set indexstate "nextup"
	} elseif {$indexstate == "nextup"} {
		if {$length == [llength $command_list]} {
			if {$index > 0} {
				removespace_cmd
				incr index -1
				set command [lindex $command_list $index]
				puts -nonewline $command
			} elseif {$index == 0} {
				removespace_cmd
				set command [lindex $command_list $index]
				puts -nonewline $command
			}
		} else {
			removespace_cmd 
			set index [llength $command_list]
			set command [lindex $command_list $index]
			puts -nonewline $command
			set indexstate "nextup"
		}
	}
	
	set length [llength $command_list]
}
	
	
	


# Handle the down arrow. Uses an index to point to the more recent command in
# the command list, functions in an opposing manner to the up arrow.

proc console_down {} {
	global command command_list indexstate index length
	if {$command_list != ""} {
		removespace_cmd
	}
	if {$indexstate == "nextup"} {
		incr index 1
		set command [lindex $command_list $index]
		puts -nonewline $command
		if {$index > [expr [llength $command_list] +1]} {
			set indexstate "firstup"
		}
	}
}
		
			

# Remove the most recent command string from the standard output. Call the
# global variables command and command_list For every character of the
# command contents, which has been printed to the screen, Set the command
# to be one less character, and put a back space.
proc removespace_cmd {} {
	global command leftstate
	for {set i 0} {$i < ([string length $command] - $leftstate)} {incr i} {
		puts -nonewline "\x08\x20\x08"
	}
}



proc clear {} {
	global command leftstate
	for {set i 0} {$i < [string length $command]} {incr i} {
		puts -nonewline "\x08\x20\x08"
	}
}



# Insert takes a new character, assuming the cursor has navigated to somewhere
# within the text in the command line and inserts this character into the
# text by saving the original command, removing it, rewriting it, and
# printing the new command with the inserted character to the screen

proc insert_cmd {} {
	global leftstate command c command_list newcommand
	if {$leftstate < [string length $command]} {
		set index [expr [string length $command] - $leftstate]
		append newcommand [string range $command 0 [expr $index -1]]
		append newcommand $c	
		append newcommand [string range $command $index end]
		removespace_cmd
		set command $newcommand
	} else {
		append newcommand $c
		append newcommand $command
		removespace_cmd
		set command $newcommand
	}
	set newcommand ""
}

# Console left navigates through the command line, incrementing the leftstate
# variable to keep track of the location of the cursor. The left cursor
# cannot move any more spaces to the left if it is in front of the command
# line text.
proc console_left {} {
	global leftstate command
	if {$leftstate < [string length $command]} {
		puts -nonewline "\x08"
		incr leftstate 1
	}
	
}


# Creates a backspace (moves the cursor one place to the left) in text command
# line.
proc backspace {} {
	puts -nonewline "\x08"
}

# Deletes the prveious character in the text command line.


# If deleting in the middle of a string:
# Set the index to point to the character being deleted. Append to a new command
#the first half of the string up to the character, and the second half of the string which is 
#after the character. Remove all of the characters from the command line, and print 
#this new command to the string. Set the left stys
proc delete {} {
	global command
	puts -nonewline "\x08\x20\x08"
}


#Right arrow decrements the leftstate, removes the entire command from the
#screen, rewrites it, then navigates the cursor to the new spot in the text
#(one space to the right)

proc console_right {} {
	global command  leftstate 
	removespace_cmd
	puts -nonewline $command
	incr leftstate -1 
	if {$leftstate > 0} {
		for {set i 0} {$i < $leftstate} {incr i} {
			backspace
		}
	}
}


 
#now DO THE DELETE. Execution time and list

