function varargout = vr_leg(varargin)
% ����������ʵ����
% ���������Ϊ�ޣ�����һ�����ھ��
% ����������Ϊ�ޣ����߱����ھ��

%% ������������
vrfilename = 'human.wrl';
if ~exist(vrfilename, 'file')
    fprintf('%s does not exist\n', vrfilename);
    return;
end
hWorld1 = vrworld(vrfilename);  %����vrworld
%handle of the 'hand.wrl' 
open(hWorld1);

%% ��������
hFigure1 = figure('Name', 'World', 'NumberTitle', 'off', ...
                'MenuBar', 'figure', 'Toolbar', 'figure', ...
                'Units', 'normalized', ...
                'Position', [20 20 60 60]/100, ...
                'Color', [236 233 216]/255, ...
                'CloseRequestFcn', @Figure1CloseRequestFcn);
% maximize(hFigure1);
%% ���������總�ŵ�Figure�����Ͻ�����ʾ
hCanvas1 = vr.canvas(hWorld1, 'Parent', hFigure1, ...
    'Units', 'normalized', 'Position', [0 0 1 1]);

%% �������ṹ
handles.figure1 = hFigure1;
handles.world1 = hWorld1;
handles.canvas1 = hCanvas1;
%--Open more APIs
%global world_handles;
%world_handles = handles.world1;
if nargin
    handles.figureMain = varargin{1};   % ���洫�봰�ھ��
else
    handles.figureMain = -1;
end
if nargout
    varargout{1} = hWorld1;    % ���������ھ��
end
guidata(hFigure1, handles);  % �������ṹ

function Figure1CloseRequestFcn(source, ~)
    %% Figure1�رպ���
    handles = guidata(source);
    close(handles.world1);
%     delete(handles.world1);
    global Control_Flag;
    Control_Flag = 0;
    disp('Close VR leg figure.');
    closereq;
