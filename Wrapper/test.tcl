#! /usr/bin/wish
exec stty raw -echo 
puts -nonewline stdout "GUI$ "
fconfigure stdin -buffering none -blocking 0
fileevent stdin readable console_execute
proc console_execute {} {
	set A [gets stdin]
	scan $A %c ascii
	puts "$ascii"
}
