function smoveSnooze(LINK)
	s = [];
	% - Thumb
	s = [s, sfingerThumb(1, 550)];
	s = [s, sfingerThumb(2, 2230)];
	fprintf(LINK, [s, 'T100']);

	pause(0.1)

	s = [];
	% - Fore - Open
	s = [s, sfingerFore(1, 837)];
	s = [s, sfingerFore(2, 2230)];
	s = [s, sfingerFore(3, 550)];
	% - Middle - Open
	s = [s, sfingerMiddle(1, 2235)];
	s = [s, sfingerMiddle(2, 2230)];
	s = [s, sfingerMiddle(3, 2280)];
	% - Ring - Open
	s = [s, sfingerRing(1, 982)];
	s = [s, sfingerRing(2, 550)];
	s = [s, sfingerRing(3, 520)];
	% - Little - Open
	s = [s, sfingerLittle(1, 2139)];
	s = [s, sfingerLittle(2, 645)];
	s = [s, sfingerLittle(3, 2200	)];

	fprintf(LINK, [s, 'T100']);
end