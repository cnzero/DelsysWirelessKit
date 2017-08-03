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

		% - accuracy
		accuracyMatrix = []      % -- size(nClasses, nClasses)

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

			obj.n_components = min(obj.n_components, size(samplesCell{1}, 2));
			obj.projectM = Vector(:, 1:obj.n_components);
			obj.means = center;
			% LDA_centers = center * LDA_matrix;
		end

		function obj = SimpleTrainM(obj, samplesCell)
			% - there is no need to reduct dimensionality
			obj.samplesCell = samplesCell;
			obj.n_components = size(obj.samplesCell{1}, 2);
			obj.projectM = eye(obj.n_components);
			for mv=1:length(samplesCell)
				obj.means(mv, :) = mean(samplesCell{mv}, 1);
			end

			% -- Update the [accuracyMatrix]
			accuracyMatrix = zeros(length(obj.samplesCell));
			for mv=1:length(obj.samplesCell)
				xMatrix = obj.samplesCell{mv};
				M = size(xMatrix, 1); % - number of samples in that class.
				for n=1:M
					x = xMatrix(n, :);
					xR = x * obj.projectM;
					centerR = obj.means * obj.projectM;
					result = NearestRow(xR, centerR);
					% -- row as the main stream
					accuracyMatrix(mv, result) = accuracyMatrix(mv, result) + 1;
				end
				accuracyMatrix(mv, :) = accuracyMatrix(mv, :) / M;
			end
			obj.accuracyMatrix= accuracyMatrix;
		end

		function redX = reduct(obj, X)
			redX = X * obj.projectM;
		end

		function name = judge(obj, x, nameClasses)
			centerR = obj.means * obj.projectM;
			xR = x * obj.projectM;
			name = nameClasses{NearestRow(xR, centerR)};
			% obj.notify('eventJudged');
		end

		function Accuracy(obj, xMatrix, label)
			L = size(xMatrix, 1);
			nRight = 0;
			for n=1:L
				centerR = obj.means * obj.projectM;
				xR = xMatrix(n, :) * obj.projectM;
				result = NearestRow(xR, centerR);
				if result == label
					nRight = nRight + 1;
				end
			end
			obj.accuracyTrain = nRight/L; 
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