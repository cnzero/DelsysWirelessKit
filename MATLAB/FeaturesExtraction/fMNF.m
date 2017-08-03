function f = fMNF(data)
	% - MNF - MeaN Frequency
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature

	Fs = 2000; % - 2KHz sampling frequency
	% - MATLAB built-in method [meanfreq]
	f = meanfreq(data, Fs);
end





% ---------------------Vesion of Ding------------

% function fe = fMNF(data)
% 	% - MNF - MeaN Frequency
% 	% - Input:  [data], 1xN, data from a time-window.
% 	% - Output: [f],    feature
% 	Window_L = length(data);
% 	power_spectral = abs(fft(data, Window_L).^2)/Window_L;
% 	L = length(power_spectral);
% 	Fs = 2000; % Sampling frequency
% 	f = Fs/2*linspace(0, 1, L/2)';
% 	fe = meanfrequency(f, power_spectral(1:L/2));
% end

% function mnf = meanfrequency(f, p)
% 	% size(f) 64x1
% 	% size(p) 1x64
% 	% mnf = sum(p.*f)/sum(p);
% 	mnf = sum(f*p)/sum(p);
% end