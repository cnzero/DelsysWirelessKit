function smoveStand(world_handles) 
	J0 = 0.15;
	J1 = 0.1;
	J2 = 0.5;
	speed = 0.01;
    human_reset_front(world_handles);
    youdatui = world_handles.youdatui;
    youxiaotui = world_handles.youxiaotui;    
    youxiaotui.rotation = [0 1 0 0.7];

    youjiao  = world_handles.youjiao ;        
    youjiao.rotation = [1 0 0 0.3];
end