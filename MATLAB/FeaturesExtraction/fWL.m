function f = fWL(data)
	% - WL - Waveform Length
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	f = sum(abs(diff(data)))/length(data);
end