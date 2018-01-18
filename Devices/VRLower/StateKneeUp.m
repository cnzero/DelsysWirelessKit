function StateKneeUp(world_handles)
	J0 = 1;
	J1 = -0.1;
	J2 = 0;
    speed = 0.01;
    human_reset_right(world_handles)
    youdatui = world_handles.youdatui;     youdatui.rotation   = [1 0 0 -1];
    youxiaotui = world_handles.youxiaotui; youxiaotui.rotation = [1 0 0 1];
    for i=J0:J1:J2
        youxiaotui.rotation = [1 0 0 i];
        pause(speed);
    end
end