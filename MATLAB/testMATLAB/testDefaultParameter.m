% Purpose:
% 			to test and use the variable-length argument
% [varargin], a default [cell] parameter in MATLAB



function v = testDefaultParameter(varargin)
	v = varargin;
	for i=1:nargin
		disp(['input argument', num2str(i), ': ']);
		disp(varargin(i));
	end
end

