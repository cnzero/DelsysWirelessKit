function f = fPSD(data)
	% - PSD - Power Spectral Density with [welch] MATLAB built-in method
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature

	f = pwelch(data);
end