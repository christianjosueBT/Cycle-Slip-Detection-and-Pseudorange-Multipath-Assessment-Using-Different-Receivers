function [Cgps, freqL1, wavelengthL1, freqL2, wavelengthL2, freqL5, wavelengthL5] = GetGPSConstants()


%-------------------------------------------------------------------------%
% Filename:             GetGPSConstants.m
% 
% Start date:           4Nov09
% Originator:           Billy Chan
% 
% Purpose of file:      Provides constants for GPS signals
%                     
% Arguments:            none
%
% Returns:
%   C                   Speed of light      [m/s]
%   freqL1              Frequency of L1     [Hz]
%   wavelengthL1        Wavelength of L1    [m]
%   freqL2              Frequency of L2     [Hz]
%   wavelengthL2        Wavelength of L2    [m]
%   freqL5              Frequency of L5     [Hz]
%   wavelengthL5        Wavelength of L5    [m]
%                     
%-------------------------------------------------------------------------%

Cgps =                  299792458.0;    %Speed of light for GPS  [m/s]

freqL1 =                1575.42e6;      %Frequency of L1 signal  [Hz]
wavelengthL1 =          Cgps/freqL1;    %wavelength of L1 signal [m]

freqL2 =                1227.60e6;      %Frequency of L2 signal  [Hz]
wavelengthL2 =          Cgps/freqL2;    %wavelength of L2 signal [m]

freqL5 =                1176.45e6;      %Frequency of L5 signal  [Hz]
wavelengthL5 =          Cgps/freqL5;    %wavelength of L5 signal [m]