classdef PCA < handle
	% - write this class like [sklearn.decomposition.PCA](http://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html)
	properties
		n_components      % - dimensionality of reducted features space
		whiten 			  % - true or false to whiten PCA-reducted samples
						  %  - for [whiten=true], labels are necessary
		samplesCell = {}  % - a cell of 1xN matrix in feature space
						  % - every matrix is a labeled cluster []
						  % - [] with MxD
						  % - in the DXD feature space,
						  % - there are M samples
						  % - every row of [] stands for a sample.  
		samplesMatrix = []% - for unsupervised dimensionality, 
						  % - there is no need for known labels
		pcM = []			  % - principal component projection matrix

		explained_variance       % - the amount of variance explained by each of the selected components
		explained_variance_ratio % Percentage of variance by each of the selected components
		means			  % -- size(n_classes, n_features)


	end

	events
	end

	methods
		% - constructor
		function obj = PCA(params)
			obj.n_components = params.n_components
			obj.whiten = params.whiten;
		end

		function obj = TrainM(obj, samplesCell)
			disp('PCA reduction is being conducted.');
			obj.samplesCell = samplesCell;
			trainX = [];
			for n=1:length(samplesCell)
				Xn = samplesCell{n};
				trainX = [trainX; Xn];
			end
			% -- unsupervised PCA dimensionality reduction for [trainX]
			% - 1. zero-meaning
			[M, N] = size(trainX);
			obj.means = mean(trainX, 2);
			trainX = trainX - repmat(obj.means, 1, N);
			covX = cov(trainX');
			[oldVector, oldValue] = eig(covX);
			[PC, V] = sortVectorValue(oldVector, oldValue);

			obj.pcM = PC(:, 1:obj.n_components);
			obj.explained_variance = V;
		end


		function redX = Reduct(obj, X)
			[M, N] = size(X);
			redX = (X - repmat(obj.means, 1, N)) * obj.pcM;
		end

		function variance = Get_variance(obj)
		end

		function score = Score(obj)
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
