program bubble;
{
	Version 3.0.
}

uses sysutils;

const
	min_length = 10;
	max_length = 1000000;
	length_step = 2;
	depth = 100000;
	us_per_ms = 1000;

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
var 
	i:integer;
begin
	for i:=0 to length(a)-1 do
		a[i]:=random(1000);
end;

procedure dcsort(var a: array_type);

var 
	swap: boolean;
	l,i,a_len,half,odd: integer;
	b: real;
	a1,a2: array_type;
begin
	a_len:=length(a);
	if a_len mod 2 = 0 then begin
		half:=(round(a_len/2));
		setlength(a1,half);
		setlength(a2,half);
		for i:=0 to half-1 do a1[i]:=a[i]; 
		for i:=half to a_len-1 do a2[i-half]:=a[i]; 
		if half >2 then begin
			dcsort(a1);
			dcsort(a2);
		end;
	end else begin
		a_len:=a_len-1;
		odd:=(round(a_len/2));
		setlength(a1,odd);
		setlength(a2,odd+1);
		for i:=0 to odd do a1[i]:=a[i];
		for i:=odd+1 to a_len do a2[i-(odd+1)]:=a[i];
		if a_len >4 then begin
			dcsort(a1);
			dcsort(a2);
		end;
	end;
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


begin
	randomize;
	n:=min_length;
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
		writeln('list length:', n:1,' ','sort time in microseconds', sort_us:0:1,' ', num_reps:1);
		n:=length_step*n;
	until n > max_length;
end.



 



{save to desktop == GIT STASH, move to branch, made changes and i want to put them in a diff branch} {git push origin tty-- stash in master, pull in master}







