canvas .d -height 200 -width 200
pack .d -side top
for {set w 10} {$w <= 180} {incr w 2} { 
	  .d create oval 10 10 $w $w -fill yellow
	    update
	      after 10
      }
.d create text 100 100 -text "GOLD COIN"
