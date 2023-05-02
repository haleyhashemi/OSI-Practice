TREASURE HUNT INSTRUCTIONS
--------------------------

Greetings treasure-hunter. Below is a list of Linux commands that will help you
to the end of the treasure hunt. In the descriptions, we use "dirname" to mean
the name of a directory, and "filename" for the name of a file.

Move up one level in the directory tree:
cd ..

Move down one level into dirname in the directory tree:
cd dirname

List files in the current directory:
ls

Print the current full directory name to the console:
pwd

Move to your home folder:
cd ~

Print the contents of a file to the console:
cat filename

Print the string in double-quotes to the console:
echo "Hello World"

Write the string in double-quotes to a file called filename:
echo "Hello World" > filename

Execute a command in the terminal, where the command is "commandname":
commandname

Execute a local program file in the terminal:
./filename

Remove a file (also called deleting a file):
rm filename

Rename a file (also called moving a file):
mv filename newfilename

The treasure hunt requires that the tclsh and wish utilities be installed. At
your terminal prompt type the following commands. You should get the same 
answers printed below each command. If not, consult with the Hunt Author.

% which tclsh
/usr/bin/tclsh
% which wish
/usr/bin/wish

Assuming you have tclsh and wish installed in the correct location, start the
Hunt Manager process by executing the following command in the main Hunt
directory.

./manager.sh &

The Hunt Manager will run in the background as you hunt for clues, and when you
solve a puzzle, the manager will reward you by displaying a gold coin on your
computer screen.

The first clue of your hunt will be in a file called Hunt1.txt, Hunt2.txt, and
so on, depending upon which hunt you are going on. Find that file in one of the
Hunt directories and print its contents to the screen. You will see the first
clue.

During the hunt, any file with extension ".txt" is for you to print out with the
"cat" command. Any file with no file extension is for you to execute as a local
program file.

Enjoy the Hunt