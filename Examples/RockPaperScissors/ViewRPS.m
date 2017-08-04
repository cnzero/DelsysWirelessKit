classdef ViewRPS < handle
	properties
	model  % handle of device Delsys Model
	handles % the root handle of the view figure
	     		% which contains all the widgets in the view figure
	% - struct of fE-features extraction
	fE
				% - [featuresCell], selected features to be extracted into the feature space.
				% - [LW], Length of time Window
				% - [LI], Length of Incremental window.

	classifier  % Pattern Recognition classifier
	flagAxesRefreshing = 1
	dataAxesEMG = []
	dataEmgStored = []
	dataEmgRealTime = []

	flagEMGWrite2Files = 0

	folder_name

	rowResult = []  % - sliding window for final result. 
	device  % - Control device
	end

	events
	end

	methods
		% -- Constructor
		function obj = ViewRPS(modelObj)
			% - Initialize [fE]
			obj.fE.featuresCell = {'RMS', 'MAV'};
			obj.fE.LW = 128;
			obj.fE.LI = 64;
			addpath('../../Matlab');
			obj.model = modelObj;
			obj.handles = InitFigure(obj);
			obj.Init_Folder();

			obj.model.addlistener('eventEMGChanged', @obj.UpdateAxesEMG);
			obj.model.addlistener('eventEMGChanged', @obj.Write2FilesEMG);
		end
		function obj = UpdateAxesEMG(obj, source, event)
			if obj.flagAxesRefreshing == 1
				% - refreshing axes all the time until stop Delsys
				if(length(obj.dataAxesEMG) < (32832/4))
	        		obj.dataAxesEMG = [obj.dataAxesEMG, obj.model.dataEMG];
	        	else
	        		obj.dataAxesEMG = [obj.dataAxesEMG(:, size(obj.model.dataEMG,2)+1:end), ...
	        						   obj.model.dataEMG];
	        	end
	        	for ch=1:min(length(obj.model.chEMG), 4)
	        		% obj.dataEMG = dataEMG(obj.chEMG, :);	
	        		plot(obj.handles.hAxesEMG(ch), obj.dataAxesEMG(ch, :));
	        		drawnow;
	        	end
			end
		end

		function obj = Write2FilesEMG(obj, source, event)
			if obj.flagEMGWrite2Files == 1
				% - How much time sampling data are stored?
				T = 3;
				if(length(obj.dataEmgStored) < T*2000*length(obj.model.chEMG))
					obj.dataEmgStored = [obj.dataEmgStored, obj.model.dataEMG];
					p = length(obj.dataEmgStored)/(T*2000*length(obj.model.chEMG));
					uiProgress(obj.handles, p, 'r');

				else
					obj.flagEMGWrite2Files = 0;
					set(obj.handles.hButtonStartAcquire, 'String', 'Acquired Over');
					dlmwrite([obj.folder_name, '\EMG\',obj.handles.strSelected, '.txt'], ...
							 obj.dataEmgStored, ...
							 'precision', '%.8f');
					obj.dataEmgStored = [];
				end
			end
		end
		function obj = RealtimePR(obj, source, event)
			% disp('Real time Pattern Recognition');
			% - whether enough raw EMG sampling points
			if (size(obj.dataEmgRealTime, 2) < obj.fE.LW)
				obj.dataEmgRealTime = [obj.dataEmgRealTime, obj.model.dataEMG];
				disp('Cat data...');
			else
				obj.dataEmgRealTime = [obj.dataEmgRealTime(:,size(obj.model.dataEMG,2)+1:end), ...
									   obj.model.dataEMG];
				% - Yes, enough ->
				% - features extraction
				% x = Rawdata2SampleMatrix(obj.dataEmgRealTime(:, 1:obj.fE.LW), obj.fE);
				x = Rawdata2SampleMatrix(obj.dataEmgRealTime, obj.fE);
				% - x, not just only one sample point, 
				% - maybe a matrix with every row being a sample
				% - classifier judge
				% - output test result
				nResult = obj.classifier.Judge(x); 
				if length(obj.rowResult) < 10
					obj.rowResult = [obj.rowResult, nResult];
				else
					obj.rowResult = [obj.rowResult(2:end), nResult];
					nFinal = ceil(median(obj.rowResult));
					strResult = obj.handles.strAllSelected{nFinal};
					% - Refreshing pictures
					% ------- No pictures
					% hPicture = imread(['../../MATLAB/Pictures/', strResult, '.jpg']);
					% imshow(hPicture, 'Parent', obj.handles.hAxesPictureBed);	
					% drawnow;
					% --------No pictures

					% - Send commands to Hand
					hFunctionMove = str2func(['smove', strResult]);
					hFunctionMove(obj.device);
				end
			end
		end
		function Init_Folder(obj)
        	c = clock;
        	folder_name	= [];
			folder_name = [folder_name, ...
						   num2str(c(1)), ... % year
			               num2str(c(2)), ... % month
			               num2str(c(3)), ... % day
			               num2str(c(4)), ... % hour
			               num2str(c(5)), ... % minute
			               num2str(fix(c(6)))]; % second
			% for example, run this code at 2016-07-13 10:13:30s
			% folder_name, 2016_07_13_10_13_30
			mkdir(['Users\',folder_name]);
			mkdir(['Users\',folder_name, '\EMG']);
			mkdir(['Users\',folder_name, '\ACC']);
			obj.folder_name = ['Users\',folder_name];
        end
	end
end

function handles = InitFigure(obj)
	% -- Level one: the whole layout of the [hFigure]
	hFigure = figure();
	handles.hFigure = hFigure;

	hPanelParameters = uipanel('Title', 'User Selection Parameters', ...
							   'Parent', hFigure, ...
							   'Units', 'normalized', ...
							   'Position', [0.01 0.81 0.6 0.18]);
	handles.hPanelParameters = hPanelParameters;

	hPanelEMGAxes = uipanel('Title', 'Axes for Realtime sEMG display', ...
							'Parent', hFigure, ...
							'Units', 'normalized', ...
							'Position', [0.01 0.05 0.6 0.75]);
	handles.hPanelEMGAxes = hPanelEMGAxes;

	hPanelPictureBed = uipanel('Title', 'Picture', ...
							   'Parent', hFigure, ...
							   'Units', 'normalized', ...
							   'Position', [0.62 0.45 0.37 0.54]);
	hAxesPictureBed = axes('Parent', hPanelPictureBed, ...
						   'Units', 'normalized', ...
						   'Position', [0.02 0.02 0.95 0.95]);
	handles.hAxesPictureBed = hAxesPictureBed;
	handles.hPanelPictureBed = hPanelPictureBed;
	% - read pictures from folders
	hPictureReady = imread('../../MATLAB/Pictures/Ready.jpg');
	imshow(hPictureReady, 'Parent', handles.hAxesPictureBed);

	% -- Level two: layout of [hPanelParameters]
	% hEditUserName = uicontrol('Parent', hPanelParameters, ...)	
	hPanelUser = uipanel('Title', 'User Profiles', ...
						 'Parent', hPanelParameters, ...
						 'Units', 'normalized', ...
						 'Position', [0.01, 0.01, 0.3 0.9]);
	handles.hPanelUser = hPanelUser;

	hPanelMovements = uipanel('Title', 'Movements Selection', ...
							  'Parent', hPanelParameters, ...
							  'Units', 'normalized', ...
							  'Position', [0.33 0.01 0.55 0.9]);
	handles.hPanelMovements = hPanelMovements;

	hPanelChannel = uipanel('Parent', hPanelMovements, ...
							'Title', 'Channel Selection', ...
							'Units', 'normalized', ...
							'Position', [0.01 0.02 0.45 0.95]);
	handles.hPanelChannel = hPanelChannel;
	valueChannelCheckbox = {false, false, false, false; ...
							false, false, false, false; ...
							false, false, false, false; ...
							false, false, false, false};
	valueChannelNum = {'1', '2', '3', '4'; ...
					   '5', '6', '7', '8'; ...
					   '9', '10','11','12';...
					   '13','14','15','16'};
	hChannelNumTable = uitable('Parent', hPanelChannel, ...
							   'Data', valueChannelNum, ...
							   'Units', 'normalized', ...
							   'Position', [0.52 0.02 0.48 0.95], ...
							   'RowName', [], ...
							   'ColumnName', [], ...
							   'ColumnWidth', {30, 30, 30, 30});
	hChannelCheckboxTable = uitable('Parent', hPanelChannel, ...
							 'Data', valueChannelCheckbox, ...
							 'Units', 'normalized', ...
							 'Position', [0.01 0.02 0.5 0.95], ...
							 'RowName', [], ...
							 'ColumnName', [], ...
							 'ColumnWidth', {30, 30, 30, 30}, ...
							 'CellEditCallback', {@CellEditCallback_Channel, obj}, ...
							 'ColumnEditable', [true, true, true, true]);
	handles.hChannelCheckboxTable = hChannelCheckboxTable;

	hPanelMotion = uipanel('Parent', hPanelMovements, ...
							  'Title', 'Motion Selection', ...
							  'Units', 'normalized', ...
							  'Position', [0.47 0.02 0.47 0.95]);
	valueMotionCheckbox = {false, 'Snooze', false, 'Open',   false, 'Grasp'; ...
						   false, 'Index',  false, 'Middle', false, 'Rock'; ...
						   false, 'Paper',  false, 'Scissor',false, 'Unknow'};
	% ColumnWidth = 50;
	CW = 50;
	hMotionCheckboxTable = uitable('Parent', hPanelMotion, ...
								   'Data', valueMotionCheckbox, ...
								   'Units', 'normalized', ...
								   'Position', [0.01 0.02 0.98 0.95], ...
								   'RowName', [], ...
								   'ColumnName', [], ...
								   'ColumnWidth', {CW, CW, CW, CW, CW, CW}, ...
								   'ColumnEditable', [true, false, true, false, true, false], ...
								   'CellEditCallback', {@CellEditCallback_Motion, obj});
	handles.hMotionCheckboxTable = hMotionCheckboxTable;
	hButtonRealTime = uicontrol('Parent', hPanelParameters, ...
								'Style', 'pushbutton', ...
								'Units', 'normalized', ...
								'Position', [0.9, 0.01 0.09, 0.9], ...
								'String', 'RealTime', ...
								'Callback', {@Callback_ButtonRealTime, obj});
	handles.hButtonRealTime = hButtonRealTime;
	% -- Level two: layout of [hPanelEMGAxes]
	nCh = 4;
	dWidth = 0.95/nCh;
	for ch=1:nCh
		handles.hAxesEMG(ch) = axes('Parent', handles.hPanelEMGAxes, ...
									'Units', 'normalized', ...
									'Position', [0.02 1-dWidth*ch 0.9 dWidth*0.86]);
		handles.hPlotsEMG(ch) = plot(handles.hAxesEMG(ch), 0, '-y', 'LineWidth', 1);
	end	
	handles.hAxesProgress = axes('Parent', handles.hPanelEMGAxes, ...
								 'Units', 'normalized', ...
								 'Position', [0.96 0.03 0.02 0.95], ...
								 'YLim', [0,1], ...
								 'Title', 'Progress');
	uiProgress(handles, 0, 'none');

	% -- Level two: layout of [hPanelPictureBed]

	% -- Level three: interface widgets in [hPanelParameters]
	hEditUserName = uicontrol('Parent', hPanelUser, ...
							  'Style', 'Edit', ...
							  'Units', 'normalized', ...
							  'Position', [0.01, 0.7, 0.9, 0.28], ...
							  'String', 'Input User Name', ...
							  'Callback', {@callback_ClearUserNamePromption, obj});


	% -- Work Through Buttons
	hButtonStartAcquire =  uicontrol('Parent', hFigure, ...
									 'Style', 'pushbutton', ...
									 'Units', 'normalized', ...
									 'Position', [0.7 0.3 0.1 0.07], ...
									 'String', 'To Acquire', ...
									 'Callback', {@Callback_ButtonStartAcquire, obj});
	handles.hButtonStartAcquire = hButtonStartAcquire;

	hButtonStartTrain = uicontrol('Parent', hFigure, ...
									 'Style', 'pushbutton', ...
									 'Units', 'normalized', ...
									 'Position', [0.85 0.3 0.1 0.07], ...
									 'String', 'Training Model', ...
									 'Callback', {@Callback_ButtonStartTrain, obj});
	handles.hButtonStartTrain = hButtonStartTrain; 

	hButtonRealTimePR = uicontrol('Parent', hFigure, ...
								  'Style', 'pushbutton', ...
								  'Units', 'normalized', ...
								  'Position', [0.85 0.2 0.08 0.07], ...
								  'String', 'Stop', ...
								  'Callback', {@Callback_ButtonRealTimePR, obj});
	handles.hButtonRealTimePR = hButtonRealTimePR;


	guidata(hFigure, handles);
	if nargout
		varargout{1} = hFigure;
	end
end
function callback_ClearUserNamePromption(source, eventdata, obj)
end

function CellEditCallback_Channel(source, eventdata, obj)
	handles = obj.handles;
	trueValueChannel = cell2mat(handles.hChannelCheckboxTable.Data);
	chSelect = find(reshape(trueValueChannel', 1, 16)==1);
	handles.chSelect = chSelect;

	obj.handles = handles;
end

function CellEditCallback_Motion(source, eventdata, obj)
	handles = obj.handles;
	trueValueMotion = cell2mat(handles.hMotionCheckboxTable.Data(:, 1:2:end));
	strMotion = {'Snooze', 'Open', 'Grasp', ...
				 'Index', 'Middle', 'Rock', ...
				 'Paper', 'Scissor', 'Unknow'};
	strAllSelected = strMotion(reshape(trueValueMotion', 1, []));
	handles.strAllSelected = strAllSelected;

	r = eventdata.Indices(1);
	c = eventdata.Indices(2);
	strSelected = handles.hMotionCheckboxTable.Data{r,c+1};
	handles.strSelected = strSelected;
	set(handles.hButtonStartAcquire, 'String', 'Ready To Acquire');
	hPicture = imread(['../../MATLAB/Pictures/', strSelected, '.jpg']);
	imshow(hPicture, 'Parent', handles.hAxesPictureBed);
	obj.flagEMGWrite2Files = 0;
	if obj.model.statusBusy == 0
		obj.model.Start(obj.handles.chSelect);
	end
	uiProgress(obj.handles, 0, 'none');
	obj.handles = handles;
end

function Callback_ButtonRealTime(source, event, obj)
	handles = obj.handles;
	obj.flagAxesRefreshing = ~(obj.flagAxesRefreshing);

	obj.handles = handles;
end

function Callback_ButtonStartAcquire(source, eventdata, obj)
	% - To acquire original sEMG data under the appointed labels
	handles = obj.handles;
	obj.flagEMGWrite2Files = 1;

	% - only 8s samples are stored in the files. 
	% - else, flagEMGWrite2Files = 0;


	obj.handles = handles;
end

function Callback_ButtonStartTrain(source, eventdata, obj)
	handles = obj.handles;
	% - main purpose: to fit the [Machine Learning Model]
	obj.flagEMGWrite2Files = 0;
	obj.flagAxesRefreshing = 0;
	% obj.model.Stop();

	% - read raw sEMG data from files
	% ------------------  [To construct feature Space]
	rawDataCell = {};
	for n=1:length(handles.strAllSelected)
		d = load([obj.folder_name, '\EMG\',handles.strAllSelected{n}, '.txt']);
		rawDataCell{n} = d(:, 2000*.3:end-2000*.3); % - break off both ends.
		clear d;
	end
	addpath('../../MATLAB/FeaturesExtraction');
	sampleCell = RawdataCell2SampleCellN(rawDataCell, obj.fE);

	% -----------------  [To train classifier]
	addpath('../../MATLAB/DimensionReduction');
	n_components = 4;
	obj.classifier = LDA(n_components);
	% - Next time, you can only change model/classifier here.
	% - For example
	% obj.classifier = PCA(n_components);
	% obj.classifier = SVM(params);
	% obj.classifier.trainM(sampleCell);
	obj.classifier.SimpleTrainM(sampleCell);
	% -- how to notify image refreshing and HandObj---------------------[][][][][][][][]
	% obj.classifier.addlistener('eventJudged', @)

	% -- Connected to Devices/Hand
	addpath('../../Devices/Ghand');
	obj.device = InitGHand(5); % - COM5
	% ------------------- [reatime pattern recognition]
	obj.model.addlistener('eventEMGChanged', @obj.RealtimePR);
	% obj.model.Start([obj.handles.chSelect]);

	obj.handles = handles;
end

function Callback_ButtonRealTimePR(source, eventdata, obj)
	obj.model.Stop();
end
function uiProgress(handles, p, color)
	patch('Parent', handles.hAxesProgress, ...
		  'XData', [0 1 1 0], ...
		  'YData', [0 0 p p], ...
		  'FaceColor', color);	
end