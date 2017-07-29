function smoveScissor(LINK)
	s = [];
	% - Fore - Open
	s = [s, sfingerFore(1, 837)];
	s = [s, sfingerFore(2, 2230)];
	s = [s, sfingerFore(3, 550)];
	% - Middle - Open
	s = [s, sfingerMiddle(1, 2235)];
	s = [s, sfingerMiddle(2, 2230)];
	s = [s, sfingerMiddle(3, 2280)];
	% - Ring - Closed
	s = [s, sfingerRing(1, 2000)];
	s = [s, sfingerRing(2, 2230)];
	s = [s, sfingerRing(3, 2240)];
	% - Little - Closed
	s = [s, sfingerLittle(1, 600)];
	s = [s, sfingerLittle(2, 2200)];
	s = [s, sfingerLittle(3, 550)];

	fprintf(LINK, [s, 'T100']);

	pause(0.1);

	s = [];
	% - Thumb - Open
	s = [s, sfingerThumb(1, 2000)];
	s = [s, sfingerThumb(2, 600)];
	fprintf(LINK, [s, 'T100']);
end