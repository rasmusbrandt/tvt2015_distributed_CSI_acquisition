% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% multicellsim - A framework for multicell simulation %
%																											%
% Rasmus Brandt <rabr5411@kth.se>											%
% KTH Signal Processing																%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% SyntheticChannel
%
% Subclass of Channel which describes a synthetically generated channel.
classdef SyntheticChannel < multicellsim.Channel
	properties
		
		% Channel model
		model_name;
		
		% Parameters (struct)
		model_parameters;
		
	end % properties

	methods
		
		
		% Constructor
		function self = SyntheticChannel(coefficients)
			self = self@multicellsim.Channel(coefficients);
		end
		
		
	end % methods
end % classdef