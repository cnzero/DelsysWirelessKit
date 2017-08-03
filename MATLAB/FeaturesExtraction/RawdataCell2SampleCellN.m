% function description:
% 			from rawdataCell to sampleCell within N clusters
% Input:
% 			[rawdataCell], {[], [], ..., []};
% 							N [], means N clusters
% 							every [] matrix represents a "Source Data" matrix Lx(nChs)
% 							every row of [] is source data from nChs sensors
% 			[featuresCell], {'IAV', 'SSC', 'ZC'}, for example
% 			[LW], the Length of sliding Window
% 			[LI], the Length of Increasing window
% Output:
% 			[sampleCell], {[], [], ..., []};
% 						    N [], means N clusters, N labels
% 						    every [] matrix represents a "Sample" matrix Lm X (nFs*nChs)
%							every row of [] is sample in Feature Space or Input Space
% Add Parameters' default values.
function sampleCell = RawdataCell2sampleCellN(rawdataCell, fE)
	% featuresCell = fE.featuresCell;
	% LW = fE.LW;
	% LI = fE.LI;
	sampleCell = {};
	for n=1:length(rawdataCell)
		sampleCell{n} = Rawdata2SampleMatrix(rawdataCell{n}, fE);
	end
end