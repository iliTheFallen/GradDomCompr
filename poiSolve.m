function [ I ] = poiSolve( div )
% poiSolve.m
%
% Author: Ilker GURCAN
%
% Description:
%   Applies divergence operator to the input using backward finite
%   difference.
% Input:
%   div : Divergence map calculated at each pixel location
%
% Output:
%   I : Image corresponding to the solution of Poisson equation with
%   right-hand side equal to the input parameter 'div'.
%
% Usage:
%   [I]=poiSolve(div)

[r, c] = size(div);
t      = r*c;
allOne = ones(t, 1);
% Laplacian operator
L =...
    spdiags(-4.*allOne, 0, t, t)+...  % -4*I(x, y)
    spdiags(allOne, -1, t, t)+...     % I(x, y-1)
    spdiags(allOne,  1, t, t)+...     % I(x, y+1)
    spdiags(allOne, -r, t, t)+...     % I(x-1, y)
    spdiags(allOne,  r, t, t);        % I(x+1, y)
L(1, 1)     = -2;
L(end, end) = -2;
% Image data may not be of type 'double'
if(~isa(div, 'double'))
    div = double(div);
end
% Make it the right-hand side of the equation
div = reshape(div, [t, 1]);
% Solve sparse linear equation system for I
I = L \ div;
% Recover the image shape
I = full(I);
I = reshape(I, [r, c]);

end

