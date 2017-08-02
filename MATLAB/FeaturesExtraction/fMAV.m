function f = fMAV(data)
	% - MAV - Mean Absolute Value
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	f = mean(abs(data));
end