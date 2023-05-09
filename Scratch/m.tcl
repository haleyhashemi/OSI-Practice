#! /usr/bin/tclsh
	

#Method 1: Here, I am creating a variable and setting the contents of this variable to whatever the standard input is. 
#If the standard input, and subsequently the contents of the "box" variable are equal to the term "Wonderland"--
#The message "nice" will be printed to the terminal.

puts stdout "what is the taylor swift song based off a children's book?"
set box [gets stdin]
if { $box == "Wonderland" } {
	puts nice
} else {
	puts no
} 

#Here, I have executed the get standard input command. The string that comes from standard input will be the contents of the "ans" variable.
#If the contents (whatever the standard input string was) of the "ans" variable are equivalent to "September"--
#the "correct" message will be printed to the screen. If it is incorrect, the "no" message will be printed.
puts "What named after a month did Taylor Swift cover?"
gets stdin ans 
if { $ans == "September" } {
	puts correct} else {
		puts no}

#Here, I have printed to the screen using the puts stdout command asking the user to enter a string through standard input.
#Once the first string has been provided, a variable called "A" is created and will contain the string.
#The Second puts stdout command will then be executed, asking for another string from standard input.
#Then, once the second string has been provided, a variable called "B" is created, this contains the second string.
#The if expression will then compare the contents of variable A to the contents of variable B
#If they are equal, as in they match, "These match" is printed to the screen. If they are not equal, "These do not match" will be printed.
puts stdout "Enter string 1"
set A [gets stdin]
puts stdout "Enter string 2"
set B [gets stdin]
if { $A == $B } {
	puts "These match"
	} else { puts "These do not match"} 

