%%
load('./results_all.mat')
load('./SimulationData_RetiredBattery.mat')

%% Figure.4 (a) cyclelife
batch_order = {'B1','B2','B7','B8','B11','B12', 'B3','B4','B5',...
    'B6','B9','B10','B13','B14','B15','B17', ...
    'B16','B18','B19','B20','B21'};

color1 = hex2rgb( '2727FF');
color2 = hex2rgb( 'FF0E0E');

cyclelife_all = zeros(4,21);
cyclelife_cali_all = zeros(4, 21);
for batch_number = 1:21
    for Battery_number = 1:4
        cyclelife_all(Battery_number, batch_number) = ...
            SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife;
        cyclelife_cali_all(Battery_number, batch_number) = ...
            min(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife,...
            SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction  );
        
    end
end

plot_order = [1, 2, 7, 8, 11, 12, 3, 4, 5, ...
    6, 9, 10, 13, 14, 15, 17,...
    16, 18, 19, 20, 21];
cyclelife_batch_order = cyclelife_all(:, plot_order);
cyclelife_cali_batch_order = cyclelife_cali_all(:, plot_order);

figureUnits = 'centimeters';
figureWidth = 35;
figureHeight = 8*3;

figure1 = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 5 figureWidth figureHeight]);

%
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.720288706843255 0.775 0.24]);

hold(axes1,'on');
hold on
withd = 2.5;
p1 = 0.5:withd:withd*length(cyclelife_all);
p2 = 1.5:withd:withd*length(cyclelife_cali_all);
b1 = boxplot(cyclelife_batch_order,'positions',p1,'Colors','k','Widths',0.7,'Symbol','o');
b2 = boxplot(cyclelife_cali_batch_order,'positions',p2,'Colors','k','Widths',0.7,'Symbol','o');

boxobj = findobj(gca, 'Tag', 'Box');
for i = [22, 1]
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > 21
        CA = color1;
    else
        CA = color2;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',0.1,'LineWidth',1);
end

for i = 1:length(boxobj)
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > 21
        CA = color1;
    else
        CA = color2;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',0.2,'LineWidth',1);
end

delete(b1,b2)
b1 = boxplot(cyclelife_batch_order,'positions',p1, ...
    'Colors',color1,'Widths',0.7, 'Symbol','o');
b2 = boxplot(cyclelife_cali_batch_order,'positions',...
    p2,'Colors',color2,'Widths',0.7,'Symbol','o');

XTick_position = (p1+p2)/2;
set(gca,'XTick', XTick_position);
set(gca,'XTickLabel', batch_order);

ylabel('Cycle number');
xlim([-1, XTick_position(end)+2]);
ylim([0, 2300]);

x1 = (XTick_position(6) + XTick_position(7))/2;
x2 = (XTick_position(16) + XTick_position(17))/2;

plot([x1, x1], [0, 2200], 'k--');
plot([x2, x2], [0, 2200], 'k--');

legend1 = legend({'Before calibration', 'After calibration'}, 'Box', 'off',...
    'FontName','Arial','FontSize',10, 'Location', 'north', 'NumColumns', 1,...
    'Position',[0.762960874495968,0.507738795003674,0.128780241935484,0.044636296840558],...
    'Orientation','horizontal',...
    'FontSize',11.5);

set(gca,'FontName','Arial','FontSize',10);
box off
ax = gca;
ax.TickDir = 'out';


position_subfig = [];
position_subfig(1) = axes1.Position(1)+0.615;
position_subfig(2) = axes1.Position(2)+0.072;
position_subfig(3) = axes1.Position(3)-0.6250;
position_subfig(4) = axes1.Position(4)-0.099;

handaxes2 = axes('Units','normalized','Position', position_subfig);


hold on
subfig_index = 17:21;
withd = 2.5;
p1 = 0.5:withd:withd*length(cyclelife_all(subfig_index));
p2 = 1.5:withd:withd*length(cyclelife_cali_all(subfig_index));
b1 = boxplot(cyclelife_batch_order(:, subfig_index),'positions',p1,'Colors','k','Widths',0.7,'Symbol','o');
b2 = boxplot(cyclelife_cali_batch_order(:, subfig_index),'positions',p2,'Colors','k','Widths',0.7,'Symbol','o');

boxobj = findobj(gca, 'Tag', 'Box');
for i = 1:length(boxobj)
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > length(boxobj)/2
        CA = color1;
    else
        CA = color2;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',0.2,'LineWidth',1);
end

delete(b1,b2)
b1 = boxplot(cyclelife_batch_order(:, subfig_index),'positions',p1, ...
    'Colors',color1,'Widths',0.7, 'Symbol','o');
b2 = boxplot(cyclelife_cali_batch_order(:, subfig_index),'positions',...
    p2,'Colors',color2,'Widths',0.7,'Symbol','o');

XTick_position = (p1+p2)/2;
set(gca,'XTick', XTick_position);
set(gca,'XTickLabel', batch_order(subfig_index),'FontName','Arial','FontSize',8, ...
    'TickDir', 'out');
xlim([-0.5, XTick_position(end)+1.5]);
box off

% second figure
batch_order = {'B1','B2','B7','B8','B11','B12', 'B3','B4','B5',...
    'B6','B9','B10','B13','B14','B15','B17', ...
    'B16','B18','B19','B20','B21'};

batch_cluster_order{1} = {'B1','B2','B7','B8','B11','B12'};
batch_cluster_order{2} = { 'B3','B4','B5','B6','B9','B10','B13','B14','B15','B17'};
batch_cluster_order{3} = {'B16','B18','B19','B20','B21'};
batch_cluster_order{4} = batch_order;
cluster_order = {'cluster1', 'cluster2', 'cluster3', 'all'};
cluster_order_name = {'Cluster 1', 'Cluster 2', 'Cluster 3', 'All results'};


for cluster_number = 1:4
    RMSE_all = zeros(2, 4);
    MAE_all = zeros(2, 4);
    R2_all = zeros(2, 4);
    
    for batch_number = 1:length(batch_cluster_order{cluster_number})
        for validation_number = 1:4
            RMSE_all(1, validation_number) = ...
                result_nocali.(cluster_order{cluster_number})(validation_number).rmse;
            MAE_all(1, validation_number) = ...
                result_nocali.(cluster_order{cluster_number})(validation_number).mae;
            R2_all(1, validation_number) = ...
                result_nocali.(cluster_order{cluster_number})(validation_number).r2;
            RMSE_all(2, validation_number) = ...
                result_cali.(cluster_order{cluster_number})(validation_number).rmse;
            MAE_all(2, validation_number) = ...
                result_cali.(cluster_order{cluster_number})(validation_number).mae;
            R2_all(2, validation_number) = ...
                result_cali.(cluster_order{cluster_number})(validation_number).r2;
        end
    end
    
    %
    subplot(3, 5, 5+cluster_number)
    
    hold on
    score = [mean(RMSE_all'); mean(MAE_all')]
    ngroups = size(score,1);
    nbars = size(score,2);
    groupwidth = min(0.8, nbars/(nbars+1.5));
    bar1 = bar(1:2, score, 'BarWidth',0.7, 'LineWidth',1.2,'FaceAlpha', 0.12)
    
    set(bar1(1),...
        'FaceColor',color1, 'EdgeColor',color1);
    set(bar1(2),...
        'FaceColor',color2, 'EdgeColor',color2);
    
    
    error = [std(RMSE_all'); std(MAE_all')];
    for i = 1:nbars
        x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
        for j = 1:ngroups
            errorbar1 = errorbar(x(j),score(j,i), error(j,i), 'k--','linewidth',1);
        end
    end
    lim_y_ = [200, 200, 22, 205];
    ylim([0, lim_y_(cluster_number)])
    box off
    
    % scatter
    outside_parameter = 0.035;
    x1 = ones(4, 1)-0.15 + outside_parameter * randn(4, 1);
    scatter(x1, RMSE_all(1,:),'MarkerEdgeColor', hex2rgb('1B1BC0'), ...
        'LineWidth',1.2);
    x2 = ones(4, 1)+0.15 + outside_parameter * randn(4, 1);
    scatter(x2, RMSE_all(2,:), '^','MarkerEdgeColor', hex2rgb('B90101'), ...
        'LineWidth',1.2);
    x3 = 2*ones(4, 1)-0.15 + outside_parameter * randn(4, 1);
    scatter(x3, MAE_all(1,:),'MarkerEdgeColor', hex2rgb('1B1BC0'), ...
        'LineWidth',1.2);
    x4 = 2*ones(4, 1)+0.15 + outside_parameter * randn(4, 1);
    scatter(x4, MAE_all(2,:), '^','MarkerEdgeColor', hex2rgb('B90101'), ...
        'LineWidth',1.2);
    
    title(cluster_order_name{cluster_number});
    ylabel({'Error'});
    xticks([1 2]);
    xticklabels({'RMSE', 'MAE'});
    % set(errorbar1,'MarkerSize',8,'Marker','+','LineWidth',1.5);
    set(gca,'FontName','Arial','FontSize',10, 'TickDir', 'out');

end




%%

axes3 = axes('Parent',figure1,...
    'Position',[0.132309417944928 0.065 0.28 0.27]);
hold(axes3,'on');

hold on
R2_all_nocali = zeros(4, 4);
R2_all_cali = zeros(4, 4);
for cluster_number = 4:-1:1

    for batch_number = 1:length(batch_cluster_order{cluster_number})
        for validation_number = 1:4
            R2_all_nocali(cluster_number, validation_number) = ...
                result_nocali.(cluster_order{cluster_number})(validation_number).r2;
            R2_all_cali(cluster_number, validation_number) = ...
                result_cali.(cluster_order{cluster_number})(validation_number).r2;
        end
    end
end
outside_parameter = 0.2;
R2_nocali = mean(R2_all_nocali');
err1 = std(R2_all_nocali');
x1 = [2, 4, 6, 8];
b1 = bar(x1, R2_nocali, 'Horizontal', 'on', 'BarWidth', 0.35);
errorbar(R2_nocali,x1,err1,'k','horizontal', 'LineStyle', 'None', 'LineWidth', 1)
for i = 1:4
    scatter(R2_all_nocali(:, i), x1+outside_parameter * randn(1, 4),...
        'MarkerEdgeColor', hex2rgb('1B1BC0'), 'LineWidth', 1.2)
end
x_begin = 0.015;
text(x_begin, x1(1), 'All results - Before calibration')
text(x_begin, x1(2), 'Cluster 3 - Before calibration')
text(x_begin, x1(3), 'Cluster 2 - Before calibration')
text(x_begin, x1(4), 'Cluster 1 - Before calibration')


R2_cali = mean(R2_all_cali');
err2 = std(R2_all_cali');

x2 = [1, 3, 5, 7];
b2 = bar(x2, R2_cali, 'Horizontal', 'on', 'BarWidth', 0.35);
errorbar(R2_cali,x2,err2,'k','horizontal', 'LineStyle', 'None', 'LineWidth', 1)
for i = 1:4
    scatter(R2_all_cali(:, i), x2+outside_parameter * randn(1, 4), '^',...
        'MarkerEdgeColor', hex2rgb('B90101'), 'LineWidth', 1.2)
end

text(x_begin, x2(1), 'All results - After calibration')
text(x_begin, x2(2), 'Cluster 3 - After calibration')
text(x_begin, x2(3), 'Cluster 2 - After calibration')
text(x_begin, x2(4), 'Cluster 1 - After calibration')

set(b1, 'EdgeColor',color1, 'FaceColor', 'None', 'LineWidth', 1.2);
set(b2, 'EdgeColor',color2, 'FaceColor', 'None', 'LineWidth', 1.2);

ylim([0.35, 8.65])
set(gca,'yTickLabel', [], 'TickDir', 'out')
xlabel({'R^2'});
%


%%

axes4 = axes('Parent',figure1,...
    'Position',[0.46720727556787 0.065 0.19 0.27]);
hold on

pred_B21_nocali = result_nocali.B21(1).pred;
label_B21_nocali = result_nocali.B21(1).label;
label = 1:length(pred_B21_nocali);
scatter(label_B21_nocali, pred_B21_nocali, ...
    'MarkerFaceColor', hex2rgb('4B4BE6'), ...
    'MarkerFaceAlpha', 0.3, ...
    'MarkerEdgeColor', hex2rgb('4B4BE6'), ...
    'LineWidth', 0.3, 'SizeData', 45)

plot(label, label, 'k--', 'LineWidth', 1.2)
[rmse, mae, mape, r2] = score_all(label_B21_nocali, pred_B21_nocali);


text('Parent',axes4,'Units','normalized',...
    'String',['RMSE: ', num2str(round(rmse, 4)), newline,...
    '   MAE: ' , num2str(round(mae, 4)),newline,...
    '     R^2: ' , num2str(round(r2, 4))],...
    'Position',[0.262061631360853,0.194774572830316,0],...
    'HorizontalAlignment', 'Center');


text('Parent',axes4,'Units','normalized',...
    'String','B18 - Battery01', ...
    'Position',[0.74,0.73,0],...
    'VerticalAlignment', 'middle',...
    'HorizontalAlignment', 'center');

set(gca,'XDir','reverse')
xlim([0,length(label)])
ylim([0,length(label)])
xlabel('True RUL')
ylabel('Predicted RUL')

legend({'Preditions', 'Labels'}, 'box', 'off','FontSize',10)
set(gca,'FontName','Arial','FontSize',10, 'TickDir', 'out');
title('Before calibration','FontSize',11)

%

axes5 = axes('Parent',figure1,...
    'Position',[0.715473790322582 0.065 0.19 0.27]);

hold(axes5,'on');

hold on

pred_B21_cali = result_cali.B21(1).pred;
label_B21_cali = result_cali.B21(1).label;
label = 1:length(pred_B21_cali);
scatter(label_B21_cali, pred_B21_cali, '^', ...
    'MarkerFaceColor', hex2rgb('FF3D3D'), ...
    'MarkerFaceAlpha', 0.12, ...
    'MarkerEdgeColor', hex2rgb('FF3D3D'), ...
    'LineWidth', 0.12, 'SizeData', 60)

plot(label, label, 'k--', 'LineWidth', 1.2)
[rmse, mae, mape, r2] = score_all(label_B21_cali, pred_B21_cali);

text('Parent',axes5,'Units','normalized',...
    'String',['RMSE: ', num2str(round(rmse, 4)), newline,...
    '   MAE: ' , num2str(round(mae, 4)),newline,...
    '       R^2: ' , num2str(round(r2, 4))],...
    'Position',[0.262061631360853,0.194774572830316,0],...
    'HorizontalAlignment', 'Center');

text('Parent',axes5,'Units','normalized',...
    'String','B18 - Battery01', ...
    'Position',[0.73,0.73,0],...
    'VerticalAlignment', 'middle',...
    'HorizontalAlignment', 'center');

set(gca,'XDir','reverse')
xlim([0,length(label)])
ylim([0,length(label)])

xlabel('True RUL')
ylabel('Predicted RUL')
legend({'Preditions', 'Labels'}, 'box', 'off','FontSize',10)
set(gca,'FontName','Arial','FontSize',10, 'TickDir', 'out');
title('After calibration','FontSize',12)

%%
function [rmse, mae, mape, r2] = score_all(y_true, y_pred)

    rmse = sqrt(mean((y_true - y_pred).^2));
    mae = mean(abs(y_true - y_pred));
    mape = mean(abs(y_true - y_pred)./y_true);
    r2 = 1 - (sum((y_pred- y_true).^2) / sum((y_true - mean(y_true)).^2));

end

function rgb = hex2rgb(hexColor)
    r = hex2dec(hexColor(1:2));
    g = hex2dec(hexColor(3:4));
    b = hex2dec(hexColor(5:6));
    rgb = [r, g, b]./255;
end
