set sum 0
for {set i 0} {$i < 100} {incr i} {
  set sum [expr $sum + $i * 2]
  puts "$i $sum"  
}