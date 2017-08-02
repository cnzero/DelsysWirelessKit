function f = fLogD(data)
	% - LogD - Log Detector
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	f = exp(mean(log(abs(data))));
end