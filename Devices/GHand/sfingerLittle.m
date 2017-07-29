function s = sfingerLittle(n, p)
% Description: move two joints of Thumb with specific position and time;
% Input:  	[LINK], handle of serial device
% 			[n], joint sequences, there are two joints in Thumb
% 				1, near palm
% 				2, far from the palm
% 			[p], relative position of the steering engine
% 			[t], [ms] how much time to complete [p]-position
% Output:
	switch n
	case 1
		s = ['#16P', num2str(p)];
	case 2
		s = ['#28P', num2str(p)];
	case 3
		s = ['#30P', num2str(p)];
	end
end