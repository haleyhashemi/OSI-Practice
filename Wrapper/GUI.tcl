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

