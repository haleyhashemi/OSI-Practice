# [KSH] Nice work, code does exactly what it should. So you score ten out of
# ten. Now, I am going to make some further comments for your edification.
# First, note that it's easier to read the comments if you include a space after
# the hash symbol. Also, you should wrap your comments with a carriage return so
# they don't go off-screen on the right side, or get wrapped by the editor to
# look like a new line of code. This paragraph is wrapped to 80 characters wide.
# My editor will do this for me automatically, and I suspect the Sublime editor
# will do comment wrapping too. 

# [KSH] Here is your original comment:

#Method 1: Here, I am creating a variable and setting the contents of this variable to whatever the standard input is. 
#If the standard input, and subsequently the contents of the "box" variable are equal to the term "Wonderland"--
#The message "nice" will be printed to the terminal. T

# [KSH] Here it is wrapped and spaced:

# Method 1: Here, I am creating a variable and setting the contents of this
# variable to whatever characters come through the standard input. 
# If the string obtained through the standard input channel, 
# and subsequently the contents of the variable called "box", is equal to the term
# "Wonderland"-- The message "nice" will be printed to the terminal. 

#Notes from 05_10_22:  


set runtime 10000
set start [clock seconds]
set finish [expr $start + $runtime]
while {[clock seconds] < $finish} {
	after 1000
	if {[clock seconds] % 1000 == 0} {
	puts "Haley's hunt manager is running, time is [clock format [clock seconds]]"
	}

	puts "Welcome to your first question. These first three will assess whether you can move out of this limbo. What song from Evermore is about a divorce?"
	while { [gets stdin] != "Happiness" } {
		puts "Wrong! Try again."
		}
	puts "Correct!, now onto the next." 


	puts "What song named after a month did Taylor Swift do a cover of?"
	gets stdin  
	while { [gets stdin] != "September" } {
			puts "No, it's September"
			} 
	puts "Nice, next question."
	
	puts stdout "Which song from Folklore is sung from Betty's point of view?"
	set a Cardigan
	set b August
	set c Hoax
	set d Betty
	puts [list $a $b $c $d]
	while { [gets stdin] != $a } { 
		puts "No, try again."
		}

	puts "Good. Go to the lyrics of Wonderland, in 1989. Open the Wonderland.txt"

	gets stdin 
	while { [gets stdin] != "Gasoline" } {
		puts "No...Try again"
		} 
	puts "Good, now go to the reputation album and open up a text file named after the MA stadium Taylor plays shows at"

	puts "Please enter the answer here:"
	gets stdin 
	while { [gets stdin] != "Patriots" } {
		puts "No, but maybe you used two words. Just the name, please!" 
	}
	puts "Nice job. She was supposed to play a show for a specific album released in 2019, but it got cancelled due to covid. Head to that album and read the Summer.txt"

	gets stdin  
	while { [gets stdin] != "Blue"} {
		puts "Pick another color. A more sad one."
	}
	puts "Yes. One of her bluest albums, Folklore, has a file in it called Circus.txt. Please go read it. "

	
	gets stdin 
	while { [gets stdin] != "Yes"} {
		puts "Wrong. Try again."
	}
	puts "Yes it did. She ended up dissing a very famous rapper in her acceptance speech. Type his first name in below!"

	gets stdin 
	while {[gets stdin] != "Kanye"} {
		puts "no"}
	}


}
 

	
# Below is an example of the "if" clause. It is not a loop, and if you enter the wrong answer it will simply move on to the next line of code.
puts "What month comes before October?"
gets stdin ans 
if { $ans == "September" } {
	puts "Correct"
} elseif { $ans == "January"} {
	puts "The correct answer is September, but at least you didn't say April."
} else {
	puts "No, it's September."
}
 
# Here, I have printed to the screen using the puts stdout command asking the
# user to enter a string through standard input. Once the first string has been
# provided, a variable called "A" is created and will contain the string. The
# Second puts stdout command will then be executed, asking for another string
# from standard input. Then, once the second string has been provided, a
# variable called "B" is created, this contains the second string. The if
# expression will then compare the contents of variable A to the contents of
# variable B If they are equal, as in they match, "These match" is printed to
# the screen. If they are not equal, "These do not match" will be printed.

puts stdout "Enter string 1"
set A [gets stdin]
puts stdout "Enter string 2"
set B [gets stdin]
if { $A == $B } {
	puts "These match"
	} else { puts "These do not match"} 
	
# [KSH] When you run this program, and you get to the bit below, you will notice
# something different about the way it prints. The "nonewline" option tells Tcl
# not to write a newline character at the end of a string. But without the
# newline character, TCL won't write the string to stdout. It keeps the string
# in its own buffer, waiting for us to add more characters until we finally
# print a newline, and then in one go it will write all the characters to
# stdout. TCL behaves this way because the authors deemed this behavior to be
# more efficient in certain circumstances. Most of the time, however, this
# behavior is cumbersome. But it is what it is, so if we want our string to be
# printed without a newline, we must "flush" the socket. The result is a nice
# interface where you enter your answer right next to the question.

puts -nonewline stdout "Enter String 1: "
flush stdout
gets stdin A
puts -nonewline stdout "Enter String 2: "
flush stdout
gets stdin B
if { $A == $B } {
	puts "String \"$A\" is identical to string \"$B\"."
} else {
	puts "String \"$A\" is not the same as \"$B\"."
}





	}