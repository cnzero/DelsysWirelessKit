function f = fMAX(data)
	% - MAX
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	f = max(abs(data));
end