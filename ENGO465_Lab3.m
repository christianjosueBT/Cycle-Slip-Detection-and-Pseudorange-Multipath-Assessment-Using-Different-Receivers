clear; home; close all;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define some values

% column index for observations
prnIndex = 1;
timeIndex = 2;
pseudorangeIndex = 3;
phaseIndex = 4;
dopplerIndex = 5;

% data paratemrers
numChannels = 24;
[c, fL1, wL1, fL2, wL2 ] = GetGPSConstants();

% value to subtract from time to make plots easier to read
timeOffset = 513000;

% flag
saveFigs = true;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle Slips (u-blox on roof) :: Raw Data

prn = 4;

% load the data
obsAll = ReadObs2Mtx( 'ublox_Base.obs', numChannels );
obs = obsAll( obsAll(:,prnIndex) == prn , : );

% predict the phase
dt = diff( obs(:,timeIndex) );
avgDoppler = ( obs(1:end-1,dopplerIndex) + obs(2:end,dopplerIndex) ) / 2;
predPhase =  avgDoppler .* dt + obs(1:end-1,phaseIndex);

% plot
PlotPhasePrediction( obs, predPhase, timeOffset, 'u-blox Receiver on Roof' )
if saveFigs, 
    print('Cycle Slips (u-blox on roof) - Raw Data', '-dpng');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skip Slips (u-blox on roof) :: Skipping Epochs

% epochs to skip
epochsToSkip = 2;

% skip every other measurement...
obs2 = obsAll( obsAll(:,prnIndex) == prn , : );
obs2 = obs2(1:epochsToSkip:end,:);
dt2 = diff( obs2(:,timeIndex) );
avgDoppler2 = ( obs2(1:end-1,dopplerIndex) + obs2(2:end,dopplerIndex) ) / 2;
predPhase2 =  avgDoppler2 .* dt2 + obs2(1:end-1,phaseIndex);
time2 = (obs2(2:end,2)-obs2(1,2))/60;
time1 = (obs(2:end,2)-obs(1,2))/60;

figure('Position', [460, 100, 1300, 850]); hold on;
plot( time2, predPhase2 - obs2(2:end,phaseIndex),'b.','markersize', 10);
plot( time1, predPhase  - obs(2:end,phaseIndex) ,'r.','markersize', 10);
zoom on; grid on;
ylim( 5 * [-1 1] ) 
ylabel( '\bfPrediction Error [cyc]  ' );
xlabel('Duration of Data Collection [min]');
legend( 'Skipping Epochs', 'Original Data' );
set(gca, 'fontweight', 'bold', 'fontsize', 14);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skip Slips (u-blox on roof) :: Adding Noise

% Doppler noise standard deviation in m/s
noiseStd = 0.1;

% add a bit of noise to the Doppler
sigmaDoppler = noiseStd / wL1;  % numerator has units of m/s
obs(:,dopplerIndex) = obs(:,dopplerIndex) + randn(size(obs,1),1) * sigmaDoppler;
dtN = diff( obs(:,timeIndex) );
avgDopplerN = ( obs(1:end-1,dopplerIndex) + obs(2:end,dopplerIndex) ) / 2;
predPhaseN =  avgDopplerN .* dtN + obs(1:end-1,phaseIndex);
time2 = (obs2(2:end,2) - obs2(1,2))/60;
time1 = (obs(2:end,2) - obs(1,2))/60;

figure('Position', [460, 100, 1300, 850]); hold on;
plot( time2, predPhase2 - obs2(2:end,phaseIndex),'b.','markersize', 10);
plot( time1, predPhaseN - obs(2:end,phaseIndex) ,'g.','markersize', 10 );
plot( time1, predPhase  - obs(2:end,phaseIndex) ,'r.','markersize', 10 ); 
zoom on; grid on;
set(gca, 'fontweight', 'bold', 'fontsize', 14);
ylim( 5 * [-1 1] ) 
ylabel( '\bfPrediction Error [cyc]  ' );
xlabel( 'Duration of Data Collection [min]');
legend( 'Skip an Epoch ', 'Noisier Doppler ', 'Original Data ' )

if saveFigs, 
    print('Skip Slips (u-blox on roof) - Adding Noise', '-dpng');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle Slips (u-blox in field)

prn = 4;

% load the data
obs = ReadObs2Mtx( 'ublox_Remote.obs', numChannels );
obs = obs( obs(:,prnIndex) == prn , : );

% limit the time
tMax = timeOffset + 4000;
obs = obs( obs(:,timeIndex) < tMax , : );

dt = diff( obs(:,timeIndex) );
avgDoppler = ( obs(1:end-1,dopplerIndex) + obs(2:end,dopplerIndex) ) / 2;
predPhase =  avgDoppler .* dt + obs(1:end-1,phaseIndex);

PlotPhasePrediction( obs, predPhase, timeOffset, ['\bfu-blox Receiver in Field for PRN ', num2str(prn)] )
if saveFigs, 
    print('Cycle Slips (u-blox in field)', '-dpng');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cycle Slips (NovAtel in field)

prn = 4;

% load the data
obs = ReadObs2Mtx( 'NovAtel_Remote.obs', numChannels );
obs = obs( obs(:,prnIndex) == prn , : );

% limit the time
tMax = timeOffset + 4000;
obs = obs( obs(:,timeIndex) < tMax , : );

dt = diff( obs(:,timeIndex) );
avgDoppler = ( obs(1:end-1,dopplerIndex) + obs(2:end,dopplerIndex) ) / 2;
predPhase =  avgDoppler .* dt + obs(1:end-1,phaseIndex);

PlotPhasePrediction( obs, predPhase, timeOffset, ['\bfNovAtel Receiver in field for PRN ', num2str(prn)] )
if saveFigs, 
    print('Cycle Slips (NovAtel in field)', '-dpng');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code Minus Carrier (CMC) - Roof - High Multipath


tMin = 514180;
tMax = 515670;

prn = 32; % 23 has a more noticeable slope (before removing the trend)

% u-blox in field
uRem = ReadObs2Mtx( 'ublox_Base.obs', numChannels );
uRem = uRem( uRem(:,prnIndex) == prn , : );
uRem = uRem( uRem(:,timeIndex) > tMin , : );
uRem = uRem( uRem(:,timeIndex) < tMax , : );
uRemCMC = uRem(:,pseudorangeIndex) + uRem(:,phaseIndex) * wL1;

% plot the 'raw' code-minus-carrier
time =  (uRem(:,2)-uRem(1,2))/60;
figure('Position', [460, 100, 1300, 850]); 
hold on; grid on;
plot( uRem(:,2)-timeOffset, uRemCMC, 'k' );
ylabel( '\bf Raw Code-Minus-Carrier [m]' );
xlabel('Duration of Data Collection [min]');
set(gca, 'fontweight', 'bold', 'fontsize', 14, 'YTickLabel', num2str(get(gca, 'YTick')', '%.1f'));

% Trend removal

PlotCMC( {uRem(:,2)}, {uRemCMC}, timeOffset, {'u-blox'},...
    ['\bfReceiver on Roof for PRN ', num2str(prn), ': High Multipath'], saveFigs,...
    ['Code Minus Carrier - Roof - High Multipath'], prn );

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code Minus Carrier (CMC) - Field - High Multipath

tMax = 518720;

prn = 32;

% u-blox in field
uRem = ReadObs2Mtx( 'ublox_Remote.obs', numChannels );
uRem = uRem( uRem(:,prnIndex) == prn , : );
uRem = uRem( uRem(:,timeIndex) < tMax , : );
uRemCMC = uRem(:,pseudorangeIndex) + uRem(:,phaseIndex) * wL1;

% NovAtel in field
nRem = ReadObs2Mtx( 'NovAtel_Remote.obs', numChannels );
nRem = nRem( nRem(:,prnIndex) == prn , : );
nRem = nRem( nRem(:,timeIndex) < tMax , : );
nRemCMC = nRem(:,pseudorangeIndex) + nRem(:,phaseIndex) * wL1;

PlotCMC( { uRem(:,2) , nRem(:,2) }, { uRemCMC, nRemCMC }, timeOffset,...
    {'u-blox','NovAtel'}, ['\bfReceiver in Field for PRN ', num2str(prn), ': High Multipath'], saveFigs,...
    ['Code Minus Carrier - Field - High Multipath'], prn);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code Minus Carrier (CMC) - Field - Low Multipath

tMax = 518720;

prn = 23;

% u-blox in field
uRem = ReadObs2Mtx( 'ublox_Remote.obs', numChannels );
uRem = uRem( uRem(:,prnIndex) == prn , : );
uRem = uRem( uRem(:,timeIndex) < tMax , : );
uRemCMC = uRem(:,pseudorangeIndex) + uRem(:,phaseIndex) * wL1;

% NovAtel in field
nRem = ReadObs2Mtx( 'NovAtel_Remote.obs', numChannels );
nRem = nRem( nRem(:,prnIndex) == prn , : );
nRem = nRem( nRem(:,timeIndex) < tMax , : );
nRemCMC = nRem(:,pseudorangeIndex) + nRem(:,phaseIndex) * wL1;

PlotCMC( { uRem(:,2) , nRem(:,2) }, { uRemCMC, nRemCMC }, timeOffset,...
    {'u-blox','NovAtel'}, ['\bfReceiver in Field for PRN ', num2str(prn), ': Low Multipath'], saveFigs,...
    ['Code Minus Carrier - Field - Low Multipath'], prn );




