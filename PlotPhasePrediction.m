function PlotPhasePrediction( obs, predPhase, timeOffset, optionalTitle )

if nargin < 4
   optionalTitle = '';
end

phaseIndex = 4;

figure('Position', [460, 100, 1300, 850]); hold on;
h1 = title( optionalTitle); 
set(h1, 'fontsize', 14, 'fontweight', 'bold' );
time = (obs(2:end,2)-obs(1,2))/60;


h(1) = subplot(2,1,1);
plot( time, predPhase - obs(2:end,phaseIndex),'b.', 'markersize', 10 );
zoom on; grid on;
ylabel( '\bfPrediction Error [cyc]' );
ylim( 5 * [-1 1] ) 
set( gca, 'fontweight', 'bold', 'fontsize', 14);

h(2) = subplot(2,1,2);
plot( time, diff( obs(:,2) ),'b.', 'markersize', 10 );
zoom on; grid on;
ylabel( '\bfTime Diff [s]' );
ylim( 5 * [-1 1] ) 
xlabel('Duration of Data Collection [min]' );

xMin = max( min( get(h(1),'XLim') ), min( get(h(2),'XLim') ) );
xMax = min( max( get(h(1),'XLim') ), max( get(h(2),'XLim') ) );

set( h, 'XLim', [ xMin xMax ] );
set(gca, 'fontweight', 'bold', 'fontsize', 14);
linkaxes( h, 'x' );

