function [obsData] = ReadObs2Mtx( filePath, numChannels, timeOffset )

%-------------------------------------------------------------------------%
% Filename:             ReadObs2Mtx.m
% 
% Start date:           11Feb11
% Originator:           Billy Chan (BCW)
% 
% Purpose of file:      Read Observation File (*.obs)
%                     
% Arguments:
%   filePath            Location of file                 (example: C:\Data\data.obs)
%   numChannels         Number of channels               (default: 12 channels per epoch)
%   
% Returns:
%   obsData             Observations in matrix form
%                     
%-------------------------------------------------------------------------%

if nargin < 2
    numChannels = 12;       %12 channels per epoch
end

if nargin < 3
   timeOffset = 0;
end

%open file
fid =                   fopen( filePath, 'rb' );
if fid < 1
    error( strcat( 'Input file could not be read: ' , filePath ) ); 
end

% read file
obsData = fread( fid, [6,Inf], 'double' )';

% adjust time
obsData(:,2) = obsData(:,2) - timeOffset;

%close file
fclose( fid );