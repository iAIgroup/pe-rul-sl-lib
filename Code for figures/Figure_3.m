%%
load('./SimulationData_RetiredBattery.mat')
load('./RetiredBatteryData.mat')

%% color setting

BuDRd_18 = [0.142000000000000,0,0.850000000000000;0.0970000000000000,0.112000000000000,0.970000000000000;0.160000000000000,0.342000000000000,1;0.240000000000000,0.531000000000000,1;0.340000000000000,0.692000000000000,1;0.460000000000000,0.829000000000000,1;0.600000000000000,0.920000000000000,1;0.740000000000000,0.978000000000000,1;0.920000000000000,1,1;1,1,0.920000000000000;1,0.948000000000000,0.740000000000000;1,0.840000000000000,0.600000000000000;1,0.676000000000000,0.460000000000000;1,0.472000000000000,0.340000000000000;1,0.240000000000000,0.240000000000000;0.970000000000000,0.155000000000000,0.210000000000000;0.850000000000000,0.0850000000000000,0.187000000000000;0.650000000000000,0,0.130000000000000];

color4 = hex2rgb('00a8e1');
color3 = hex2rgb('00994e');
color2 = hex2rgb('ff6600');
color1 = hex2rgb('fcd300');


color_all = [color1; color2; color3; color4];
color_all2 = [hex2rgb('50c48f '); hex2rgb('f5616f  '); hex2rgb('f7b13f  '); hex2rgb('9977ef ')];

gray_color = [0.5, 0.5, 0.5];
%%

figureUnits = 'centimeters';
figureWidth = 35;
figureHeight = 20;
type = 'compact';

figure1 = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight],...
    'Color', [1, 1, 1]);


%
batch_number = 5; 
Battery_number = 4;

xlim_ = 950;
axes1 = tsubplot(5, 6, [1, 2], type);
hold on

for Battery_number = 1:4
    SOH = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.SOH;
    plot(SOH, 'Color', color_all(Battery_number,:), 'LineWidth', 1.2)
end


for Battery_number = 1:4
    SOH = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.SOH;
    max_SOH_index = find(SOH<=0.6);
    scatter(max_SOH_index(1), 0.6, ...
        'MarkerEdgeColor', color_all(Battery_number,:), 'LineWidth', 1.2)
end
scatter(667, SOH(667),'^', 'r', 'SizeData', 50,...
    'MarkerEdgeColor', color_all(Battery_number,:), 'LineWidth', 1.2)

text(35, 0.63, 'EOL Threshold', ...
    'Color', 'k', 'FontName', 'Arial', 'FontSize', 10)

text('Parent',axes1,'HorizontalAlignment','center','FontSize',10,...
    'FontName','Arial',...
    'String',{'Calibrated EOL','for Battery04'},...
    'Position',[689.616053578564 0.827826086956522 0]);

plot([-3, xlim_], [0.6, 0.6], 'k--')
ylabel('SOH')

ylim([0.58, 0.9])
xlim([-3, xlim_])
set(gca,'FontName','Arial','FontSize',10.5, 'TickDir', 'out',...
    'YTickLabel',{'  0.6', '0.7','0.8','0.9'})



%
axes2 = tsubplot(5, 6, [7, 8], type);
hold on
smooth_level = 50;

for Battery_number = 1:4
    if batch_number == 3
        if length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0) <= 2100
            plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
        else
            plot_len = 2100;
        end
        if Battery_number ==4
            plot_len = 1746;
        elseif Battery_number ==2
            plot_len = 1742;
        else
            plot_len = 1500;
        end
    else
        plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
    end
    Ro = smooth(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0, smooth_level);
    plot(1:plot_len, Ro(1:plot_len),'-', 'Color', color_all(Battery_number,:), 'LineWidth', 1.2)
end

index_all = zeros(1,4);
for Battery_number = 1:4
    cyclelife_ = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife;
    if batch_number == 3
        if length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0) <= 2100
            plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
        else
            plot_len = 2100;
        end
        if Battery_number ==4
            plot_len = 1746;
        elseif Battery_number ==2
            plot_len = 1742;
        else
            plot_len = 1500;
        end
    else
        plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
    end
    Ro = smooth(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0, smooth_level);
    max_index = find(Ro==max(Ro(1:plot_len)));
    index_all(Battery_number) = max_index;
    scatter(max_index, max(Ro(1:plot_len)),'^', ...
        'MarkerEdgeColor', color_all(Battery_number,:), 'LineWidth', 1.2)
end

legend2 = legend({'Battery01', 'Battery02', 'Battery03', 'Battery04'}, ...
    'box', 'off','FontName','Arial','FontSize',10.5, 'NumColumns', 1, ...
    'Location', 'northwest')
set(legend2,...
   'Position',[0.101900621520834 0.533103134030633 0.160683898054478 0.0530225396095232],...
    'NumColumns',2);

xlabel('Cycle number')
ylabel('Cycle number')
ylabel('Estimated Ro')
xlim([-3, xlim_])
ylim([0.055, 0.105])
set(gca,'FontName','Arial','FontSize',10, 'TickDir', 'out')

%

annotation(figure1,'line',[0.245 0.245],...
    [0.674180327868852 0.919754098360655],...
    'Color',[1 0.0549019607843137 0.0549019607843137],...
    'LineWidth',1.2,...
    'LineStyle','-.');
set(gca,'FontName','Arial','FontSize',10.5);
%

%
axes1 = tsubplot(5, 11, [7, 8, 14, 15], type);
axis square;
hold on

batch_number = 5; %
Battery_number = 4;

SOC_start = Mid_SOC_all(batch_number) + DOD_all(batch_number)/2;
SOC_end = Mid_SOC_all(batch_number) - DOD_all(batch_number)/2;
xi = 1:-1/99:0;
line_number = 0;


cycle_number = [2, 201, 401, 601];
for i = cycle_number
    line_number = line_number+1;
    % simulation data
    simulation_v = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData(i).v;
    SOC = 1:-1/(length(simulation_v)-1):0;
    simulation_vi = spline(SOC, simulation_v, xi);   
    plot(xi, simulation_vi, 'Color',  color_all2(line_number,:), 'LineWidth', 1.2);

end

line_number = 0;
for i = cycle_number
    line_number = line_number+1;
    true_v = RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.Discharge_V_all(i,:);
    SOC_true = linspace(SOC_start, SOC_end, 100);
    true_vi = spline(SOC_true, true_v, SOC_true);
    plot(SOC_true, true_vi, '--', 'Color',  color_all2(line_number,:), 'LineWidth', 1.2)
%     plot(SOC_true, true_vi, '--', 'Color',  color_all2(line_number,:), 'LineWidth', 1.2)
end
xlabel('State of Charge')
ylabel('Voltage (V)')
ylim([2.75, 4.2])


xShadow = [SOC_start, SOC_start, SOC_end, SOC_end];
yShadow = [2.75, 3.68, 3.68, 2.75];
h1=patch(xShadow, yShadow,'c', 'FaceColor', gray_color ,...
    'FaceAlpha', 0.08, 'EdgeColor', 'none');



legend_all = {'Cycle 1', 'Cycle 200', 'Cycle 400', 'Cycle 600'};
legend3 = legend(legend_all, 'Box','off','FontName','Arial','FontSize',10.5);
set(legend3,...
    'Position',[0.377 0.533103134030633 0.160683898054478 0.0530225396095232],...
    'NumColumns',2);

set(gca,'XDir','reverse','FontName','Arial','FontSize',12, 'TickDir', 'out',...
    'FontName','Arial','FontSize',10.5,'XTick',[0 0.2 0.4 0.6 0.8 1])

annotation(figure1,'line',[0.375259875259875 0.534],...
    [0.96 0.96]);


annotation(figure1,'textbox',...
    [0.406444906444917 0.940598360655724 0.0977130977130871 0.0420081967213114],...
    'String','Simulation Voltage',...
    'FitBoxToText','off',...
    'EdgeColor','none',...
    'BackgroundColor',[1 1 1]);


annotation(figure1,'textbox',...
    [0.452 0.863754098360648 0.0691268191268173 0.0420081967213115],...
    'String',{'True voltage'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
%% heatmap for first line
%

figureUnits = 'centimeters';
figureWidth = 35;
figureHeight = 20;
type = 'compact';% tight

% figure1 = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight],...
    'Color', [1, 1, 1]);


batch_number = 5; %
Battery_number = 4;

axes1 = tsubplot(27, 7, [5:7:12*7+7]);


heatmap(flip(RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.Discharge_V_all(1:RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL, :), 2), ...
    'GridVisible', 'off')

title(['True Voltage (V)'])
xlabel('State of Charge')
ylabel('Cycle number')
ax = gca;
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
SOC_start = Mid_SOC_all(batch_number) + DOD_all(batch_number)/2;
SOC_end = Mid_SOC_all(batch_number) - DOD_all(batch_number)/2;
for i = 0:25:99
    scale = (SOC_end - SOC_start) / 100;
    offset = SOC_start - scale;
    ax.XDisplayLabels{i+1} = [num2str((scale * (i+1) + offset)*100), '%'];
end
ax.XDisplayLabels{100} = [num2str(SOC_end*100), '%'];
label_gap = round(size(ax.YDisplayData, 1)/6);
for i = label_gap:label_gap:(size(ax.YDisplayData)*0.95)
    ax.YDisplayLabels{i} = num2str(i);
end
ax.YDisplayLabels{size(ax.YDisplayData, 1)} = num2str(size(ax.YDisplayData, 1));
colormap(BuDRd_18); % BuDRd_18 YlGnBu8 Paired9 BuDOr_18  BuGr_14

FigurePosition = get(gca, 'InnerPosition')
axes3 = axes('Units','normalized','Position', FigurePosition, 'box', 'off', ...
    'Color', 'none');

corr_life = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction;
plot([0,100], [corr_life, corr_life], 'k--', 'LineWidth', 1.2)
xlim([0, 100])
ylim([0, size(ax.YDisplayData, 1)])
set(gca,'YDir','reverse')

set(axes3, 'box', 'off',  'Color', 'none','XColor','none','YColor','none')




% Simulation voltage
axes1 = tsubplot(27, 7, [6:7:12*7+7]);


v_all = [];
for i = 1:length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align)
    v_all = [v_all; SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align(i).v];
end
v_all(v_all>4.2)=4.2;
heatmap(flip(v_all(1:RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL, :), 2), 'GridVisible', 'off')

title(['Simulation Voltage (V)'])
xlabel('State of Charge')
ylabel('Cycle number')
ax = gca;
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
SOC_start = 1;
SOC_end = 0;
for i = 0:25:99
    scale = (SOC_end - SOC_start) / 100;
    offset = SOC_start - scale;
    ax.XDisplayLabels{i+1} = [num2str((scale * (i+1) + offset)*100), '%'];
end
ax.XDisplayLabels{100} = [num2str(SOC_end*100), '%'];

label_gap = round(size(ax.YDisplayData, 1)/6);
for i = label_gap:label_gap:(size(ax.YDisplayData)*0.95)
    ax.YDisplayLabels{i} = num2str(i);
end
ax.YDisplayLabels{size(ax.YDisplayData, 1)} = num2str(size(ax.YDisplayData, 1));
colormap(BuDRd_18); % BuDRd_18 YlGnBu8 Paired9 BuDOr_18  BuGr_14

FigurePosition = get(gca, 'InnerPosition')
axes3 = axes('Units','normalized','Position', FigurePosition, 'box', 'off', ...
    'Color', 'none');
%     axes3 = tsubplot(3, 7, batch_number)
%     set(axes3, 'box', 'off',  'Color', 'none')
corr_life = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction;
plot([0,100], [corr_life, corr_life], 'k--', 'LineWidth', 1.2)
xlim([0, 100])
ylim([0, size(ax.YDisplayData, 1)])
set(gca,'YDir','reverse')

set(axes3, 'box', 'off',  'Color', 'none','XColor','none','YColor','none')




% Ro
axes1 = tsubplot(27, 7, [7:7:12*7+7]);


Ro_all = [];
for i = 1:length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align)
    Ro_all = [Ro_all; SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align(i).Ro];
end
heatmap(flip(Ro_all(1:RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL, :), 2), 'GridVisible', 'off')

title(['Simulation Ro (Ω)'])
xlabel('State of Charge')
ylabel('Cycle number')
ax = gca;
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
SOC_start = 1;
SOC_end = 0;
for i = 0:25:99
    scale = (SOC_end - SOC_start) / 100;
    offset = SOC_start - scale;
    ax.XDisplayLabels{i+1} = [num2str((scale * (i+1) + offset)*100), '%'];
end
ax.XDisplayLabels{100} = [num2str(SOC_end*100), '%'];
label_gap = round(size(ax.YDisplayData, 1)/6);
for i = label_gap:label_gap:(size(ax.YDisplayData)*0.95)
    ax.YDisplayLabels{i} = num2str(i);
end
ax.YDisplayLabels{size(ax.YDisplayData, 1)} = num2str(size(ax.YDisplayData, 1));
colormap(BuDRd_18); % BuDRd_18 YlGnBu8 Paired9 BuDOr_18  BuGr_14

FigurePosition = get(gca, 'InnerPosition')
axes3 = axes('Units','normalized','Position', FigurePosition, 'box', 'off', ...
    'Color', 'none');
%     axes3 = tsubplot(3, 7, batch_number)
%     set(axes3, 'box', 'off',  'Color', 'none')
corr_life = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction;
plot([0,100], [corr_life, corr_life], 'k--', 'LineWidth', 1.2)
xlim([0, 100])
ylim([0, size(ax.YDisplayData, 1)])
set(gca,'YDir','reverse')

set(axes3, 'box', 'off',  'Color', 'none','XColor','none','YColor','none')

annotation(figure1,'textbox',...
    [0.60 0.642 0.0831600831600832 0.0409836065573771],...
    'String',{'Calibtated EOL'},...
    'FontSize',9.5,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.745 0.642 0.0831600831600833 0.0409836065573771],...
    'String',{'Calibtated EOL'},...
    'FontSize',9.5,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.885 0.642 0.0831600831600832 0.0409836065573771],...
    'String',{'Calibtated EOL'},...
    'FontSize',9.5,...
    'FitBoxToText','off',...
    'EdgeColor','none');


%% second line

figureUnits = 'centimeters';
figureWidth = 35;
figureHeight = 20;
type = 'compact';% tight

% figure1 = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight],...
    'Color', [1, 1, 1]);


batch_number = 12;
Battery_number = 2;

xlim_ = 400;
axes1 = tsubplot(10, 6, [31, 32, 37, 38], type);
hold on

for Battery_number = 1:4
    SOH = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.SOH;
    plot(SOH, 'Color', color_all(Battery_number,:), 'LineWidth', 1.2)
end


for Battery_number = 1:4
    SOH = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.SOH;
    max_SOH_index = find(SOH<=0.6);
    scatter(max_SOH_index(1), 0.6, ...
        'MarkerEdgeColor', color_all(Battery_number,:), 'LineWidth', 1.2)
end
scatter(187, SimulationData_RetiredBattery.(batch_name{batch_number})(2).Summary.SOH(187),'^', 'r', 'SizeData', 50,...
    'MarkerEdgeColor', color_all(2,:), 'LineWidth', 1.2)

text(35, 0.63, 'EOL Threshold', ...
    'Color', 'k', 'FontName', 'Arial', 'FontSize', 10)

text('Parent',axes1,'HorizontalAlignment','center','FontSize',10,...
    'FontName','Arial',...
    'String',{'Calibrated EOL for Battery02'},...
    'Position',[230.232421875 0.884563675609004 0]);

plot([-3, xlim_], [0.6, 0.6], 'k--')

ylabel('SOH')

ylim([0.58, 0.9])
xlim([-3, xlim_])
set(gca,'FontName','Arial','FontSize',10.5, 'TickDir', 'out',...
    'YTickLabel',{'  0.6', '0.7','0.8','0.9'})



% second line
axes2 = tsubplot(10, 6, [43, 44, 49, 50], type);
hold on
smooth_level = 5;

for Battery_number = 1:4
    if batch_number == 3
        if length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0) <= 2100
            plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
        else
            plot_len = 2100;
        end
        if Battery_number ==4
            plot_len = 1746;
        elseif Battery_number ==2
            plot_len = 1742;
        else
            plot_len = 1500;
        end
    else
        plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
    end
    Ro = smooth(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0, smooth_level);
    plot(1:plot_len, Ro(1:plot_len),'-', 'Color', color_all(Battery_number,:), 'LineWidth', 1.2)
end

index_all = zeros(1,4);
for Battery_number = 1:4
    cyclelife_ = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife;
    if batch_number == 3
        if length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0) <= 2100
            plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
        else
            plot_len = 2100;
        end
        if Battery_number ==4
            plot_len = 1746;
        elseif Battery_number ==2
            plot_len = 1742;
        else
            plot_len = 1500;
        end
    else
        plot_len = length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0);
    end
    Ro = smooth(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.R0, smooth_level);
    max_index = find(Ro==max(Ro(1:plot_len)));
    index_all(Battery_number) = max_index;
    scatter(max_index, max(Ro(1:plot_len)),'^', ...
        'MarkerEdgeColor', color_all(Battery_number,:), 'LineWidth', 1.2)
end

annotation(figure1,'line',[0.176195426195426 0.177754677754678],...
    [0.171131147540984 0.460040983606557],...
    'Color', color_all(2,:),...
    'LineWidth',1.2,...
    'LineStyle','-.');


legend2 = legend({'Battery01', 'Battery02', 'Battery03', 'Battery04'}, ...
    'box', 'off','FontName','Arial','FontSize',10.5, 'NumColumns', 1, ...
    'Location', 'northwest')
set(legend2,...
   'Position',[0.101900621520834 0.033103134030633 0.160683898054478 0.0530225396095232],...
    'NumColumns',2);

xlabel('Cycle number')
ylabel('Cycle number')
ylabel('Estimated Ro')
xlim([-3, xlim_])
ylim([0.055, 0.2])
set(gca,'FontName','Arial','FontSize',10, 'TickDir', 'out')

% second line
% axes1 = tsubplot(5, 11, [7, 8, 14, 15], type);
% axes1 = tsubplot(10, 6, [43, 44, 49, 50], type);
axes1 = tsubplot(10, 11, [59, 60, 72, 73, 83, 84, 94, 95], type);
axis square;
hold on
batch_number = 12;
Battery_number = 2;

SOC_start = Mid_SOC_all(batch_number) + DOD_all(batch_number)/2;
SOC_end = Mid_SOC_all(batch_number) - DOD_all(batch_number)/2;
xi = 1:-1/99:0;
line_number = 0;


% for i = [2,50:50:length(RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL)*0.8]
cycle_number = [2, 50, 100, 150];
for i = cycle_number
    line_number = line_number+1;
    % simulation data
    simulation_v = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData(i).v;
    SOC = 1:-1/(length(simulation_v)-1):0;
    simulation_vi = spline(SOC, simulation_v, xi);   
    plot(xi, simulation_vi, 'Color',  color_all2(line_number,:), 'LineWidth', 1.2);

end
line_number = 0;
for i = cycle_number
    line_number = line_number+1;
    true_v = RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.Discharge_V_all(i,:);
    SOC_true = linspace(SOC_start, SOC_end, 100);
    true_vi = spline(SOC_true, true_v, SOC_true);
    plot(SOC_true, true_vi, '--', 'Color',  color_all2(line_number,:), 'LineWidth', 1.2)
end
xlabel('State of Charge')
ylabel('Voltage (V)')
ylim([2.75, 4.2])


xShadow = [SOC_start, SOC_start, SOC_end, SOC_end];
yShadow = [2.75, 3.68, 3.68, 2.75];
h1=patch(xShadow, yShadow,'c', 'FaceColor', gray_color ,...
    'FaceAlpha', 0.08, 'EdgeColor', 'none');


legend_all = {'Cycle 1', 'Cycle 50', 'Cycle 100', 'Cycle 150'};
legend3 = legend(legend_all, 'Box','off','FontName','Arial','FontSize',10.5);
set(legend3,...
    'Position',[0.377 0.033103134030633 0.160683898054478 0.0530225396095232],...
    'NumColumns',2);
% position的格式为[left, bottom, width, height]

set(gca,'XDir','reverse','FontName','Arial','FontSize',12, 'TickDir', 'out',...
    'FontName','Arial','FontSize',10.5,'XTick',[0 0.25 0.5 0.75 1])

annotation(figure1,'line',[0.375259875259875 0.534],...
    [0.46 0.46]);


annotation(figure1,'textbox',...
    [0.406444906444917 0.440598360655724 0.0977130977130871 0.0420081967213114],...
    'String','Simulation Voltage',...
    'FitBoxToText','off',...
    'EdgeColor','none',...
    'BackgroundColor',[1 1 1]);


annotation(figure1,'textbox',...
    [0.412 0.363754098360648 0.0691268191268173 0.0420081967213115],...
    'String',{'True voltage'},...
    'FitBoxToText','off',...
    'EdgeColor','none');


%% heatmap for second line 
figureUnits = 'centimeters';
figureWidth = 35;
figureHeight = 20;
type = 'compact';% tight

% figure1 = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight],...
    'Color', [1, 1, 1]);



batch_number = 12;
Battery_number = 2;

% axes1 = tsubplot(27, 7, [13*7+7 :7 :(13+12)*7+7], type);
% axes1 = tsubplot(27, 7, [13*7+5 :7 :(13+12)*7+7], type);
axes1 = tsubplot(27, 7, [13*7+5 :7 :(13+12)*7+7], type);
% batch_number = 21

heatmap(flip(RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.Discharge_V_all(1:RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL, :), 2), ...
    'GridVisible', 'off')

title(['True Voltage (V)'])
xlabel('State of Charge')
ylabel('Cycle number')
ax = gca;
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
SOC_start = Mid_SOC_all(batch_number) + DOD_all(batch_number)/2;
SOC_end = Mid_SOC_all(batch_number) - DOD_all(batch_number)/2;
for i = 0:25:99
    scale = (SOC_end - SOC_start) / 100;
    offset = SOC_start - scale;
    ax.XDisplayLabels{i+1} = [num2str((scale * (i+1) + offset)*100), '%'];
end
ax.XDisplayLabels{100} = [num2str(SOC_end*100), '%'];
label_gap = round(size(ax.YDisplayData, 1)/6);
for i = label_gap:label_gap:(size(ax.YDisplayData)*0.95)
    ax.YDisplayLabels{i} = num2str(i);
end
ax.YDisplayLabels{size(ax.YDisplayData, 1)} = num2str(size(ax.YDisplayData, 1));
colormap(BuDRd_18); % BuDRd_18 YlGnBu8 Paired9 BuDOr_18  BuGr_14

FigurePosition = get(gca, 'InnerPosition')
axes3 = axes('Units','normalized','Position', FigurePosition, 'box', 'off', ...
    'Color', 'none');
%     axes3 = tsubplot(3, 7, batch_number)
%     set(axes3, 'box', 'off',  'Color', 'none')
corr_life = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction;
plot([0,100], [corr_life, corr_life], 'k--', 'LineWidth', 1.2)
xlim([0, 100])
ylim([0, size(ax.YDisplayData, 1)])
set(gca,'YDir','reverse')

set(axes3, 'box', 'off',  'Color', 'none','XColor','none','YColor','none')




% second line Simulation voltage
axes1 = tsubplot(27, 7, [13*7+6 :7 :(13+12)*7+7], type);
% batch_number = 21

v_all = [];
for i = 1:length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align)
    v_all = [v_all; SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align(i).v];
end
v_all(v_all>4.2)=4.2;
heatmap(flip(v_all(1:RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL, :), 2), 'GridVisible', 'off')

title(['Simulation Voltage (V)'])
xlabel('State of Charge')
ylabel('Cycle number')
ax = gca;
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
SOC_start = 1;
SOC_end = 0;
for i = 0:25:99
    scale = (SOC_end - SOC_start) / 100;
    offset = SOC_start - scale;
    ax.XDisplayLabels{i+1} = [num2str((scale * (i+1) + offset)*100), '%'];
end
ax.XDisplayLabels{100} = [num2str(SOC_end*100), '%'];
label_gap = round(size(ax.YDisplayData, 1)/6);
for i = label_gap:label_gap:(size(ax.YDisplayData)*0.95)
    ax.YDisplayLabels{i} = num2str(i);
end
ax.YDisplayLabels{size(ax.YDisplayData, 1)} = num2str(size(ax.YDisplayData, 1));
colormap(BuDRd_18); % BuDRd_18 YlGnBu8 Paired9 BuDOr_18  BuGr_14

FigurePosition = get(gca, 'InnerPosition')
axes3 = axes('Units','normalized','Position', FigurePosition, 'box', 'off', ...
    'Color', 'none');
%     axes3 = tsubplot(3, 7, batch_number)
%     set(axes3, 'box', 'off',  'Color', 'none')
corr_life = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction;
plot([0,100], [corr_life, corr_life], 'k--', 'LineWidth', 1.2)
xlim([0, 100])
ylim([0, size(ax.YDisplayData, 1)])
set(gca,'YDir','reverse')

set(axes3, 'box', 'off',  'Color', 'none','XColor','none','YColor','none')



% second line Ro
axes1 = tsubplot(27, 7, [13*7+7 :7 :(13+12)*7+7], type);
% batch_number = 21

Ro_all = [];
for i = 1:length(SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align)
    Ro_all = [Ro_all; SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).CycleData_align(i).Ro];
end
heatmap(flip(Ro_all(1:RetiredBatteryData_all.(batch_name{batch_number})(Battery_number).Feature.RUL, :), 2), 'GridVisible', 'off')

title(['Simulation Ro (Ω)'])
xlabel('State of Charge')
ylabel('Cycle number')
ax = gca;
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
SOC_start = 1;
SOC_end = 0;
for i = 0:25:99
    scale = (SOC_end - SOC_start) / 100;
    offset = SOC_start - scale;
    ax.XDisplayLabels{i+1} = [num2str((scale * (i+1) + offset)*100), '%'];
end
ax.XDisplayLabels{100} = [num2str(SOC_end*100), '%'];
label_gap = round(size(ax.YDisplayData, 1)/6);
for i = label_gap:label_gap:(size(ax.YDisplayData)*0.95)
    ax.YDisplayLabels{i} = num2str(i);
end
ax.YDisplayLabels{size(ax.YDisplayData, 1)} = num2str(size(ax.YDisplayData, 1));
colormap(BuDRd_18); % BuDRd_18 YlGnBu8 Paired9 BuDOr_18  BuGr_14

FigurePosition = get(gca, 'InnerPosition')
axes3 = axes('Units','normalized','Position', FigurePosition, 'box', 'off', ...
    'Color', 'none');
%     axes3 = tsubplot(3, 7, batch_number)
%     set(axes3, 'box', 'off',  'Color', 'none')
corr_life = SimulationData_RetiredBattery.(batch_name{batch_number})(Battery_number).Summary.CycleLife_Correction;
plot([0,100], [corr_life, corr_life], 'k--', 'LineWidth', 1.2)
xlim([0, 100])
ylim([0, size(ax.YDisplayData, 1)])
set(gca,'YDir','reverse')

set(axes3, 'box', 'off',  'Color', 'none','XColor','none','YColor','none')

% position的格式为[left, bottom, width, height]

annotation(figure1,'textbox',...
    [0.60 0.142 0.0831600831600832 0.0409836065573771],...
    'String',{'Calibtated EOL'},...
    'FontSize',9.5,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.745 0.142 0.0831600831600833 0.0409836065573771],...
    'String',{'Calibtated EOL'},...
    'FontSize',9.5,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.885 0.142 0.0831600831600832 0.0409836065573771],...
    'String',{'Calibtated EOL'},...
    'FontSize',9.5,...
    'FitBoxToText','off',...
    'EdgeColor','none');

%%

function rgb = hex2rgb(hexColor)
    r = hex2dec(hexColor(1:2));
    g = hex2dec(hexColor(3:4));
    b = hex2dec(hexColor(5:6));
    rgb = [r, g, b]./255;
end

function ax=tsubplot(rows,cols,ind,type)

if nargin<4,type='tight';end
sz=[rows,cols];
ratio1=[0,0,1,1];
switch type
    case 'tight'
        ratio1=[0,0,1,1];
    case 'compact'
        ratio1=[0.034 0.0127 0.9256 0.9704];
    case 'loose'
        ratio1=[0.099 0.056 0.8131 0.8896];
end
k=1;
posList=zeros(sz(1)*sz(2),4);
for i=1:sz(1)
    for j=1:sz(2)
        tpos=[(j-1)/sz(2),(sz(1)-i)/sz(1),1/sz(2),1/sz(1)];
        posList(k,:)=[tpos(1)+tpos(3).*ratio1(1),tpos(2)+tpos(4).*ratio1(2),...
            tpos(3).*ratio1(3),tpos(4).*ratio1(4)];
        k=k+1;
    end
end
posSet=posList(ind(:),:);
xmin=min(posSet(:,1));
ymin=min(posSet(:,2));
xmax=max(posSet(:,1)+posSet(:,3));
ymax=max(posSet(:,2)+posSet(:,4));
ax=axes('Parent',gcf,'LooseInset',[0,0,0,0],...
    'OuterPosition',[xmin,ymin,xmax-xmin,ymax-ymin]);

end
