classdef LDA < handle
	% - write this class like [sklearn.discriminant_analysis.LinearDiscriminatAnalysis](http://scikit-learn.org/stable/modules/generated/sklearn.discriminant_analysis.LinearDiscriminantAnalysis.html#sklearn.discriminant_analysis.LinearDiscriminantAnalysis
	properties
		n_components = 2 % - default dimension reduction -> 2
		samplesCell = {}  % - a cell of 1xN matrix in feature space
						  % - every matrix is a labeled cluster []
						  % - [] with MxD
						  % - in the DXD feature space,
						  % - there are M samples
						  % - every row of [] stands for a sample.  

		projectM			  % -- Projection dimensionality reduction matrix
		explained_variance_ratio % Percentage of variance by each of the selected components
		means			  % -- size(n_classes, n_features)

	end

	events
		eventJudged
	end

	methods
		% - constructor
		function obj = LDA(n_components)
			obj.n_components = n_components;
		end

		function obj = trainM(obj, samplesCell)
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

			obj.projectM = Vector(:, 1:obj.n_components);
			obj.means = center;
			% LDA_centers = center * LDA_matrix;
		end

		function redX = reduct(obj, X)
			redX = X * obj.projectM;
		end

		function name = judge(obj, x, nameClasses)
			centerR = center * obj.projectM;
			xR = x * obj.projectM;
			name = nameClasses{NearestRow(xR, centerR)};
			obj.notify('eventJudged');
		end
	end
end


% function description
% sorting eigenvectors with eigenvalues descending.

% Vector, matrix of eigenvectors
% Value, diagonal matrix of eigenvalues
function [new_Vector, new_Value] = sortVectorValue(Vector, Value)
	val = diag(Value);
	[new_val, idx] = sort(val, 'descend');
	for i=1:size(Vector,2)
		new_Vector(:, i) = Vector(:, idx(i));
	end
	new_Value = diag(new_val);
end

function nRow = NearestRow(sample, centers)
	for j=1:size(centers, 1)
		d(j) = norm(sample - centers(j,:));
	end
	nearest = sort(d, 'descend');
	nRow = find(d==nearest(end));
end