function fingerMiddle(LINK, n, p, t)
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
		fprintf(LINK, ['#1P', num2str(p), 'T', num2str(t)] );
	case 2
		fprintf(LINK, ['#31P', num2str(p), 'T', num2str(t)] );
	case 3
		fprintf(LINK, ['#2P', num2str(p), 'T', num2str(t)] );
	end
end