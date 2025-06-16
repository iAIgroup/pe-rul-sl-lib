
load('./SimulationData_RetiredBattery.mat')
%%

color4 = hex2rgb( 'f4bca4  ')
color3 = [152, 199, 223]/255;
color2 = hex2rgb( '2c81be ') 
color1 = hex2rgb( '1c3e71 ')


n1 = 2;
n2 = 13-n1;
n3= 21-n1-n2;


fontsize = 16;

R =(linspace(color1(1),color2(1),n1))';
G =(linspace(color1(2),color2(2),n1))';
B =(linspace(color1(3),color2(3),n1))';
mycolor1 = [R,G,B];

R =(linspace(color2(1),color3(1),n2))';
G =(linspace(color2(2),color3(2),n2))';
B =(linspace(color2(3),color3(3),n2))';
mycolor2 = [R,G,B];

% n3=15-n1-n2;
R =(linspace(color3(1),color4(1),n3))';
G =(linspace(color3(2),color4(2),n3))';
B =(linspace(color3(3),color4(3),n3))';
mycolor3 = [R,G,B];

n4=21-n1-n2-n3;
R =(linspace(color4(1),color5(1),n4))';
G =(linspace(color4(2),color5(2),n4))';
B =(linspace(color4(3),color5(3),n4))';
mycolor4 = [R,G,B];

color = [mycolor1; mycolor2; mycolor3];


figure('Position', [0, 1000, 650, 300], 'InvertHardcopy','off', 'Color',[1, 1, 1])
hold on
box on
for batch_number = 1:21
    for Battery_number = 1:4
        plot(SimulationData_RetiredBattery.((batch_name{batch_number})) ...
            (Battery_number).Summary.SOH*2.6, 'color',color(batch_number,:),...
            'LineWidth', 2.5);
    end
end
xlim([-8, 1600])
ylim([1.50, 2.370])
xlabel('Cycle number','FontSize',fontsize)
ylabel('Capacity (Ah)','FontSize',fontsize)
ax = gca;
colormap(color);
colorbar()
set(ax,'FontName','Arial','FontSize',fontsize);
caxis([1 21])

%%
function rgb = hex2rgb(hexColor)
    r = hex2dec(hexColor(1:2));
    g = hex2dec(hexColor(3:4));
    b = hex2dec(hexColor(5:6));
    rgb = [r, g, b]./255;
end