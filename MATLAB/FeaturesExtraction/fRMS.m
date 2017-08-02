function f = fRMS(data)
	% - RMS - Root Mean Square
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	f = sqrt(mean(data.^2));	
end