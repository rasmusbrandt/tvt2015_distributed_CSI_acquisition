% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% multicellsim - A framework for multicell simulation %
%																											%
% Rasmus Brandt <rabr5411@kth.se>											%
% KTH Signal Processing																%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Channel
%
% Channel that describes the channel between a transmitter and a
% receiver. Several realizations and subcarriers can be stored
% in a multidimensional matrix, the coefficients property.
classdef Channel < handle
	properties
		
		% Name of this channel
		name = '';
		
		% Handles to the receiver and transmitter users on either end
		receiver;
		transmitter;
		
		% Mr-by-Mt-by-Nt-by-Nf small scale fading coefficient matrix. 
		% Mr - number of receive antennas
		% Mt - number of transmit antennas
		% Nt - number of channel realizations
		% Nf - number of frequency points
		coefficients; 
		
		% Vector of time instances for the realizations
		times;
		
		% Vector of frequency points for the subcarriers
		freqs;
		
	end % properties

	methods
		
		% Constructor
		function self = Channel(coefficients)
			if nargin == 1
				self.coefficients = coefficients;
			end
		end
		
		
		% Sets the transmitter of the channel
		function set_transmitter(self,tx)
			if isa(tx,'multicellsim.BS')
				if (size(self.coefficients,2) == tx.no_antennas)
					self.transmitter = tx;
				else
					error('Inconsistent number of Tx antennas.');
				end
			else
				error('Not a BS instance.');
			end
		end
		
		
		% Sets the receiver of the channel
		function set_receiver(self,rx)
			if isa(rx,'multicellsim.MS')
				if (size(self.coefficients,1) == rx.no_antennas)
					self.receiver = rx;
				else
					error('Inconsistent number of Rx antennas.');
				end
			else
				error('Not a MS instance.');
			end
		end
		
		
		% Returns number of transmit antennas of the channel
		function Mt = no_tx_antennas(self)
			Mt = size(self.coefficients,2);
		end
		
		
		% Returns the number of receive antennas of the channel
		function Mr = no_rx_antennas(self)
			Mr = size(self.coefficients,1);
		end

		
		% Replaces the coefficients of the channel
		function set_coefficients(self,coefficients)
			if all(size(coefficients) == size(self.coefficients))
			   self.coefficients = coefficients;
			else
				error('Cannot change dimensions of channel. Create a new channel instead.');
			end
		end
		
		
		% Plots the channel frequency response as a function of frequency point
		function plot_response_freqs(self,id_real)
			[Mr,Mt,Nt,Nf] = size(self.coefficients);
			
			if ((nargin == 1) && (Nt ~= 1))
				error('Specify which realization to plot.');
			elseif (nargin == 1)
				id_real = 1;
			end
			
			% Get domain
			if(isempty(self.freqs))
				freqs = 1:Nf;
			else
				freqs = self.freqs;
			end
			
			% Plot it
			figure;
			p = 1;
			for n = 1:Mr
				for m = 1:Mt
					subplot(Mr,Mt,p); p = p + 1;
					plot(freqs,squeeze(20*log10(abs(self.coefficients(n,m,id_real,:)))));
				end
			end
		end
		
		
		% Plots the channel frequency response as a function of realization
		function plot_response_times(self,id_freq)
			[Mr,Mt,Nt,Nf] = size(self.coefficients);
			
			if ((nargin == 1) && (Nf ~= 1))
				error('Specify which frequency bin to plot.');
			elseif (nargin == 1)
				id_freq = 1;
			end
			
			% Get domain
			if(isempty(self.times))
				times = 1:Nt;
			else
				times = self.times;
			end
			
			% Plot it
			figure;
			p = 1;
			for n = 1:Mr
				for m = 1:Mt
					subplot(Mr,Mt,p); p = p + 1;
					plot(times,squeeze(20*log10(abs(self.coefficients(n,m,:,id_freq)))));
				end
			end
		end
		
		
		% Plots the channel frequency response as function of time and frequency
		function plot_response_times_freqs(self)
			[Mr,Mt,Nt,Nf] = size(self.coefficients);
			
			if ((Nt == 1) || (Nf == 1))
				error('The channel should be defined both in time and frequency.');
			end
			
			% Get domain
			if(isempty(self.freqs))
				freqs = 1:Nf;
			else
				freqs = self.freqs;
			end
			if(isempty(self.times))
				times = 1:Nt;
			else
				times = self.times;
			end
			
			% Plot it
			[F,T] = meshgrid(freqs,times);
			figure;
			p = 1;
			for n = 1:Mr
				for m = 1:Mt
					subplot(Mr,Mt,p); p = p + 1;
					surf(T,F,squeeze(20*log10(abs(self.coefficients(n,m,:,:)))));
				end
			end
		end
		
		
		% Plots the channel impulse response
		function plot_taps(self,id_real)
			[Mr,Mt,Nt,~] = size(self.coefficients);
			
			if ((nargin == 1) && (Nt ~= 1))
				error('Specify which realization to plot.');
			elseif (nargin == 1)
				id_real = 1;
			end
			
			% Get the taps
			Hfreq = squeeze(self.coefficients(:,:,id_real,:));
			Htaps = ifft(Hfreq,[],3); % 4th dimension is now 3rd
			
			% Plot it
			figure;
			p = 1;
			for n = 1:Mr
				for m = 1:Mt
					subplot(Mr,Mt,p); p = p + 1;
					stem(squeeze(abs(Htaps(n,m,:))).^2);
				end
			end
		end
		
		
	end % methods
end % classdef