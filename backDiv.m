function [ div ] = backDiv( Ga )
% backDiv.m
%
% Author: Ilker GURCAN
%
% Description:
%   Applies divergence operator to the input using backward finite
%   difference.
% Input:
%   Ga : Attenuated gradient map.
%
% Output:
%   div: Output of divergence operator applied to the input 'Ga' 
%       in backward direction.
%
% Usage:
%   [div]=backDiv(Ga)

gX  = [-1, 1, 0];
gY  = [-1; 1; 0];
Gx  = imfilter(Ga.Gx, gX, 'same');
Gy  = imfilter(Ga.Gy, gY, 'same');
div = Gx+Gy;

end

