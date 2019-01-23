% main.m
%
% Author: Ilker GURCAN
%
% Description:
%   Used to test Tone Mapping Operator (TMO) from Fattal et. al. Check out
%   Gradient Domain High Dynamic Range Compression @2002 article for
%   details.

close all;
clear all;

inputFolder  = 'input';
outputFolder = 'output';
inputFile    = 'vinesunset.hdr';  % memorial

% Hyper parameters
alphaFact    = 0.005;  % Will multiplied by the average grad. magnitude
beta         = 0.85; % Attenuates/Amplifies larger/smaller magnitudes
bound        = 'neumann'; % Either 'dirichlet' or 'neumann'
lowestImSize = 32;  % Lowest image size in the Gauss Pyramid
lowPassKS    = 5;  % Low pass filter's kernel size for downsampling process
s            = 0.6; % Color saturation factor [0.4, 0.6]

% Read HDR image
image = hdrread(fullfile(inputFolder, inputFile));
% Tone-map the image
tStart = tic();
I = gradCompr(...
    image,...
    alphaFact,...
    beta,...
    bound,...
    lowestImSize,...
    lowPassKS,...
    s);
tElapsed = toc(tStart);
% I = tonemap(image);
fileName = strsplit(inputFile, '.');
outName  = [fileName{1}, '.jpeg'];
fprintf(...
    'Total time for %s is %.6f secs\n',...
    fileName{1},...
    tElapsed);
imwrite(I, fullfile(outputFolder, outName));
imshow(I);
