function human_reset_front(world_handles)
    body = world_handles.body;
    body.rotation = [0 1 0 1.4];
    youdatui   = world_handles.youdatui;    youdatui.rotation   = [0 0 1 0.15];
    youxiaotui = world_handles.youxiaotui;  youxiaotui.rotation = [1 0 0 0];
    youjiao    = world_handles.youjiao;     youjiao.rotation    = [1 0 0 0];
    
    zuodatui   = world_handles.zuodatui;    zuodatui.rotation   = [0 0 1 -0.15];
    zuoxiaotui = world_handles.zuoxiaotui;  zuoxiaotui.rotation = [1 0 0 0];
    zuojiao    = world_handles.zuojiao;     zuojiao.rotation    = [1 0 0 0];
end