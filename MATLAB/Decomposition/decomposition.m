function [FM, training_accuracy] = decomposition()
	clear,close all,clc

	% add necessary directory path 
	path(path, 'Classification');
	path(path, 'EMGrawdata');
	path(path, 'Main');
	path(path, 'Preprocessing');
	channel = 2; % based on the single channel recognition.
	
	H = load('BasicInform.mat');

	%----Database seems to be very necessary.----------


	%--Part one: Filtering with second order.
	%-rawdata
    rd = H.Data_EMG(channel, :);
	L = size(H.Data_EMG, 2);
	fd = [];
	for a=2:L-2
		fd = [fd, ...
			  rd(a+2)-rd(a+1)-rd(a)+rd(a-1)];
	end

	%- Compute the threshold value.
	C = 2.1;
	hold_value = C*sqrt(sum(fd.^2)/length(fd));

	ffd = [];
	for a=1:length(fd)
		if abs(fd(a))<hold_value
			ffd = [ffd, 0];
		else
			ffd = [ffd, fd(a)];
		end
	end

	% L = floor(length(rd)/3);
	subplot(4,1,1)
	plot(rd)
	title('raw data of one channel')

	subplot(4,1,2)
	plot(fd)
	title('filted data with two orders')

	subplot(4,1,3)
	plot(ffd)
	title('filted data with threshold')

	% Peaklist(fd, hold_value);
	[Samples_x, Samples_y] = Peaklist(ffd, hold_value, 10);
    
    % plot some samples to check the results
    figure
    plot(Samples_y(10, :), 'r');
    hold on;
    plot(Samples_y(20,:), 'k');
    hold on;
    plot(Samples_y(30,:), 'b');
    hold on;
    plot(Samples_y(40,:), 'g');
    hold on;
    plot(Samples_y(50,:), 'y');
    hold on;
	plot(Samples_y(60,:), 'c');
	hold on;
	plot(Samples_y(70,:), 'm');

	% Mixture of Gaussian models. [GMM]
	% options = statset('Display', 'final', 'MaxIter',5);
	% save('data.mat', 'Samples_y');
	

	% GMmodel = fitgmdist(Samples_y, 5)
	% When you directly compute GMM as above, ill-conditioned covariance happends.
	% Reason-1: some of the predictors of your data are highly correlated.
	% Solution: PCA for decoupling in GMM
	coeff = pca(Samples_y);
	Samples_y_pca = Samples_y * coeff;
	
	% kmeans - 
	% no need for PCA decoupling
	n_c = 8; % -- number of classes
	[idx, center, distance_within] = kmeans(Samples_y, n_c); %%%% -- key step ----
	% length(find(idx1==2))

	% figure templates of M MUAPs
	class_label = cell(n_c, 1);
	figure
	for m=1:n_c
		class_label{m} = Samples_y(idx==m, :);
		subplot(3,4,m);
		for s=1:size(class_label{m}, 1)
			plot(class_label{m}(s,:));
			hold on;
		end
	end


	% decomposition to 5 MUAP sequences
	% Samples_x, qxn
	% Samples_y, qxn
	% every spike, 1xn,
	% n_c
	% idx, qx1
	[q, n] = size(Samples_y);
	MUAP = zeros(length(fd), n_c);
	% 192642x5

	for i=1:q
		spike = Samples_y(i, :)';
		% nx1
		x = Samples_x(i,:)';
		% nx1
		MUAP(x, idx(i)) = spike;
	end

	% % draw these MUAPs
	% figure
	% for c=1:n_c
	% 	subplot(n_c, 1, c);
	% 	plot(MUAP(:, c));
	% end
	movement_data = clipping(MUAP');
	% 5x1, cell
    % from rawdata to Features matrix cell. 
	FM = FMmatrix(movement_data);
	% 5x1, cell

	% LDA to verify the training set accuracy.
	training_accuracy = LDA_classfy(FM);





% function description
% to get the ultimate samples matrix
%    Peaks1
% 	 Peaks2
% 	 Peaks3
% 	 ......
% 	 Peaks_q  --->qxn

% Input:
%		the filted raw EMG data.
% Output:
% 		the ultimate samples matrix: x,y
function [MUAPx, MUAPy] = Peaklist(alist, hold_value, n)
	%-Mix the up and down peaks 
	[up_peak_index, down_peak_index] = PeaksCrossPoints(alist, hold_value);
	
	%--qx2
	%-mixing the upper and down peaks with the right order.
	peaks_index = sortrows([up_peak_index; ...
						   down_peak_index]);

	%-remove all zero-pair.
	% zero elements locates in the front part.
	% --1 method
	non_zero_index = 1;
	while(peaks_index(non_zero_index,1)==0)
		non_zero_index = non_zero_index + 1;
	end
	% slicing
	peaks_index = peaks_index(non_zero_index:size(peaks_index,1),:);

	MUAPx = []; % qx8
	MUAPy = [];	% qx8
	% from [strat_point end_point] to samples matrix.
	for i=1:size(peaks_index,1)
		Xs = Peaks_n(alist, peaks_index(i,1), peaks_index(i,2), n);
		MUAPx = [MUAPx;
				 Xs];
	end
	% overlapping cancle
    n_row = size(MUAPx, 1);
    MUAPx = Overlap(alist, MUAPx, n);
    new_n_row = size(MUAPx, 1);
    while ( n_row ~= (new_n_row+1) )
        n_row = size(MUAPx, 1);
        MUAPx = Overlap(alist, MUAPx, n);
        new_n_row = size(MUAPx, 1);
    end
	% ready to get MUAPy on position MUAPx
	for i=1:size(MUAPx, 1)
		y_row = [];
		for j=1:size(MUAPx, 2)
			y = alist(MUAPx(i,j));
			y_row = [y_row, y];
		end
		MUAPy = [MUAPy; ...
				 y_row];
	end

%------------------Function description
% find the upper peaks
% find the down peaks
%-Input: a sequent signal(t)
%		 hold_value, a positive threshold.
%-Output: 
% 	 x coordinates
%	 up_cross_p-->nx2[startp, endp], every row contains two cross point above hold_value
%	down_cross_p->nx2[startp, endp], every row contains two cross points under hold_value
function [up_cross_p, down_cross_p] = PeaksCrossPoints(alist, hold_value)
	L = length(alist);
	up_cross_p = zeros(L,2);
	down_cross_p = zeros(L,2);
	up_c = 1;
	dn_c = 1;

	for i=1:L-1
		d1 = alist(i) - hold_value;
		d2 = alist(i+1) - hold_value;

		d3 = alist(i) + hold_value;
		d4 = alist(i+1) + hold_value;

		if (d1<=0) && (d2>0) 		 %-A
			up_cross_p(up_c, 1) = i;

		elseif (d1>0) && (d2<=0)    %-B
			up_cross_p(up_c, 2) = i;
			up_c = up_c + 1;

		elseif (d3>0) && (d4<=0)     %-C
			down_cross_p(dn_c, 1) = i;

		elseif (d3<=0) && (d4>0)     %-D
			down_cross_p(dn_c, 2) = i;
			dn_c = dn_c + 1;
		end
	end

	%--Abstract the Non-zero part.
	up_cross_p = AbstractNonZero(up_cross_p);
	down_cross_p = AbstractNonZero(down_cross_p);


%-function description:
%-trim the set of all peaks list.
%-Input:
% 		the set of all peaks list
%-Output:
% 		the trimmed set of peaks list without zero index.
function newlist = AbstractNonZero(alist)
	%-alist
	% nx2
	if alist(1,1)==0
		startp = 2;
	else
		startp = 1;
	end
	count = size(alist, 1);
	if alist(count,1)==0 || alist(count,2)==0
		count = count -2;
	end

	newlist = alist(startp:count, :);

% function description:
% trim every Peaks list with length 8
% Input:
% 		all peaks lists
% Output:
% 		trimmed peaks x coordinate lists with length n.
function peak_array = Peaks_n(alist, startp, endp, n)
	max_value = alist(startp);
	max_index = startp;
	for i=startp+1:endp
		if alist(i)>max_value
			max_value = alist(i);
			max_index = i;
		end
	end
	peak_array = [];
	if mod(n, 2)==0
		% even_number
		sp = max_index - (n/2 - 1);
		ep = max_index + n/2;
	else
		% odd_number
		sp = max_index - floor(n/2);
		ep = max_index + floor(n/2);
	end
	peak_array = sp : ep;


% --------------Function description
% Input:
% 		Xs, index points of passing through threshold_value
% 				nx2
% 		n, 	the width of the peaks, generally 8 points
% Output:
% 		new_Xs, index points of passing through threshold_value
% 						 after trimming
%				mx2, m < n 					
function new_Xs = Overlap(alist, Xs, n)
	% part of matrix Xs
    % 9384        9385        9386        9387        9388        9389        9390        9391
    % 9430        9431        9432        9433        9434        9435        9436        9437
    % 9432        9433        9434        9435        9436        9437        9438        9439
    % 9438        9439        9440        9441        9442        9443        9444        9445
	new_Xs = [];
    i = 1;
	while ( i<=(size(Xs,1)-1) )
		% Overlap happends
		if (Xs(i, n)) > Xs(i+1, 1)
			new_x = Peaks_n(alist, Xs(i, 1), Xs(i+1, n), n);
            i = i+1;
        else
            new_x = Xs(i,:);
		end 
		new_Xs = [new_Xs; ...
				  new_x];
        i = i+1;
	end


% clipping data
function movement_data = clipping(alist)
	% alist, 5x192000
	n_mv = 5; % 5 kinds of movements
	time_1mv = 4; % 4 secondes for each movement
	n_repeat = 3; % repeat 3 times
	
	[n_ch, total_L] = size(alist);
	n_1second = floor(total_L/(n_mv - 1) / n_repeat / 2 /time_1mv);
	% 		  ~ 2000 HZ

	part_clipped = floor(n_1second * 0.4); % head and tail are removed.


	% output: movement_data, 5x1, cell
	movement_data = cell(5,1);
	% rest
	% grasp
	% open
	% index
	% middle
	n_part = (n_mv - 1) * n_repeat * 2;
	% 24 = 4 * 3 * 2 -- seconds
	for pt=0:n_part-2
		slice = alist(:,   pt*time_1mv*n_1second+part_clipped : ...
			           (pt+1)*time_1mv*n_1second-part_clipped);
		% slice of 4 secodes with head and tail clipped. 
		if mod(pt,2)==0
			% 1, rest
			movement_data{1} = [movement_data{1}, slice];
		else
			% 2, grasp
			% 3, open
			% 4, index
			% 5, middle
			seq = ceil(mod(pt, 8)/2) + 1;
			movement_data{seq} = [movement_data{seq}, slice];
		end
	end

function FM = FMmatrix(movement_data)
	n_mv = size(movement_data);
	% 5x1, cell
	% movement_data{n},
	% 5x19263

	FM = cell(5,1);
	% FM{n}
	% 5M x p
	% 5, number of features
	% 	IAV, MAX, NonZeroMed, SemiEny1, SemiEny2, 
	% M, number of MUAP
	% p, number of time windows

	for n=1:n_mv
		long = size(movement_data{n}, 2);
		LW = 128; % length of time window
		LI = 64;%length of increase window
		n_windows = floor(1+(long-LW)/LI);

		f_p = [];
		for nw=0:n_windows-1
			data = movement_data{n}(:, nw*LI+1:nw*LI+LW);
			% Mx128
			M = size(data,1);
			f_ch = [];
			for ch=1:M
				f_ch = [f_ch; ...
						IAV(data(ch,:)); ...
						MAX(data(ch,:)); ...
						NonZeroMed(data(ch,:)); ...
						SemiEny1(data(ch,:)); ...
						SemiEny2(data(ch,:))];
			end
			f_p = [f_p, f_ch];
		end
		FM{n} = f_p; 
	end


% Functions of feature extraction
function f = IAV(data)
	% data, 1x128
	f = sum(abs(data))/length(data);

function f = MAX(data)
	% data, 1x128
	f = max(abs(data));

function f = NonZeroMed(data)
	% data, 1x128
% 	f = median(data(data~=0));
%     always return NaN,if data = zeros(1,128);
    f = median(data);

function f = SemiEny1(data)
	% data, 1x128
	N = length(data);

	f = sum(data(1:floor(N/2)).^2);

function f = SemiEny2(data)
	% data, 1x128
	N = length(data);

	f = sum(data(floor(N/2)+1:end).^2);

function accuracy = LDA_classfy(FM)
	% FM, 5x1, cell
	% 1. rest, 25x1202
	% 2. grasp,25x299
	% 3. open, 25x299
	% 4. index,25x299
	% 5. middle25x199

	% -------xSw
	n_mv = length(FM);
	[a, b] = size(FM{1});
	% 25x1202
	xSw = zeros(a,a);
	SUM = zeros(1, a);
	center = zeros(n_mv, a);

	specimen_counts = 0;
	for mv=1:n_mv
		center(mv, :) = mean(FM{mv}');
		temp = FM{mv}' - repmat(mean(FM{mv}'), size(FM{mv}, 2), 1);
		specimen_counts = specimen_counts + size(FM{mv}, 2);
		xSw = xSw + temp'*temp;
		SUM = SUM + sum(FM{mv}', 1);
	end
	Xmeans = SUM/specimen_counts;


	% --------xSb
	xSb = zeros(a, a);
	for mv=1:n_mv
		temp = mean(FM{mv}') - Xmeans;
		xSb = xSb + temp'*temp;
	end

    
	% LDA algorithm
	[old_Vector, old_Value] = eig(xSb, xSw);
	[Vector, Value] = sortVectorValue(old_Vector, old_Value);
	LDA_A = Vector(:, 1:8);

	LDA_center = center * LDA_A;

	% LDA_A, 
	% dimension-reduction matrix
	% LDA_center, 
	% reduced centers


	% verification
	right = 0;
	total = 0;
	for mv=1:n_mv
		for n=1:size(FM{mv}, 2)
			sample = FM{mv}(:, n);
			sample = sample';
			% 1x25
			reduced_sample = sample * LDA_A;
			% label results
			distance = [];
			for v=1:n_mv
				distance = [distance; ...
							norm(LDA_center(v, :) - reduced_sample)];
			end
			[~, label] = min(distance);

			total = total + 1;
			if label == mv
				right = right + 1;
			end
		end
	end

	% LDA_center
	% LDA_A

	accuracy = right/total;