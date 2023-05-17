#! /usr/bin/tclsh

puts "Enter a number:"
set x [gets stdin]
if {![string is integer $x]} {
	puts "Value \"$x\" is not an integer."
	exit
}
puts "Enter another number:"
set y [gets stdin]
set xy [expr $x * $y]
puts $xy

