function PlotCMC( time, cmc, timeOffset, rxID, optionalTitle, saveFigs, FigName, prn )

if nargin < 5
    optionalTitle = '';
end

% check input
if size(time) ~= size( cmc )
    error 'Inputs must be the same length';
end
colors = {'b', 'g'};

if(length(time) ==2)
    h(1) = figure('Position', [460, 100, 1300, 850]);
end

for i = 1:length( time )       
    figure('Position', [460, 100, 1300, 850]); hold on;
    h2 = title([rxID{i}, ' ', optionalTitle]); 
    set(h2, 'fontweight', 'bold', 'fontsize', 14);
    
    t = time{i};
    t = t - mean(t);
    
    plottime = (time{i}-time{i}(1))/60;
    
    val = cmc{i};
    
    % determining coefficients for trend
    coef = polyfit( t, val - val(1), 2 );
    
    subplot(2,1,1);
    plot( plottime, val, 'color',colors{i}, 'linewidth', 1.5 );
    hold on;
    plot( plottime, polyval( coef, t ) + val(1), 'k', 'linewidth', 1.5);
    zoom on;
    hold on; grid on;
    set(gca, 'YTickLabel', num2str(get(gca, 'YTick')', '%.1f'));    
    set(gca, 'fontweight', 'bold', 'fontsize', 14);
    ylabel( '\bfCode-Minus-Carrier [m]' );
    legend(sprintf( '%s - Code Minus Carrier', rxID{i} ), sprintf( '%s - Trend', rxID{i} ), 'location', 'best');
    
    
    subplot(2,1,2);
    plot( plottime, val - val(1) - polyval( coef, t ),'color',colors{i}, 'linewidth', 1.5 );
    zoom on; grid on;
    hold on;
    ylabel( sprintf('De-Trended\nCode-Minus-Carrier [m]'));
    xlabel('Duration of Data Collection [min]');
    set(gca, 'fontweight', 'bold', 'fontsize', 14);
    legend(rxID{i});
    
    if saveFigs,
        print([FigName,' ', rxID{i}, ' PRN ', num2str(prn)], '-dpng');
    end
    
    
    if(length( time )==2)
        figure(h(1)); hold on; title( [rxID{1}, ' & ', rxID{2}, ' ', optionalTitle(1:11), 's', optionalTitle(12:end)]);
        plot( plottime, val - val(1) - polyval( coef, t ), 'color',colors{i}, 'linewidth', 1.5 );
        LElem{i} = rxID{i};
        zoom on; grid on;
        hold on;
        set(gca, 'fontweight', 'bold', 'fontsize', 14);
        ylabel( 'De-Trended Code-Minus-Carrier [m]');
        xlabel('Duration of Data Collection [min]');
        legend(LElem);
        
        if saveFigs,
            print([FigName,' PRN ', num2str(prn)], '-dpng');
        end
    end
end
end

