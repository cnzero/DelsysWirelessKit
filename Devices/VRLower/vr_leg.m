function varargout = vr_leg(varargin)
% 创建虚拟现实世界
% 传入参数可为无，或者一个窗口句柄
% 传出参数可为无，或者本窗口句柄

%% 创建虚拟世界
vrfilename = 'human.wrl';
if ~exist(vrfilename, 'file')
    fprintf('%s does not exist\n', vrfilename);
    return;
end
hWorld1 = vrworld(vrfilename);  %创建vrworld
%handle of the 'hand.wrl' 
open(hWorld1);

%% 创建窗口
hFigure1 = figure('Name', 'World', 'NumberTitle', 'off', ...
                'MenuBar', 'figure', 'Toolbar', 'figure', ...
                'Units', 'normalized', ...
                'Position', [20 20 60 60]/100, ...
                'Color', [236 233 216]/255, ...
                'CloseRequestFcn', @Figure1CloseRequestFcn);
% maximize(hFigure1);
%% 将虚拟世界附着到Figure窗口上进行显示
hCanvas1 = vr.canvas(hWorld1, 'Parent', hFigure1, ...
    'Units', 'normalized', 'Position', [0 0 1 1]);

%% 保存句柄结构
handles.figure1 = hFigure1;
handles.world1 = hWorld1;
handles.canvas1 = hCanvas1;
%--Open more APIs
%global world_handles;
%world_handles = handles.world1;
if nargin
    handles.figureMain = varargin{1};   % 保存传入窗口句柄
else
    handles.figureMain = -1;
end
if nargout
    varargout{1} = hWorld1;    % 传出本窗口句柄
end
guidata(hFigure1, handles);  % 保存句柄结构

function Figure1CloseRequestFcn(source, ~)
    %% Figure1关闭函数
    handles = guidata(source);
    close(handles.world1);
%     delete(handles.world1);
    global Control_Flag;
    Control_Flag = 0;
    disp('Close VR leg figure.');
    closereq;
