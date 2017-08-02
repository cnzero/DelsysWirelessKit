% function description
% Input: 
% 		[samplesCell], nx1-Cell, every cell is a supervised cluster.
% 				samplesCell{n} -> [] matrix with M x (nCh x nFe)
% 									M, number of sliding window
% 									every row of [] is a sample in feature space. 
% 		[d], number of reduction dimension.

% Output:
% 		[centers], center of every conrresponding supervised cluster.
% 		[LDA_matrix], the dimension-reduction matrix with Principle Component Analysis.
% Attention:
% 		LDA algorithm do not need pre-processing.
function [LDA_centers, LDA_matrix] = LDA_Reduction(samplesCell, d)
	disp('LDA reduction is being conducted.');
	% xSw
	Width = size(samplesCell{1}, 2);
	xSw = zeros(Width);
	SUM = zeros(1, Width);
	for mv=1:length(samplesCell)
		Specimen_Counts = size(samplesCell{mv}, 1);
		center(mv, :) = mean(samplesCell{mv}, 1);
		temp = samplesCell{mv} - repmat(center(mv, :), Specimen_Counts, 1);
		xSw = xSw + temp'*temp;
		SUM = SUM + sum(samplesCell{mv}, 1);
	end
	Xmeans = SUM/length(samplesCell)/Specimen_Counts;

	% xSb
	xSb = zeros(Width);
	for mv=1:length(samplesCell)
		temp = center(mv, :) - Xmeans;
		xSb = xSb + temp'*temp;
	end

	% reduction matrix in LDA algorithm
	[old_Vector, old_Value] = eig(xSb, xSw);
	% sorting eigenvectors with eigenvalues descending.
	[Vector, Value] = sortVectorValue(old_Vector, old_Value);
	LDA_matrix = Vector(:, 1:d);

	LDA_centers = center * LDA_matrix;
end