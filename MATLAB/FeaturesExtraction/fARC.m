function f = fARC(data)  
	% - ARC - Auto Regression Model Coefficients
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	order = 4;              
	cur_xlpc = real(lpc(data,order)');
	f = -cur_xlpc(order+1,:);
end


% % % ---- To be tested