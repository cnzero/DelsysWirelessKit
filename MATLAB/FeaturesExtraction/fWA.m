function f = fWA(data)
	% - WA - Willison Amplitude
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	Threshold = 0;
	data_size = length(data);
	f = 0;
	if data_size == 0
		f = 0;
	else
		for i=2:data_size
			difference = data(i) - data(i-1);
			if abs(difference)>Threshold
				f = f + 1;
			end
		end
		f = f/data_size;
	end
end