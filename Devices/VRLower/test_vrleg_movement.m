function test_vrleg_movement()
    %---Random to display the five movements
    global world_handles;	world_handles = vr_leg();
    global speed;           speed = 0.001;%单次变换的时间间隔，数值越小，变化越快
    
    Move_right_kuanguanjie_waizhan(0.15, -0.1, -0.6);
    Move_right_kuanguanjie_neishou(0.15, 0.1, 0.5);
    
    Move_right_xiguanjie(1, -0.1, 0);
    Move_right_xiguanjie(1, 0.2, 2);
    Move_right_jiao(0, -0.1, -0.5);
    Move_right_jiao(0, 0.1, 0.5);

    

function human_reset_right() %回归右侧视角初始位置
    global world_handles;
    body = world_handles.body;  %右侧视角
    body.rotation = [0 1 0 2.8];
    youdatui   = world_handles.youdatui;    youdatui.rotation   = [0 0 1 0.15];
    youxiaotui = world_handles.youxiaotui;  youxiaotui.rotation = [1 0 0 0];
    youjiao    = world_handles.youjiao;     youjiao.rotation    = [1 0 0 0];
    
    zuodatui   = world_handles.zuodatui;    zuodatui.rotation   = [0 0 1 -0.15];
    zuoxiaotui = world_handles.zuoxiaotui;  zuoxiaotui.rotation = [1 0 0 0];
    zuojiao    = world_handles.zuojiao;     zuojiao.rotation    = [1 0 0 0];
     
function human_reset_front() %回归正面视角初始位置
    global world_handles;
    body = world_handles.body;  %正面视角
    body.rotation = [0 1 0 1.4];
    youdatui   = world_handles.youdatui;    youdatui.rotation   = [0 0 1 0.15];
    youxiaotui = world_handles.youxiaotui;  youxiaotui.rotation = [1 0 0 0];
    youjiao    = world_handles.youjiao;     youjiao.rotation    = [1 0 0 0];
    
    zuodatui   = world_handles.zuodatui;    zuodatui.rotation   = [0 0 1 -0.15];
    zuoxiaotui = world_handles.zuoxiaotui;  zuoxiaotui.rotation = [1 0 0 0];
    zuojiao    = world_handles.zuojiao;     zuojiao.rotation    = [1 0 0 0];

function Move_right_kuanguanjie_neishou(J0, J1, J2) %右腿向左前方内收，起始角度为J0，递增角度为J1，最终角度为J2
    global world_handles; 
    global speed;
    human_reset_front();%回归正面初始位置
    youdatui = world_handles.youdatui;
    youxiaotui = world_handles.youxiaotui;    youxiaotui.rotation = [0 1 0 0.7];
    youjiao  = world_handles.youjiao ;        youjiao.rotation = [1 0 0 0.3];
    for i=J0:J1:J2
        youdatui.rotation = [0 -1 0 i];
        youdatui.rotation = youdatui.rotation + [0 0 1 i];
        pause(3*speed);
    end


    
function Move_right_kuanguanjie_waizhan(J0, J1, J2) %移动右腿髋关节，起始角度为J0，递增角度为J1，最终角度为J2
    global world_handles; 
    global speed;
    human_reset_front();%回归正面初始位置
    youdatui = world_handles.youdatui;
    for i=J0:J1:J2
        youdatui.rotation = [0 0 1 i];
        pause(speed);
    end
    
    

    
function Move_right_xiguanjie(J0, J1, J2)  %移动右侧膝关节，起始角度为J0，递增角度为J1，最终角度为J2
    global world_handles; 
    global speed;
    human_reset_right() %回归右侧初始位置
    youdatui = world_handles.youdatui;     youdatui.rotation   = [1 0 0 -1];
    youxiaotui = world_handles.youxiaotui; youxiaotui.rotation = [1 0 0 1];
    for i=J0:J1:J2
        youxiaotui.rotation = [1 0 0 i];
        pause(speed);
    end
 

   
function Move_right_jiao(J0, J1, J2)  %移动右脚，起始角度为J0，递增角度为J1，最终角度为J2。J2=-0.5，背屈。J2=0.5，跖屈。
    global world_handles; 
    global speed;
    human_reset_right() %回归右侧初始位置
    youjiao = world_handles.youjiao;
    youdatui = world_handles.youdatui;     youdatui.rotation   = [1 0 0 -1];
    youxiaotui = world_handles.youxiaotui; youxiaotui.rotation = [1 0 0 1];
    for i=J0:J1:J2
        youjiao.rotation = [1 0 0 i];
        pause(speed);
    end      
    


    
    
    
    
    
    
    
    
    
    