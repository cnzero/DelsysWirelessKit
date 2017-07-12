classdef DelsysM <  handle
	properties
		interfaceObjects = {}
							% {1} -- common interface
							% {2} -- EMG interface
							% {3} -- ACC interface
		dataEMG = []  % -- current tcpip cache
		chEMG = []    % -- channel sequence of EMG
		dataACC = []  % -- current tcpip cache
		chEMG = []    % -- channel sequence of ACC
	end

	events
		eventEMGChanged
		eventACCChanged
	end

	methods
		% Construct
		function obj = DelsysM()
			HOST_IP = '127.0.0.1';
			obj.interfaceObjects ={... % common
								   tcpip(HOST_IP, 50040), ...
								   ... % EMG
					   			   tcpip(HOST_IP, 50041, ...
								   'InputBufferSize', 64000, ...
								   'BytesAvailableFcnMode', 'byte', ...
								   'BytesAvailableFcnCount', 1728*5, ...
								   'BytesAvailableFcn', {@obj.NotifyEMG}) ...
								   ... % ACC
								   tcpip(HOST_IP, 50042, ...
								   	'InputBufferSize', 64000, ...
								   	'BytesAvailableFcnMode', 'byte', ...
								   	'BytesAvailableFcnCount', 384*5, ...
								   	'BytesAvailableFcn', {obj.NotifyACC}) ...
								   };
		end
		
		% -- events trigger [EMG]
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
				% ---=== notify to save 
				obj.notify('eventEMGChanged');
			catch error
				disp('Connection error or tcpip object has been closed.');
			end
		end

		% -- event trigger [ACC]
		function NotifyACC(obj, source, event)
			% -- acquire [dataACC] from tcpip cache
			% -- ===ACC
			bytesReady = obj.interfaceObjects{3}.BytesAvailable;
			bytesReady = bytesReady - mod(bytesReady, obj.interfaceObjects{3}.BytesAvailableFcnCount);
			if (bytesReady == 0)
				return
			end
			try
				data = cast(fread(obj.interfaceObjects{3}, bytesReady), 'uint8');
				obj.dataACC = typecast(data, 'single');
				obj.notify('eventACCChanged');
			catch error
				disp('Connection error or tcpip object has been closed.');
			end
		end

		% ---=== Start() & Stop()
		function Start(obj, EMG=[], ACC=[])
			% -- open common interfaceObject
			try
				fopen(obj.interfaceObjects{1});
			catch
				error('Open common interface error');
			end

			% -- input parameters dependent settings.
			% -- open EMG interfaceObject
			if !isempty(EMG)
				obj.chEMG = EMG;
				try
					fopen(obj.interfaceObjects{2});
				catch
					error('Open EMG interface error');
				end
			end
			% -- open ACC interfaceObject
			if !isempty(ACC)
				obj.chACC = ACC;
				try
					fopen(obj.interfaceObjects{3});
					
				catch
					error('Open ACC interface error.');
				end
			end
			disp('Success to Open necessary interfaces');

			% -- START
			try
				fprintf(obj.interfaceObjects{1}, sprintf(['START\r\n\r']));
			catch
				error('Fail to start device and Connection error.');
			end

			disp('Success to start Delsys Hardware device.');
		end
		function Stop(obj)
			% -- close common interfaceObject
			try
				fclose(obj.interfaceObjects{1});
			catch
				error('Close common interface error');
			end

			% -- input parameters dependent settings.
			% -- close EMG interfaceObject
			if !isempty(obj.chEMG)
				try
					fclose(obj.interfaceObjects{2});
				catch
					error('Close EMG interface error');
				end
			end
			% -- close ACC interfaceObject
			if !isempty(obj.chACC)
				try
					fclose(obj.interfaceObjects{3});
				catch
					error('Close ACC interface error.');
				end
			end
			disp('Success to stop tcpip Connection');
		end
	end % -- [methods]
end % -- [class]