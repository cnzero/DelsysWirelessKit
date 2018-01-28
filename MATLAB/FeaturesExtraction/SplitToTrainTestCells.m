% function description:
% 		from one Sample cell to split into Train and Test part
% Input:
%		[SampleCell], 1xn cell of the sample space
%		[p], a scalar number between [1, 0), standing for percent of Train part
%
% Output:
%		[TrainCell], 1xn cell of the Train part in the sample space
%		[TestCell], 1xn cell of the Test part in the sample space

function [TrainCell, TestCell] = SplitToTrainTestCells(SampleCell, p)
	assert( (0 < p) && (p<=1.0))

	TrainCell = {};
	TestCell = {};
	if p == 1.000
		TrainCell = SampleCell;
		TestCell = {};
	else
		for nM = 1:length(SampleCell)
			SampleMatrix = SampleCell{nM};
			Nsamples = size(SampleMatrix, 1); % every row stands for a sample
			% Pseudo Code
			n = round(p*Nsamples);
			rowRandPerm = randperm(Nsamples);
			rowTrain = rowRandPerm(1:n);
			rowTest = rowRandPerm(n:end);

			TrainCell{nM} = SampleMatrix(rowTrain, :);
			TestCell{nM} = SampleMatrix(rowTest, :);
		end
	end
end