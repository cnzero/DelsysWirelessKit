function smoveHipOut(world_handles) 
	J0 = 0.15;
	J1 = -0.1;
	J2 = -0.6;
	speed = 0.01;
    human_reset_front(world_handles);
    youdatui = world_handles.youdatui;
    
    % - It is a STATE, rather than a on-going course.
    youdatui.rotation = [0 0 1 J2];
%     for i=J0:J1:J2
%         youdatui.rotation = [0 0 1 i];
%         pause(speed);
%     end
end