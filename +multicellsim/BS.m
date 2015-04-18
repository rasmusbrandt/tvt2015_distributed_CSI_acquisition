% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% multicellsim - A framework for multicell simulation %
%																											%
% Rasmus Brandt <rabr5411@kth.se>											%
% KTH Signal Processing																%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% BS
%
% Class that describes a base station (BS)
classdef BS < multicellsim.User
	methods
		
		% Constructor
		function self = BS(no_antennas, position)
			if nargin == 0
				super_args = {};
			elseif nargin == 1
				super_args{1} = no_antennas;
			elseif nargin > 1
				super_args{1} = no_antennas;
				super_args{2} = position;
			end
			
			self = self@multicellsim.User(super_args{:});
		end
	end
end