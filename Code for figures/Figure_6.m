%%
batch_order = {'B1','B2','B7','B8','B11','B12', 'B3','B4','B5',...
    'B6','B9','B10','B13','B14','B15','B17', ...
    'B16','B18','B19','B20','B21'};

batch_cluster_order{1} = {'B1','B2','B7','B8','B11','B12'};
batch_cluster_order{2} = { 'B3','B4','B5','B6','B9','B10','B13','B14','B15','B17'};
batch_cluster_order{3} = {'B16','B18','B19','B20','B21'};
batch_cluster_order{4} = batch_order;
cluster_order = {'cluster1', 'cluster2', 'cluster3', 'all'};
cluster_order_name = {'Cluster 1', 'Cluster 2', 'Cluster 3', 'All results'};


load('./results_all.mat')


%% data

for cluster_number = 1:4
    eval(['RMSE_cluster',num2str(cluster_number), '= zeros(7, 4);'])
    eval(['MAE_cluster',num2str(cluster_number), ' = zeros(7, 4);'])
    eval(['R2_cluster',num2str(cluster_number), ' = zeros(7, 4);'])
    
    for batch_number = 1:length(batch_cluster_order{cluster_number})
        for validation_number = 1:4
            eval(['RMSE_cluster',num2str(cluster_number), '(1, validation_number) =' ...
                'result_RNN.(cluster_order{cluster_number})(validation_number).rmse;'])
            eval(['RMSE_cluster',num2str(cluster_number), '(2, validation_number) = ' ...
                ' result_LSTM.(cluster_order{cluster_number})(validation_number).rmse;'])
            eval(['RMSE_cluster',num2str(cluster_number), '(3, validation_number) = ' ...
                'result_GRU.(cluster_order{cluster_number})(validation_number).rmse;'])
            eval(['RMSE_cluster',num2str(cluster_number), '(4, validation_number) = ' ...
                'result_Auto.(cluster_order{cluster_number})(validation_number).rmse;'])
            eval(['RMSE_cluster',num2str(cluster_number), '(5, validation_number) =' ...
                'result_CnnLstmDnn.(cluster_order{cluster_number})(validation_number).rmse;'])
            eval(['RMSE_cluster',num2str(cluster_number), '(6, validation_number) = ' ...
                ' result_AutoCnnLstm.(cluster_order{cluster_number})(validation_number).rmse;'])
            eval(['RMSE_cluster',num2str(cluster_number), '(7, validation_number) = ' ...
                ' result_cali.(cluster_order{cluster_number})(validation_number).rmse;'])
            
            
            eval(['MAE_cluster',num2str(cluster_number), '(1, validation_number) = ' ...
                ' result_RNN.(cluster_order{cluster_number})(validation_number).mae;'])
            eval(['MAE_cluster',num2str(cluster_number), '(2, validation_number) = ' ...
                ' result_LSTM.(cluster_order{cluster_number})(validation_number).mae;'])
            eval(['MAE_cluster',num2str(cluster_number), '(3, validation_number) = ' ...
                ' result_GRU.(cluster_order{cluster_number})(validation_number).mae;'])
            eval(['MAE_cluster',num2str(cluster_number), '(4, validation_number) = ' ...
                ' result_Auto.(cluster_order{cluster_number})(validation_number).mae;'])
            eval(['MAE_cluster',num2str(cluster_number), '(5, validation_number) = ' ...
                ' result_CnnLstmDnn.(cluster_order{cluster_number})(validation_number).mae;'])
            eval(['MAE_cluster',num2str(cluster_number), '(6, validation_number) = ' ...
                ' result_AutoCnnLstm.(cluster_order{cluster_number})(validation_number).mae;'])
            eval(['MAE_cluster',num2str(cluster_number), '(7, validation_number) = ' ...
                ' result_cali.(cluster_order{cluster_number})(validation_number).mae;'])
            
            eval(['R2_cluster',num2str(cluster_number), '(1, validation_number) = ' ...
                ' result_RNN.(cluster_order{cluster_number})(validation_number).r2;'])
            eval(['R2_cluster',num2str(cluster_number), '(2, validation_number) =' ...
                ' result_LSTM.(cluster_order{cluster_number})(validation_number).r2;'])
            eval(['R2_cluster',num2str(cluster_number), '(3, validation_number) = ' ...
                'result_GRU.(cluster_order{cluster_number})(validation_number).r2;'])
            eval(['R2_cluster',num2str(cluster_number), '(4, validation_number) = ' ...
                'result_Auto.(cluster_order{cluster_number})(validation_number).r2;'])
            eval(['R2_cluster',num2str(cluster_number), '(5, validation_number) = ' ...
                'result_CnnLstmDnn.(cluster_order{cluster_number})(validation_number).r2;'])
            eval(['R2_cluster',num2str(cluster_number), '(6, validation_number) =' ...
                'result_AutoCnnLstm.(cluster_order{cluster_number})(validation_number).r2;'])
            eval(['R2_cluster',num2str(cluster_number), '(7, validation_number) = ' ...
                'result_cali.(cluster_order{cluster_number})(validation_number).r2;'])
            
        end
    end
end
%%
figureUnits = 'centimeters';
figureWidth = 35;
figureHeight = 8*3;

figure1 = figure;

set(gcf, 'Units', figureUnits, 'Position', [2 1 figureWidth figureHeight], ...
    'Color', [1, 1, 1]);
type='compact';% tight
%
% axes1 = tsubplot(5, 5, [1,2, 6, 7, 11,12, 16,17],type)
axes1 = tsubplot(4, 5, [1,2, 6, 7, 11,12, 16,17],type)
% axes1 = tsubplot(4, 3, [1, 4, 7, 10],type)
hold on
R2_cluster1_mean = flip(mean(R2_cluster1'));
R2_cluster2_mean = flip(mean(R2_cluster2'));
R2_cluster3_mean = flip(mean(R2_cluster3'));
R2_cluster4_mean = flip(mean(R2_cluster4'));
R2_cluster1_std = flip(std(R2_cluster1'));
R2_cluster2_std = flip(std(R2_cluster2'));
R2_cluster3_std = flip(std(R2_cluster3'));
R2_cluster4_std = flip(std(R2_cluster4'));
R2_mean = [R2_cluster4_mean; R2_cluster3_mean; R2_cluster2_mean; R2_cluster1_mean];

x1 = 1:5:35;
x2 = 2:5:36;
x3 = 3:5:37;
x4 = 4:5:38;
barwidth = 0.18;
b1 = bar(x1, R2_mean(1,:)', 'Horizontal', 'on', 'BarWidth', barwidth);
b2 = bar(x2, R2_mean(2,:)', 'Horizontal', 'on', 'BarWidth', barwidth);
b3 = bar(x3, R2_mean(3,:)', 'Horizontal', 'on', 'BarWidth', barwidth);
b4 = bar(x4, R2_mean(4,:)', 'Horizontal', 'on', 'BarWidth', barwidth);


set(axes1,'Color','none','FontName','Arial','FontSize',9.5, 'TickDir', 'out', ...
    'box', 'off');
label_all = {'RNN', 'LSTM', 'GRU', 'Autoencoder', 'CNN-LSTM-DNN', ...
    'Auto-CNN-LSTM', 'Ours'};
yticks([2.5:5:36.5])
yticklabels(flip(label_all));
xlabel('R^2')
ylim([0.2, 35])
ytickangle(90);
%
plot([0.894755810499191, 0.894755810499191], [0.2, 34.5], 'k--', 'LineWidth', 0.8)

color4 = hex2rgb('A64294');
color3 = hex2rgb('EF7F29');
color2 = hex2rgb('5C8DC7');
color1 = hex2rgb('198E5C');

face_alpha = 0;
b1.FaceColor = color4;
b1.EdgeColor = color4;
b1.FaceAlpha = face_alpha;
b1.LineWidth = 1.2;

b2.FaceColor = color3;
b2.EdgeColor = color3;
b2.FaceAlpha = face_alpha;
b2.LineWidth = 1.2;

b3.FaceColor = color2;
b3.EdgeColor = color2;
b3.FaceAlpha = face_alpha;
b3.LineWidth = 1.2;

b4.FaceColor = color1;
b4.EdgeColor = color1;
b4.FaceAlpha = face_alpha;
b4.LineWidth = 1.2;

outside_parameter = 0.1;
% x2 = [0.275, 0.095, -0.09, -0.27];
x = 1:7;
errorbar(R2_cluster1_mean, x4, R2_cluster1_std,...
    'horizontal', 'LineStyle', 'None', 'LineWidth', 1.2, 'Color', color1)
errorbar(R2_cluster2_mean, x3, R2_cluster2_std,...
    'horizontal', 'LineStyle', 'None', 'LineWidth', 1.2, 'Color', color2)
errorbar(R2_cluster3_mean, x2, R2_cluster3_std,...
    'horizontal', 'LineStyle', 'None', 'LineWidth', 1.2, 'Color', color3)
errorbar(R2_cluster4_mean, x1, R2_cluster4_std,...
    'horizontal', 'LineStyle', 'None', 'LineWidth', 1.2, 'Color', color4)

for i = 1:7
    scatter(R2_cluster4(8-i, :), x1(i)+outside_parameter * randn(1, 4), 'o',...
        'MarkerEdgeColor', color4, 'LineWidth', 1.2)
    scatter(R2_cluster3(8-i, :), x2(i)+outside_parameter * randn(1, 4), 'square',...
        'MarkerEdgeColor', color3, 'LineWidth', 1.2)
    scatter(R2_cluster2(8-i, :), x3(i)+outside_parameter * randn(1, 4), '^',...
        'MarkerEdgeColor', color2, 'LineWidth', 1.2)
    scatter(R2_cluster1(8-i, :), x4(i)+outside_parameter * randn(1, 4), 'diamond',...
        'MarkerEdgeColor', color1, 'LineWidth', 1.2)
end


%
fontzise = 10;
Fontcolor = [0 0 0];
x_begin = 0.02;
for i = 1:7
    text(x_begin, x4(i), 'Cluster 1', ...
        'Color', Fontcolor, 'FontName', 'Arial', 'FontSize', fontzise)
    text(x_begin, x3(i), 'Cluster 2', ...
        'Color', Fontcolor, 'FontName', 'Arial', 'FontSize', fontzise)
    text(x_begin, x2(i), 'Cluster 3', ...
        'Color', Fontcolor, 'FontName', 'Arial', 'FontSize', fontzise)
    text(x_begin, x1(i), 'All results', ...
        'Color', Fontcolor, 'FontName', 'Arial', 'FontSize', fontzise)
end


%
linewidth_ = 1.4;
% axes2 =  tsubplot(5, 5, [3, 4, 5],type)
axes2 =  tsubplot(4, 5, [3, 4, 5],type);
% axes2 = tsubplot(4, 3, [2, 3],type)
hold on
withd = 2.5;
p1 = 0.5:withd:withd*length(RMSE_cluster1);
p2 = 1.5:withd:withd*length(RMSE_cluster1);
color_MAE = hex2rgb('898989');
b1 = boxplot(RMSE_cluster1','positions',p1,'Colors',color1,'Widths',0.7);
b2 = boxplot( MAE_cluster1','positions',p2,'Colors',color_MAE,'Widths',0.7);

boxobj = findobj(gca, 'Tag', 'Box');
for i = [8, 1, 2:7, 9:length(boxobj)]
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > length(boxobj)/2
        CA = color1;
    else
        CA = color_MAE;
    end
    if i>=7
        FaceAlpha_ = 0.1;
    else
        FaceAlpha_ = 0.05;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',FaceAlpha_,'LineWidth',linewidth_);
end

delete(b1,b2)
b1 = boxplot(RMSE_cluster1','positions',p1,'Colors',color1,'Widths',0.7);
b2 = boxplot( MAE_cluster1','positions',p2,'Colors',color_MAE,'Widths',0.7);

outside_parameter = 0.15;
for i = 1:4
    scatter(p1+outside_parameter * randn(1, 7), RMSE_cluster1(:,i),...
        'Marker', '<', 'MarkerEdgeColor', color1, ...
        'LineWidth',linewidth_);
    scatter(p2+outside_parameter * randn(1, 7), MAE_cluster1(:,i),...
        'Marker', 'diamond', 'MarkerEdgeColor', color_MAE, ...
        'LineWidth',linewidth_);
end



set(axes2,'Color','none','FontName','Arial','FontSize',9.5, 'TickDir', 'out', ...
    'box', 'off');


XTick_position = (p1+p2)/2;
set(gca,'XTick', XTick_position);
xticklabels({'RNN', 'LSTM', 'GRU', 'Autoencoder', 'CNN-LSTM-DNN', 'Auto-CNN-LSTM', 'Ours'});
xlim([-0.5, XTick_position(end)+1.5]);
ylim([30,310+20])

plot([-0.5, XTick_position(end)+1.5], 315*ones(1, 2), 'k')
legend({'RMSE', 'MAE'},...
    'Position',[0.862581947853153 0.953212061901794 0.121028743019263 0.0198456445234482],...
    'NumColumns',2)
ylabel('Error')
box off

annotation(figure1,'textbox',...
    [0.692005952380952 0.980286458333333 0.0619880936159974 0.0176388888888884],...
    'String',{'Cluster 1'},...
    'FontSize',11,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'BackgroundColor',[1 1 1], 'HorizontalAlignment', 'center');

%
% axes3 = tsubplot(5, 5, [8, 9, 10],type)
axes3 = tsubplot(4, 5, [8, 9, 10],type)
% axes3 = tsubplot(4, 3, [5, 6],type)
hold on
withd = 2.5;
p1 = 0.5:withd:withd*length(RMSE_cluster1);
p2 = 1.5:withd:withd*length(RMSE_cluster1);
b1 = boxplot(RMSE_cluster2','positions',p1,'Colors',color2,'Widths',0.7);
b2 = boxplot( MAE_cluster2','positions',p2,'Colors',color_MAE,'Widths',0.7);

boxobj = findobj(gca, 'Tag', 'Box');
for i = [8, 1, 2:7, 9:length(boxobj)]
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > length(boxobj)/2
        CA = color2;
    else
        CA = color_MAE;
    end
    if i>=7
        FaceAlpha_ = 0.1;
    else
        FaceAlpha_ = 0.05;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',FaceAlpha_,'LineWidth',linewidth_);
end

delete(b1,b2)
b1 = boxplot(RMSE_cluster2','positions',p1,'Colors',color2,'Widths',0.7);
b2 = boxplot( MAE_cluster2','positions',p2,'Colors',color_MAE,'Widths',0.7);

outside_parameter = 0.15;
for i = 1:4
    scatter(p1+outside_parameter * randn(1, 7), RMSE_cluster2(:,i),...
        'Marker', '<', 'MarkerEdgeColor', color2, ...
        'LineWidth',linewidth_);
    scatter(p2+outside_parameter * randn(1, 7), MAE_cluster2(:,i),...
        'Marker', 'diamond', 'MarkerEdgeColor', color_MAE, ...
        'LineWidth',linewidth_);
end



set(axes3,'Color','none','FontName','Arial','FontSize',9.5, 'TickDir', 'out', ...
    'box', 'off');

XTick_position = (p1+p2)/2;
set(gca,'XTick', XTick_position);
xticklabels({'RNN', 'LSTM', 'GRU', 'Autoencoder', 'CNN-LSTM-DNN', 'Auto-CNN-LSTM', 'Ours'});
xlim([-0.5, XTick_position(end)+1.5]);
ylim([30,310+10])


plot([-0.5, XTick_position(end)+1.5], 300*ones(1, 2), 'k')
legend({'RMSE', 'MAE'},...
    'Position',[0.862581947853153 0.703212061901794 0.121028743019263 0.0198456445234482],...
    'NumColumns',2)
box off
ylabel('Error')

annotation(figure1,'textbox',...
    [0.692005952380952 0.726286458333333 0.0619880936159974 0.0176388888888884],...
    'String',{'Cluster 2'},...
    'FontSize',11,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'BackgroundColor',[1 1 1], 'HorizontalAlignment', 'center');



%
% axes4 = tsubplot(5, 5, [13, 14, 15],type)
axes4 = tsubplot(4, 5, [13, 14, 15],type)
% axes4 = tsubplot(4, 3, [8, 9],type)
hold on
withd = 2.5;
p1 = 0.5:withd:withd*length(RMSE_cluster3);
p2 = 1.5:withd:withd*length(RMSE_cluster3);
b1 = boxplot(RMSE_cluster3','positions',p1,'Colors',color3,'Widths',0.7);
b2 = boxplot( MAE_cluster3','positions',p2,'Colors',color_MAE,'Widths',0.7);

boxobj = findobj(gca, 'Tag', 'Box');
for i = [8, 1, 2:7, 9:length(boxobj)]
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > length(boxobj)/2
        CA = color3;
    else
        CA = color_MAE;
    end
    if i>=7
        FaceAlpha_ = 0.1;
    else
        FaceAlpha_ = 0.05;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',FaceAlpha_,'LineWidth',linewidth_);
end

delete(b1,b2)
b1 = boxplot(RMSE_cluster3','positions',p1,'Colors',color3,'Widths',0.7);
b2 = boxplot( MAE_cluster3','positions',p2,'Colors',color_MAE,'Widths',0.7);

outside_parameter = 0.15;
for i = 1:4
    scatter(p1+outside_parameter * randn(1, 7), RMSE_cluster3(:,i),...
        'Marker', '<', 'MarkerEdgeColor', color3, ...
        'LineWidth',linewidth_);
    scatter(p2+outside_parameter * randn(1, 7), MAE_cluster3(:,i),...
        'Marker', 'diamond', 'MarkerEdgeColor', color_MAE, ...
        'LineWidth',linewidth_);
end
ylabel('Error')


set(axes4,'Color','none','FontName','Arial','FontSize',9.5, 'TickDir', 'out', ...
    'box', 'off');
legend({'RMSE', 'MAE'})

XTick_position = (p1+p2)/2;
set(gca,'XTick', XTick_position);
xticklabels({'RNN', 'LSTM', 'GRU', 'Autoencoder', 'CNN-LSTM-DNN', 'Auto-CNN-LSTM', 'Ours'});
xlim([-0.5, XTick_position(end)+1.5]);
ylim([0,60+10])

yticks([0:10:70])
yticklabels({' 0', '  10',' 20',' 30',' 40',' 50',' 60',' 70'})

plot([-0.5, XTick_position(end)+1.5], 65*ones(1, 2), 'k')
legend({'RMSE', 'MAE'},...
    'Position',[0.862581947853153 0.443212061901794 0.121028743019263 0.0198456445234482],...
    'NumColumns',2)
ylabel('Error')
box off

annotation(figure1,'textbox',...
    [0.692005952380952 0.470286458333333 0.0619880936159974 0.0176388888888884],...
    'String',{'Cluster 3'},...
    'FontSize',11,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'BackgroundColor',[1 1 1], 'HorizontalAlignment', 'center');


%

axes5 = tsubplot(4, 5, [18, 19, 20],type)
hold on
withd = 2.5;
p1 = 0.5:withd:withd*length(RMSE_cluster4);
p2 = 1.5:withd:withd*length(RMSE_cluster4);
b1 = boxplot(RMSE_cluster4','positions',p1,'Colors',color4,'Widths',0.7);
b2 = boxplot( MAE_cluster4','positions',p2,'Colors',color_MAE,'Widths',0.7);

boxobj = findobj(gca, 'Tag', 'Box');
for i = [8, 1, 2:7, 9:length(boxobj)]
    X = get(boxobj(i),'XData');
    Y = get(boxobj(i),'YData');
    if i > length(boxobj)/2
        CA = color4;
    else
        CA = color_MAE;
    end
    if i>=7
        FaceAlpha_ = 0.1;
    else
        FaceAlpha_ = 0.05;
    end
    p(i) = patch(X,Y,CA,'EdgeColor',CA,'FaceAlpha',FaceAlpha_,'LineWidth',linewidth_);
end

delete(b1,b2)
b1 = boxplot(RMSE_cluster4','positions',p1,'Colors',color4,'Widths',0.7);
b2 = boxplot( MAE_cluster4','positions',p2,'Colors',color_MAE,'Widths',0.7);

outside_parameter = 0.15;
for i = 1:4
    scatter(p1+outside_parameter * randn(1, 7), RMSE_cluster4(:,i),...
        'Marker', '<', 'MarkerEdgeColor', color4, ...
        'LineWidth',linewidth_);
    scatter(p2+outside_parameter * randn(1, 7), MAE_cluster4(:,i),...
        'Marker', 'diamond', 'MarkerEdgeColor', color_MAE, ...
        'LineWidth',linewidth_);
end



set(axes5,'Color','none','FontName','Arial','FontSize',9.5,...
    'TickDir', 'out', ...
    'box', 'off');
legend({'RMSE', 'MAE'})

XTick_position = (p1+p2)/2;
set(gca,'XTick', XTick_position);
xticklabels({'RNN', 'LSTM', 'GRU', 'Autoencoder',...
    'CNN-LSTM-DNN', 'Auto-CNN-LSTM', 'Ours'});
xlim([-0.5, XTick_position(end)+1.5]);
ylim([40,310+10])
plot([-0.5, XTick_position(end)+1.5], 290*ones(1, 2), 'k')
legend({'RMSE', 'MAE'},...
    'Position',[0.862581947853153 0.194212061901794 0.121028743019263 0.0198456445234482],...
    'NumColumns',2)
ylabel('Error')
box off

annotation(figure1,'textbox',...
    [0.692005952380952 0.220286458333333 0.0659880936159974 0.0206388888888884],...
    'String',{'All Results'},...
    'FontSize',11,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'BackgroundColor',[1 1 1], 'HorizontalAlignment', 'center');



annotation(figure1,'textbox',...
    [0.0045 0.98787210584344 0.00883358547655068 0.0143329658213891],...
    'String',{'a'},...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.400394856278366 0.98787210584344 0.00883358547655061 0.0143329658213891],...
    'String','b',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.400394856278366 0.495038588754135 0.00883358547655061 0.0143329658213891],...
    'String','d',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.400394856278366 0.742006615214995 0.00883358547655061 0.0143329658213891],...
    'String','c',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.400394856278366 0.243660418963617 0.00883358547655061 0.014332965821389],...
    'String','e',...
    'FontWeight','bold',...
    'FontSize',14,...
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
        % ratio2=[0.031 0.054 0.9619 0.9254];
    case 'compact'
        ratio1=[0.034 0.0127 0.9256 0.9704];
        % ratio2=[0.065 0.0667 0.8875 0.8958];
    case 'loose'
        ratio1=[0.099 0.056 0.8131 0.8896];
        % ratio2=[0.13 0.11 0.775 0.815];
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
