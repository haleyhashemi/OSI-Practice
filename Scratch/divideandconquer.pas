program bubble;
{
	Version 3.0.
}

uses sysutils;

const
	min_length = 10;
	max_length = 100000;
	length_step = 2;
	depth = 100;
	us_per_ms = 1000;
	sort_threshold = 10;

type 
{
	array_type defines a new type, here we have an array that has arraylen
	number of values. arraylen has been defined as a constant above
}
array_type = array of real; 
	
{
	array_ptr is also a new type, the ^ denotes that this type is a POINTER to
	the previously defined type, which is an array
}
array_ptr = ^array_type; 

var
{
	These variables will take the type "Array_type" meaning they are going
	to refer to an array of arraylen characters long 
}
	a: array_type;
	j: integer;
	n: longint;
	start_time, tt : Qword;
	num_reps: integer;
	sort_us: real;


function clock_milliseconds:qword;
var
	tdt:TDateTime;
	tts:TTimeStamp;
begin
	tdt:=Now;
	tts:=DateTimeToTimeStamp(tdt);
	clock_milliseconds:=round(TimeStampToMSecs(tts));
end;

procedure randomizelist(var a: array_type);

{	
	Generate a random list of numbers up to 1000.

}
var 
	i:integer;
begin
	for i:=0 to length(a)-1 do
		a[i]:=random(1000);
end;

procedure dcsort(var a: array_type);

var 
	swap, keepgoing,a1done,a2done: boolean;
	l,i: integer;
	half,oddhalf,oneless,c,d:integer;
	b: real;
	a1,a2: array_type;
begin
{
	If the list is longer than threshold, split in two and sort each half then
	combine.
}
	if length(a) > sort_threshold then begin

{	Handle even and odd spplit, then call dcsort on two halves
}
		if length(a) mod 2 = 0 then begin
			half:=(round(length(a)/2));
			setlength(a1,half);
			setlength(a2,half);
			for i:=0 to half-1 do a1[i]:=a[i]; 
			for i:=half to length(a)-1 do a2[i-half]:=a[i]; 
			dcsort(a1);
			dcsort(a2);
		end else begin
			oneless:=length(a)-1;
			oddhalf:=round(oneless/2);
			setlength(a1,oddhalf+1);
			setlength(a2,oddhalf);
			for i:=0 to oddhalf do a1[i]:=a[i];
			for i:=oddhalf+1 to length(a)-1 do a2[i-(oddhalf+1)]:=a[i];
			dcsort(a1);
			dcsort(a2);
		end;

		keepgoing:=true;
		a1done:=false;
		a2done:=false;
		c:=0;
		d:=0;

{	
	After dcsort has been called on the two halves, combine the sorted
	lists into the original list. Combining the lists involves setting
	three flags. Keepgoing flag indicates that the lists are still be
	cycled through, and that neither list has reached its last
	element. The done flags are set when the coreesponding list has
	reached its last element, then the remaining sorted elements of
	the other sub list are added in that order to the original list. 

}
		for i:=0 to length(a)-1 do begin
			if keepgoing=true then begin
				if a1[c]<a2[d] then begin
					a[i]:=a1[c];
					inc(c);
				end else  begin
					a[i]:=a2[d];
					inc(d);
				end;
				
			end else if a1done=true then begin
				a[i]:=a2[d];
				inc(d);
			end else if a2done=true then begin
				a[i]:=a1[c];
				inc(c);
			end;
			if c>length(a1)-1 then begin
				keepgoing:=false;
				a1done:=true;
			end else if d>length(a2)-1 then begin
				keepgoing:=false;	
				a2done:=true;
			end;
		end;
{	
	If the list passed to the procedure has less than ten elements, it will go
	through the sort process. This sorting involves setting a swap flag that will
	only be false at the end of the loop if the list is totally sorted. To sort,
	compare the Nth element of list A with the proceeding element of the list, if
	its greater than the proceeding element, copy the element contents into the
	variable b, and set the Nth element to have the contents of the proceeding
	element. Then, copy the contents of b into the proceeding element.

}
		
	end else begin
		repeat
			swap:=false;
			for l:=0 to length(a)-1-1 do begin
				if a[l] > a[l+1] then begin
					b:=a[l];
					a[l]:=a[l+1];
					a[l+1]:=b;
					swap:=true;
				end;
			end;
		until not swap;
	end;


end;


begin

{	
	Set the first list length to the constant min_length, which can be
	changed. Repeat the following procedure until the list length reaches the
	maximum length constant. The number of reps for the list sorting is
	calculated by dividing the constant depth by the list length. The purpose of
	the number of reps is to provide an accurate value for the time it takes to
	sort lists. The shorter the list, the faster it is to sort. The number of
	times the proedure is repeated is proportional to the length of the list.
	Once the list length is equivalent to the constant, the number of reps drops
	to one. Save the original start time in a variable, once the randomize and
	sort procedures are called, use the current clock time to calculate the sort
	time. Increase the list length by multiplying the length with the length step
	variable. 
	
}
	randomize;
	n:=min_length;
	setlength(a,n);
	repeat 
		setlength(a,n);
		num_reps:=round(depth/n); 
		if num_reps=0 then num_reps:=1;
		start_time:=clock_milliseconds;
		for j:=1 to num_reps do begin 
			randomizelist(a);
			dcsort(a);
		end;
		tt:=clock_milliseconds-start_time;
		sort_us:=1.0*tt/num_reps*us_per_ms;
		writeln(n:1,' ',sort_us:0:1,' ', num_reps:1);
		n:=length_step*n;
	until n > max_length;

end.



 




