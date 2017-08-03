function feature = fIAV(data)
	% - IAV - Integrated Absolute Value
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	feature = sum(abs(data))/length(data);
end