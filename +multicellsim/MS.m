% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% multicellsim - A framework for multicell simulation %
%																											%
% Rasmus Brandt <rabr5411@kth.se>											%
% KTH Signal Processing																%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% MS
%
% Class that describes a mobile station (BS)
classdef MS < multicellsim.User
	properties
		velocity = 0;
	end % properties
	
	methods
		
		
		% Constructor
		function self = MS(no_antennas, position, velocity)
			if nargin == 0
				super_args = {};
			elseif nargin == 1
				super_args{1} = no_antennas;
			elseif nargin > 1
				super_args{1} = no_antennas;
				super_args{2} = position;
			end
			
			self = self@multicellsim.User(super_args{:});
			
			if nargin > 2
				self.velocity = velocity;
			end
		end
		
		
	end
end
