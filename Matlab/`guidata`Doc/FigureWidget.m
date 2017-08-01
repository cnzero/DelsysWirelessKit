function varargout = FigureWidget()
	hFigure = figure();

	hButtonRealTime = uicontrol('Parent', hFigure, ...
								'Style', 'pushbutton', ...
								'Units', 'normalized', ...
								'Position', [0.5, 0.5 0.3, 0.2], ...
								'String', 'RealTime', ...
								'Callback', @callback_ClearUserNamePromption);
	hFigure.hButtonRealTime.Units
	% handles.hFigure = hFigure;
	guidata(hFigure, handles);


	% guidata(hFigure, handles)

	if nargout
		varargout{1} = handles;
	end
end

function callback_ClearUserNamePromption(source, event)
	handles = guidata(source)
	handles.hButtonRealTime
end