function movePaper(LINK)
	% - Thumb
	fingerThumb(LINK, 1, 0, 100);
	fingerThumb(LINK, 2, 0, 100);
	pause(0.2);
	
	% - Thumb
	fingerFore(LINK, 1, 0, 100);
	fingerFore(LINK, 2, 0, 100);
	fingerFore(LINK, 3, 0, 100);
	% - Middle
	fingerMiddle(LINK, 1, 0, 100);
	fingerMiddle(LINK, 2, 0, 100);
	fingerMiddle(LINK, 3, 0, 100);
	% - Ring
	fingerRing(LINK, 1, 0, 100);
	fingerRing(LINK, 2, 0, 100);
	fingerRing(LINK, 3, 0, 100);
	% - Little
	fingerLittle(LINK, 1, 0, 100);
	fingerLittle(LINK, 2, 0, 100);
	fingerLittle(LINK, 3, 0, 100);

end