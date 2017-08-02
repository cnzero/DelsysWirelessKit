% function description:
% Input:
% 		[Rawdata], nCh X (2000t)
% 						rawdata from selected sensor channels
% 		[featuresCell], a cell of strings, which are the name of selected features
% 						and also transform them as their features extraction functions' name
% 		[LW], the length of a features-extraction window
% 		[LI], the increasing length of a features-extraction window

% Output:
%		[sampleMatrix], (nCh*nFe) X M, looks like
% 			(ch1f1)1, (ch1f2)1, (ch1f3)1, ..., (ch2f1)1, (ch2f2)1, (ch2f3)1
% 			(ch1f1)2, (ch1f2)2, (ch1f3)2, ..., (ch2f1)2, (ch2f2)2, (ch2f3)2
% 			. . . . . .
% 			. . . . . .
% 			(ch1f1)M, (ch1f2)M, (ch1f3)M, ..., (ch2f1)M, (ch2f2)M, (ch2f3)M
% 			Representation Explanation:
% 				nCh, the number of selected Channels
% 				nFe, the number of selected Features
% 				M,   the number of sliding windows
% 				nWindows, the number of sliding windows
% Input parameters setting and default values
% 			Style: varargin = {Rawdata, featuresCell, LW, LI}
function sampleMatrix = Rawdata2SampleMatrix(Rawdata, featuresCell, LW, LI)
	% sliding window algorithm
	[nCh, L] = size(Rawdata);
	nWindows = floor(1+(L-LW)/LI);
	nFeatures = length(featuresCell);
	sampleMatrix = [];
	for wd=0:nWindows-1
		f_row = [];
		for ch=1:nCh
			f_ch_row = [];
			data_wd = Rawdata(ch, wd*LI+1:wd*LI+LW);
			for fe=1:nFeatures
				function_handle = str2func(['f',featuresCell{fe}]);
				f_ch_row= [f_ch_row, function_handle(data_wd)];
			end
			f_row = [f_row, f_ch_row];
		end
		sampleMatrix = [sampleMatrix; ...
						f_row];
	end
end


