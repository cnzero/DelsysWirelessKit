function moveRock(LINK)
	% - Fore - Closed
	fingerFore(LINK, 1, 2230, 100);
	fingerFore(LINK, 2, 55, 100);
	fingerFore(LINK, 3, 2219, 100);
	% - Middle - Closed
	fingerMiddle(LINK, 1, 600, 100);
	fingerMiddle(LINK, 2, 550, 100);
	fingerMiddle(LINK, 3, 550, 100);
	% - Ring - Closed
	fingerRing(LINK, 1, 2000, 100);
	fingerRing(LINK, 2, 2230, 100);
	fingerRing(LINK, 3, 2240, 100);
	% - Little - Closed
	fingerLittle(LINK, 1, 600, 100);
	fingerLittle(LINK, 2, 2200, 100);
	fingerLittle(LINK, 3, 550, 100);

	pause(0.2);
	% - Thumb
	fingerThumb(LINK, 1, 0, 100);
	fingerThumb(LINK, 2, 0, 100);

end