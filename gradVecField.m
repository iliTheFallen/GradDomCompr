function [ Gx, Gy ] = gradVecField( H, bound )
% gradVecField.m
%
% Author: Ilker GURCAN
%
% Description:
%   Calculates the gradient vector field of given luminance map after
%   transforming it into log space. Remember that forward finite difference
%   method is used for calculating the gradient.
% Input:
%   H : Luminance map for corresponding HDR image in log domain. Size of 
%       MxN.
%   bound : Boundary condition to be satisfied. Either 'dirichlet' or
%       'neumann' is valid.
%
% Output:
%   Gx : Gradient vector field for luminance channel of the input HDR
%   image along x direction in log domain.
%   Gy : Gradient vector field for luminance channel of the input HDR
%   image along y direction in log domain.
%
% Usage:
%   [Gx, Gy]=gradVecField(lumMap)

switch bound
    case 'dirichlet'
        H = padarray(H, [1 1], 0, 'both');
    case 'neumann'
        H = padarray(H, [1 1], 'replicate', 'both');
    otherwise
        fprintf('Unsupported boundary condition %s', bound);
        me = MException(...
            'gradVecField:NoSuchBound',...
            '%s is not a valid boundary condition',...
            bound);
    throw(me)
end

% Find the gradient of log-luminance map using forward finite difference
gX = [0, -1, 1];
gY = [0; -1; 1];
Gx = imfilter(H, gX, 'same');
Gy = imfilter(H, gY, 'same');
Gx = Gx(2:end-1, 2:end-1);
Gy = Gy(2:end-1, 2:end-1);

end

