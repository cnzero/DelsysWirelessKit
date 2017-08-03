function f = fNZD(data)
	% - NZM - Non Zero Median
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	data_nonzero = data(find(data ~= 0));
    f = median(data_nonzero);	
end