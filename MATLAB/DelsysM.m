classdef DelsysM <  handle
	properties
		interfaceObjects = {}
		sEMG = [] % -- used for being saved
		dataEMG = []  % -- current tcpip cache
		dataAxesEMG = [] % -- used for Axes smoothing display
		t = []
	end

	events
		eventEMGChanged
	end

	methods
		% Construct
		function obj = DelsysM()
			HOST_IP = '127.0.0.1';
			obj.interfaceObjects ={...
								   tcpip(HOST_IP, 50040), ...   % common
					   			   tcpip(HOST_IP, 50041, ...    % EMG
								   'InputBufferSize', 64000, ...
								   'BytesAvailableFcnMode', 'byte', ...
								   'BytesAvailableFcnCount', 1728*5, ...
								   'BytesAvailableFcn', {@obj.NotifyEMG}) ...
								   };

		end
		
		% -- events trigger
		function NotifyEMG(obj, source, event)
			% --acquire [dataEMG] from tcpip cache 
			% ---===EMG
			bytesReady = obj.interfaceObjects{2}.BytesAvailable;
			bytesReady = bytesReady - mod(bytesReady, obj.interfaceObjects{2}.BytesAvailableFcnCount);
			if (bytesReady == 0)
				return
			end
			try
				data = cast(fread(obj.interfaceObjects{2}, bytesReady), 'uint8');
				obj.dataEMG = typecast(data, 'single');
				obj.sEMG = [obj.sEMG; ...
							obj.dataEMG];
				% ---=== notify to save 
				obj.notify('eventEMGChanged');
				obj.t = [obj.t; toc];
			catch error
				disp('Connection error or tcpip object has been closed.');
			end
		end

		% ---=== Start() & Stop()
		function Start(obj)
			try
				fopen(obj.interfaceObjects{1});
				fopen(obj.interfaceObjects{2});
				fprintf(obj.interfaceObjects{1}, sprintf(['START\r\n\r']));
			catch
				error('Connection error.');
			end
		end
		function Stop(obj)
			try
				fclose(obj.interfaceObjects{1});  % common
				fclose(obj.interfaceObjects{2});  % EMG
			catch
				error('Dis-connection error');
			end
			disp('try to stop tcpip Connection');
		end
	end
end