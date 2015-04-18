% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% multicellsim - A framework for multicell simulation %
%																											%
% Rasmus Brandt <rabr5411@kth.se>											%
% KTH Signal Processing																%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Network
%
% The Network class represents a network of transmitter and receivers, and
% the corresponding channels. Multiple realizations can be access through
% the receivers, transmitters and channel objects. I.e., the Network knows
% about multiple channel realizations, but has no particular data storage
% by itself for them.
classdef Network < handle
	
	properties
		% Name of the network
		name = '';
		
		% Handles to receivers, transmitters and corresponding channels
		receivers;
		transmitters;
		channels;
		
		% Geography type: 'canonical', 'hexagonal', 'triangular'
		geography_type;
		
		% Network model
		model_name;
		
		% Parameters (struct)
		model_parameters;
	end % properties

	methods
		% Adds a receiver to the network
		function set_receiver(self, id, rx)
			if isa(rx, 'multicellsim.MS')
				self.receivers{id} = rx;
			else
				error('Not a MS instance.');
			end
		end
		
		
		% Returns number of receivers in network
		function K = get_no_receivers(self)
			K = length(self.receivers);
		end
		
		
		% Adds a transmitter to the network
		function set_transmitter(self, id, tx)
			if isa(tx, 'multicellsim.BS')
				self.transmitters{id} = tx;
			else
				error('Not a BS instance.');
			end
		end
		
		
		% Returns the number of transmitters in the network
		function Kt = get_no_transmitters(self)
			Kt = length(self.transmitters);
		end
		
		
		% Adds a channel to the network
		function set_channel(self, id_rx, id_tx, channel)
			if isa(channel, 'multicellsim.Channel')
				self.channels{id_rx, id_tx} = channel;
			else
				error('Not a Channel instance.');
			end
		end
		
		
		% Returns the network in multidimensional matrix format
		% times_no is a K-by-Nt matrix describing with Nt time indices to pick
		% out for the K different receivers. This is to do randomized channel playback.
		% freqs_no is a 1-by-Nf vector describing which frequency points to
		% pick out for all users.
		function H = as_matrix(self, times_no, freqs_no)
			% Network parameters
			Kr   = self.get_no_receivers();
			Kt   = self.get_no_transmitters();
			Mr   = size(self.channels{1,1}.coefficients,1);
			Mt   = size(self.channels{1,1}.coefficients,2);
			
			if nargin == 1
				Nt = size(self.channels{1,1}.coefficients,3);
				Nf = size(self.channels{1,1}.coefficients,4);
				times_no = 1:Nt; freqs_no = 1:Nf;
			elseif nargin == 2
				Nt = size(times_no,2);
				Nf = size(self.channels{1,1}.coefficients,4);
				freqs_no = 1:Nf;
			elseif nargin == 3
				Nt = size(times_no,2);
				Nf = length(freqs_no);
			end
			
			% If times_no given as row vector, multiplex it for all users
			if (size(times_no,1) == 1)
				tvec = times_no;
				times_no = zeros(Kr,length(tvec));
				for k = 1:Kr
					times_no(k,:) = tvec;
				end
			end
			
			% Preallocate channel
			H = zeros(Mr,Mt,Kr,Kt,Nt,Nf);
			
			% Build channel matrix
			for k = 1:Kr
				for l = 1:Kt
					H(:,:,k,l,:,:) = self.channels{k,l}.coefficients(:,:,times_no(k,:),freqs_no);
				end
			end
		end
		
		
		% Returns the network in multidimensional matrix format. The frequency
		% bins are used for frequency extensions
		function Hfe = as_freq_ext_matrix(self, times_no)
			% Get regular matrix
			if nargin == 1
				H = self.as_matrix();
			else
				H = self.as_matrix(times_no);
			end
			[Mr,Mt,Kr,Kt,Nt,Nf] = size(H);

			% Make block diagonal
			Hfe = zeros(Mr*Nf,Mt*Nf,Kr,Kt,Nt);
			for m = 1:Nf
				Hfe((m-1)*Mr+1:m*Mr,(m-1)*Mt+1:m*Mt,:,:,:) = H(:,:,:,:,:,m);
			end
		end
		
		
		% Creates a matrix for a "Full CoMP" network, where there is 
		% only one transmitter
		function Hjp = as_joint_proc_matrix(self, times_no, freqs_no)
			% Normal network matrix
			if nargin == 1
				H = self.as_matrix();
			elseif nargin == 2
				H = self.as_matrix(times_no);
			elseif nargin == 3
				H = self.as_matrix(times_no, freqs_no);
			end
			
			% Normal network dimensions
			[Mr,Mt,Kr,Kt,Nt,Nf] = size(H);
			
			% Joint processing network dimensions
			Njp = Mr; Mjp = Kt*Mt; Krjp = Kr; Ktjp = 1; Ntjp = Nt; Nfjp = Nf;
			Hjp = zeros(Njp,Mjp,Krjp,Ktjp,Ntjp,Nfjp);
			
			% Stack channel matrices
			for l = 1:Kt
				Hjp(:,(l-1)*Mt+1:l*Mt,:,:,:,:) = H(:,:,:,l,:,:);
			end
		end
				
		
		% Creates a frequency extended matrix for a "Full CoMP" network
		function Hjp_fe = as_freq_ext_joint_proc_matrix(self, times_no)
			% Get CoMP matrix
			if nargin == 1
				Hjp = self.as_CoMP_matrix();
			else
				Hjp = self.as_CoMP_matrix(times_no);
			end
			[Mr,Mt,Kr,Kt,Nt,Nf] = size(Hjp);
			
			% Make block diagonal
			Hjp_fe = zeros(Mr*Nf,Mt*Nf,Kr,Kt,Nt);
			for m = 1:Nf
				Hjp_fe((m-1)*Mr+1:m*Mr,(m-1)*Mt+1:m*Mt,:,:,:) = Hjp(:,:,:,:,:,m);
			end
		end
		
		
		% Plots the geography of transmitters and receivers of the network
		function [BS_pos, MS_pos] = plot_geography(self)
			% Network parameters
			Kr = self.get_no_receivers();
			Kt = self.get_no_transmitters();
			
			% Get positions
			MS_pos = zeros(Kt,2);
			for k = 1:Kr
				MS_pos(k,:) = self.receivers{k}.position;
			end
			BS_pos = zeros(Kt,2);
			for l = 1:Kt
				BS_pos(l,:) = self.transmitters{l}.position;
			end
			
			figure; hold on;

			if(strcmp(self.geography_type,'hexagonal') || strcmp(self.geography_type,'triangular'))
				xo_BS = 25; xo_MS = 25;
				yo_BS = 25; yo_MS = 25;
			elseif(strcmp(self.geography_type,'canonical'))
				xo_BS = 1; xo_MS = -2;
				yo_BS = 0; yo_MS = 0;
			end
			% Plot BSs with descriptive text
			for l = 1:Kt
				plot(BS_pos(l,1),BS_pos(l,2),'.b');
				text(BS_pos(l,1) + xo_BS, BS_pos(l,2) + yo_BS, ['BS ' num2str(l)], 'FontSize', 14);
			end

			% Plot MSs
			for k = 1:Kr
				plot(MS_pos(k,1), MS_pos(k,2), 'xr');
				text(MS_pos(k,1) + xo_MS, MS_pos(k,2) + yo_MS, ['MS ' num2str(k)], 'FontSize', 14);
			end
			
			% Plot cell boundaries, if cellular network
			inter_site_distance = sqrt((BS_pos(1,1) - BS_pos(2,1))^2 + (BS_pos(1,2) - BS_pos(2,2))^2);
			cell_radius = inter_site_distance/sqrt(3);
			if(strcmp(self.geography_type,'hexagonal'))
				for l = 1:Kt
					pos = zeros(2,6);
					
					for edge = 1:7 % hard coded since we are doing hexagonal cells!
						% Find initial position for this edge
						rot_angle_deg = (edge-1)*60; rot_angle_rad = rot_angle_deg*pi/180;
						rot_mat = [cos(rot_angle_rad) -sin(rot_angle_rad) ; 
											 sin(rot_angle_rad)  cos(rot_angle_rad) ];
						pos(:,edge) = BS_pos(l,:).' + cell_radius*rot_mat*[1;0];
					end
				
					plot(pos(1,:),pos(2,:),'b-');
					% voronoi(BS_pos(:,1),BS_pos(:,2));
				end
			elseif(strcmp(self.geography_type,'triangular'))
				% Triangular outline
				plot([BS_pos(:,1);BS_pos(1,1)],[BS_pos(:,2);BS_pos(1,2)],'b-');
				
				% Cell edges
				pts = [0;-inter_site_distance/(2*sqrt(3))];
				rot_angle_deg = 120; rot_angle_rad = rot_angle_deg*pi/180;
				rot_mat = [cos(rot_angle_rad) -sin(rot_angle_rad) ; 
									 sin(rot_angle_rad)  cos(rot_angle_rad) ];
								 
				plot([0 pts(1)], [0 pts(2)], 'b--');
				pts = rot_mat*pts;
				plot([0 pts(1)], [0 pts(2)], 'b--');
				pts = rot_mat*pts;
				plot([0 pts(1)], [0 pts(2)], 'b--');		
			end
		end
		
		
		% Plots the coordination sets
		function plot_coordination_set(self,C,D)
			% Plot cell geography
			[BS_pos, MS_pos] = self.plot_geography();
			
			% Plot coordination sets from BS perspective
			for l = 1:self.get_no_transmitters()
				Cl = find(C(:,l) == 1)';
				Dl = find(D(:,l) == 1)';
				
				% Get different colours for different BSs
				switch mod(l,6)
					case 0, c = '--g';
					case 1, c = '--r';
					case 2, c = '--c';
					case 3, c = '--m';
					case 4, c = '--y';
					case 5, c = '--k';
				end
				
				for k = Cl
					if ~any(Dl == k)
						% Do not plot intra-cluster coordination
						plot([BS_pos(l,1) MS_pos(k,1)],[BS_pos(l,2) MS_pos(k,2)],c);
					end
				end
			end
		end
		
		
		% Returns a matrix where entry (k,l) is the average channel gain (over
		% time and frequency) between Tx l and Rx k 
		function ch_norms2 = get_average_channel_norms_squared(self)
			H = self.as_matrix();
			[~,~,Kr,Kt,Nt,Nf] = size(H);

			ch_norms2 = zeros(Kr,Kt);

			for k = 1:Kr
				for l = 1:Kt
					for ii_times = 1:Nt
						for ii_freqs = 1:Nf
							ch_norms2(k,l) = ch_norms2(k,l) + (1/(Nt*Nf))*norm(H(:,:,k,l,ii_times,ii_freqs),'fro')^2;
						end
					end
				end
			end
		end
		
		
		% Returns a matrix where entry (k,l) is the distance (in meters)
		% between Rx k and Tx l
		function distances = get_distances(self)
			% Network size
			Kr = length(self.receivers); Kt = length(self.transmitters);
			
			% Output container
			distances = zeros(Kr,Kt);
			
			for k = 1:Kr
				for l = 1:Kt
					pos_MS = self.receivers{k}.position;
					pos_BS = self.transmitters{l}.position;
					
					distances(k,l) = sqrt((pos_MS(1) - pos_BS(1))^2 + (pos_MS(2) - pos_BS(2))^2);
				end
			end
		end
		
		
		% Returns a matrix where entry (k,l) is the distance (in meters)
		% between Rx k and Tx l for the wrap-around model
		function distances = get_wraparound_distances(self)
			% Network size
			Kr = length(self.receivers); Kt = length(self.transmitters);
			
			% Distance function
			df = @(p1,p2) sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2);
			
			% Inter-cell distance
			pos_BS1 = self.transmitters{1}.position; pos_BS2 = self.transmitters{2}.position;
			D = df(pos_BS1,pos_BS2);
			
			% Output container
			distances = zeros(Kr,Kt);
			
			for k = 1:Kr
				for l = 1:Kt
					pos_MS = self.receivers{k}.position;
					pos_BS = self.transmitters{l}.position;
					
					% Wrap-around distances
					d1 = df(pos_MS,pos_BS);
					d2 = df(pos_MS,pos_BS + [+3*D/sqrt(3)   +4*D   ]);
					d3 = df(pos_MS,pos_BS + [-3*D/sqrt(3)   -4*D   ]);
					d4 = df(pos_MS,pos_BS + [+4.5*D/sqrt(3) -7*D/2 ]);
					d5 = df(pos_MS,pos_BS + [-4.5*D/sqrt(3) +7*D/2 ]);
					d6 = df(pos_MS,pos_BS + [+7.5*D/sqrt(3) +D/2   ]);
					d7 = df(pos_MS,pos_BS + [-7.5*D/sqrt(3) -D/2   ]);
					
					distances(k,l) = min([d1 d2 d3 d4 d5 d6 d7]);
				end
			end
		end
		
		
		% Returns a matrix where entry (k,l) is the angle (radians)
		% between Rx k and Tx l, given bore sights in bore_sights
		function angles = get_angles(self,bore_sights)
			% Network size
			Kr = length(self.receivers); Kt = length(self.transmitters);
			
			% Angle function
			af = @(BSp,MSp) atan2(MSp(2) - BSp(2), MSp(1) - BSp(1));
			
			% Output container
			angles = zeros(Kr,Kt);
			
			for l = 1:Kt
				pos_BS = self.transmitters{l}.position;
				for k = 1:Kr
					pos_MS = self.receivers{k}.position;

					angles(k,l) = af(pos_BS,pos_MS) - bore_sights(l);
				end
			end
		end
		
	end % methods
end % classdef