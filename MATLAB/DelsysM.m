classdef DelsysM <  handle
	properties
		interfaceObjects = {}
							% {1} -- common interface
							% {2} -- EMG interface
							% {3} -- ACC interface
		dataEMG = []  % -- current tcpip cache
		chEMG = []    % -- channel sequence of EMG
		dataACC = []  % -- current tcpip cache
		chACC = []    % -- channel sequence of ACC

		statusBusy = 0
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
								   	'BytesAvailableFcn', {@obj.NotifyACC}) ...
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
				dataEMG = typecast(data, 'single');
				% -- channel selection
				dataEMG = reshape(dataEMG, 16, []); % - points in one row from the same sEMG channel
											% - Dimension explanation
											% - 1st, channel number
											% - 2nd, a row vector of sequence depending on time
				obj.dataEMG = dataEMG(obj.chEMG, :);

				obj.notify('eventEMGChanged');
				% disp('NotifyEMG');
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
				dataACC = typecast(data, 'single');
				% -- channel selection - bit complex for x-y-z axis
				dataACC = reshape(dataACC, 16, 3, []); % - points in one row from the same IMU channel
											% - 1st, channel number
											% - 2nd, x=1, y=2, z=3
											% - 3rd, a row vector of sequence depending on time. 
				obj.dataACC = dataACC(obj.chACC, :, :); % Detailed description to read [docDelsysM.md]

				% so, all point of a channel on an axis at a period of all time
				% d = obj.dataACC(x, ch, :)

				obj.notify('eventACCChanged');
			catch error
				disp('Connection error or tcpip object has been closed.');
			end
		end

		% ---=== Start() & Stop()
		function Start(obj, varargin)
			% - Input parameters parse
			EMG = [];
			ACC = [];
			if nargin < 2
				EMG = [];
				ACC = [];
			elseif nargin == 2
				EMG = varargin{1};
			elseif nargin == 3
				EMG = varargin{1};
				ACC = varargin{2};
	        else
	        	error('Dis-matched input parameters');
	        end
			% -- open common interfaceObject
			try
				fopen(obj.interfaceObjects{1});
			catch
				error('Open common interface error');
			end

			% -- input parameters dependent settings.
			% -- open EMG interfaceObject
			if ~isempty(EMG)
				obj.chEMG = EMG;
				try
					fopen(obj.interfaceObjects{2});
				catch
					error('Open EMG interface error');
				end
			end
			% -- open ACC interfaceObject
			if ~isempty(ACC)
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
			obj.statusBusy = 1;
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
			if ~isempty(obj.chEMG)
				try
					fclose(obj.interfaceObjects{2});
				catch
					error('Close EMG interface error');
				end
			end
			% -- close ACC interfaceObject
			if ~isempty(obj.chACC)
				try
					fclose(obj.interfaceObjects{3});
				catch
					error('Close ACC interface error.');
				end
			end
			disp('Success to stop tcpip Connection');
			obj.statusBusy = 0;
		end
	end % -- [methods]
end % -- [class]