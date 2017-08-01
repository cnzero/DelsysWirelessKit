classdef ViewRPS < handle
	properties
	model  % handle of Model
	handles % the root handle of the view figure
	     		% which contains all the widgets in the view figure
	flagAxesRefreshing = 1
	dataAxesEMG = []
	dataEmgStored = []

	flagEMGWrite2Files = 0

	folder_name
	end

	events
	end

	methods
		% -- Constructor
		function obj = ViewRPS(modelObj)
			obj.model = modelObj;
			obj.handles = InitFigure(obj);

			obj.model.addlistener('eventEMGChanged', @obj.UpdateAxesEMG);
			obj.model.addlistener('eventEMGChanged', @obj.Write2FilesEMG);
		end
		function obj = UpdateAxesEMG(obj, source, event)
			if obj.flagAxesRefreshing == 1
				% - refreshing axes all the time until stop Delsys
				if(length(obj.dataAxesEMG) < (32832/4))
	        		obj.dataAxesEMG = [obj.dataAxesEMG, obj.model.dataEMG];
	        	else
	        		obj.dataAxesEMG = [obj.dataAxesEMG(length(obj.model.dataEMG)+1:end); ...
	        						   obj.model.dataEMG];
	        	end
	        	for ch=1:min(length(obj.model.chEMG), 4)
	        		% obj.dataEMG = dataEMG(obj.chEMG, :);	
	        		plot(obj.hAxesEMG(ch), obj.dataAxesEMG(ch, :));
	        		drawnow;
	        	end
			end
		end

		function obj = Write2FilesEMG(obj, source, event)
			if obj.flagEMGWrite2Files == 1
				% - How much time sampling data are stored?
				T = 6;
				if(length(obj.dataEmgStored) < T*2000*length(obj.chEMG))
					obj.dataEmgStored = [obj.dataEmgStored, obj.model.dataEMG];
				else
					obj.flagEMGWrite2Files = 0;
					set(obj.handles.hButtonStartAcquire, 'String', 'Acquired Over');
					dlmwrite([obj.folder_name, '\EMG\',obj.handles.strSelected, '.txt'], ...
							 obj.dataEmgStored, ...
							 'precision', '%.8f');
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
	hPictureReady = imread('Pictures/Ready.jpg');
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
							 'CellEditCallback', @CellEditCallback_Channel, ...
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
								   'CellEditCallback', @CellEditCallback_Motion);
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
									'Position', [0.02 1-dWidth*ch 0.95 dWidth*0.85]);
		handles.hPlotsEMG(ch) = plot(handles.hAxesEMG(ch), 0, '-y', 'LineWidth', 1);
	end	

	% -- Level two: layout of [hPanelPictureBed]

	% -- Level three: interface widgets in [hPanelParameters]
	hEditUserName = uicontrol('Parent', hPanelUser, ...
							  'Style', 'Edit', ...
							  'Units', 'normalized', ...
							  'Position', [0.01, 0.7, 0.9, 0.28], ...
							  'String', 'Input User Name', ...
							  'Callback', @callback_ClearUserNamePromption);


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
									 'Callback', @Callback_ButtonStartTrain);
	handles.hButtonStartTrain = hButtonStartTrain; 

	guidata(hFigure, handles);
	if nargout
		varargout{1} = hFigure;
	end
end
function callback_ClearUserNamePromption(source, eventdata)
	handles = guidata(source);


	% Updata handles structure
	guidata(source, handles)
end

function CellEditCallback_Channel(source, eventdata)
	handles = guidata(source);
	trueValueChannel = cell2mat(handles.hChannelCheckboxTable.Data);
	chSelect = find(reshape(trueValueChannel', 1, 16)==1);

	guidata(source, handles)
end

function CellEditCallback_Motion(source, eventdata)
	handles = guidata(source);
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
	set(handles.hButtonStartAcquire, 'String', 'To Acquire');

	hPicture = imread(['Pictures/', strSelected, '.jpg']);
	imshow(hPicture, 'Parent', handles.hAxesPictureBed);

	guidata(source, handles);
end

function Callback_ButtonRealTime(source, event, obj)
	handles = guidata(source);
	obj.flagEMGWrite2Files = ~(obj.flagAxesRefreshing);

	guidata(source, handles);
end

function Callback_ButtonStartAcquire(source, eventdata, obj)
	% - To acquire original sEMG data under the appointed labels
	handles = guidata(source);
	addpath('../../Matlab');
	obj.model.Start([1,2,3]);
	obj.flagEMGWrite2Files = 1;

	% - only 8s samples are stored in the files. 
	% - else, flagEMGWrite2Files = 0;


	guidata(source, handles);
end

function Callback_ButtonStartTrain(source, eventdata)
	handles = guidata(source);
	set(handles.hButtonStartTrain, 'Enable', 'off');

	pause(5);
	% - main purpose: to fit the [Machine Learning Model]




	set(handles.hButtonStartTrain, 'String', 'RealTime Recognition');
	set(handles.hButtonStartTrain, 'Enable', 'on');
	guidata(source, handles);
end