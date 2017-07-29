function smoveRock(LINK)
	s = [];
	% - Fore - Closed
	s = [s, sfingerFore(1, 2230)];
	s = [s, sfingerFore(2, 550)];
	s = [s, sfingerFore(3, 2219)];
	% - Middle - Closed
    s = [s, sfingerMiddle(3, 550)];
    s = [s, sfingerMiddle(2, 550)];
	s = [s, sfingerMiddle(1, 600)];
	
	
	% - Ring - Closed
	s = [s, sfingerRing(1, 2000)];
	s = [s, sfingerRing(2, 2230)];
	s = [s, sfingerRing(3, 2240)];
	% - Little - Closed
	s = [s, sfingerLittle(1, 600)];
	s = [s, sfingerLittle(2, 2200)];
	s = [s, sfingerLittle(3, 550)];

	fprintf(LINK, [s, 'T10']);

	pause(0.2);

	s = [];
	% - Thumb
	s = [s, sfingerThumb(1, 2000)];
	s = [s, sfingerThumb(2, 600)];
	fprintf(LINK, [s, 'T50']);
end