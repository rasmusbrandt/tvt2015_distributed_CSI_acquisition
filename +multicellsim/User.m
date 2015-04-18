% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% multicellsim - A framework for multicell simulation %
%																											%
% Rasmus Brandt <rabr5411@kth.se>											%
% KTH Signal Processing																%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% User
%
% Class that describes a generic user (receiver or transmitter)
classdef User < handle
	properties
		
		% String describing the name of the user
		name = '';
		
		% Number of antennas that this user has
		no_antennas = 1;
		
		% Position of user
		position = [0 0];
		
	end % properties

	methods
		
		% Constructor
		function self = User(no_antennas, position)
			if nargin == 0
				return;
			elseif nargin == 1
				self.no_antennas = no_antennas;
			elseif nargin == 2
				self.no_antennas = no_antennas;
				self.position    = position;
			end
		end

	end % methods
end % classdef