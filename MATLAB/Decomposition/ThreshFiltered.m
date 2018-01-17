% function description:
%		1. two-order difference filtering
% 		2. threshold-value filtering
% Input:
%       [rd],  row vector, [nChs, 2000t]
%			[C],   threshold value multiplier
% Output:
%		[fd], filted data of two-order difference
%		[ffd], filted data of threhold
function [fd, threshold, ffd] = ThreshFiltered(rd, C)
	[nCh, L] = size(rd);
	% -- fd
	fd = [];
	for i=2:L-2
		fd = [fd, ...
			  rd(:, i+2)-rd(:, i+1)-rd(:, i)+rd(:, i-1)];
	end

	% -- ffd
	threshold = C * repmat(sqrt(mean(fd.^2, 2)), 1, L-3);
	ffd = (abs(fd)>threshold).*fd;
    threshold = threshold(1);
end