%% Loading Data for Acres Burned due to Wildfires in California

filename='1987-2018CalWildfireData';
TotalAcresBurned=readtable(filename);
Total_Burned=table2array(TotalAcresBurned);
Total_Burned(9,2)=209815; %had to fill in value from table because comma caused it to be a NaN

%% Analysis of Acres Burned by Wildfires

%Historical Trend Line
Wildfire_Time = Total_Burned(:,1);
Wildfire_BF = polyfit(Total_Burned(:,1), Total_Burned(:,2), 1);
Wildfire_LBF = polyval(Wildfire_BF, Total_Burned(:,1));

figure (1); clf
plot(Total_Burned(:,1),Total_Burned(:,2), '.', 'MarkerSize', 8)
hold on
plot(Total_Burned(:,1), Wildfire_LBF)
xlabel("Year")
ylabel("Acres Burned")
title("Acres Burned due to Wildfires from 1987-2018")

%%Projected Future Trend Line
slope1= Wildfire_BF(1,1)
intercept1=Wildfire_BF(1,2)
Wildfire_Future_Time = [2018:1:2050]'
Proj_Acres_Burned = slope1.*Wildfire_Future_Time + intercept1;

figure (2); clf
plot(Total_Burned(:,1),Total_Burned(:,2), '.', 'MarkerSize', 11)
hold on
plot(Total_Burned(:,1), Wildfire_LBF, 'color','#77AC30','LineWidth', 1)
hold on 
plot(Wildfire_Future_Time, Proj_Acres_Burned,'color', '#D95319','LineWidth', 1)
xlabel("Year")
ylabel("Acres Burned")
title("Historical and Projected Acres Burned due to Wildfires until 2050")
legend('Wildfire Acres Burned', 'Wildfire Acres Trendline', 'Wildfire Acres Projected Trendline') 

%% Loading and Processing Spatial Fire Perimeter Data for 2020 Wildfires in California

filename='fire_nrt_M-C61_195333';
WildfireLocations2020=readtable(filename);
Wildfire_Locations_2020 = WildfireLocations2020;

%Removing wildfires that did not occur in boundaries of California
%Border Range: 
%   Longitude: 114.133333 W to 124.4 W
%   Latitude: 32.5 N to 42 N

toDelete =Wildfire_Locations_2020.latitude > 42;
Wildfire_Locations_2020(toDelete, :) = [];

toDelete = Wildfire_Locations_2020.latitude < 32.5;
Wildfire_Locations_2020(toDelete, :) = [];
 
toDelete = Wildfire_Locations_2020.longitude < -124.4 ;
Wildfire_Locations_2020(toDelete, :) = [];
  
toDelete = Wildfire_Locations_2020.longitude > -114.133333;
Wildfire_Locations_2020(toDelete, :) = [];


%% Loading Climatological Data for California's Climate Divisions

%Precipitation Data

filename = 'California, Climate Division 1, Precipitation.csv';
Precipitation_CD_1=readtable(filename);

filename = 'California, Climate Division 2, Precipitation.csv';
Precipitation_CD_2=readtable(filename);

filename = 'California, Climate Division 3, Precipitation.csv';
Precipitation_CD_3=readtable(filename);

filename = 'California, Climate Division 4, Precipitation.csv';
Precipitation_CD_4=readtable(filename);

filename = 'California, Climate Division 5, Precipitation.csv';
Precipitation_CD_5=readtable(filename);

filename = 'California, Climate Division 6, Precipitation.csv';
Precipitation_CD_6=readtable(filename);

filename = 'California, Climate Division 7, Precipitation.csv';
Precipitation_CD_7=readtable(filename);

%Temperature Data
filename = 'California, Climate Division 1, Average Temperature.csv';
AverageTemp_CD_1=readtable(filename);

filename = 'California, Climate Division 2, Average Temperature.csv';
AverageTemp_CD_2=readtable(filename);

filename = 'California, Climate Division 3, Average Temperature.csv';
AverageTemp_CD_3=readtable(filename);

filename = 'California, Climate Division 4, Average Temperature.csv';
AverageTemp_CD_4=readtable(filename);

filename = 'California, Climate Division 5, Average Temperature.csv';
AverageTemp_CD_5=readtable(filename);

filename = 'California, Climate Division 6, Average Temperature.csv';
AverageTemp_CD_6=readtable(filename);

filename = 'California, Climate Division 7, Average Temperature.csv';
AverageTemp_CD_7=readtable(filename);

%% Algorithim to Convert Dates in Climate Division Climatological Data

%Precipitation Data Date Conversion:
Time_All_CD = NaN(height(Precipitation_CD_1), 7);

for i=1:7
    filename = ['California, Climate Division ' num2str(i) ', Average Temperature.csv'];
    [CD_Adjusted_Time] = TimeConversion(filename);
    Time_All_CD (:,i) = CD_Adjusted_Time;
end

P_CD_1= Time_All_CD (:,1);
P_CD_2= Time_All_CD (:,2);
P_CD_3= Time_All_CD (:,3);
P_CD_4= Time_All_CD (:,4);
P_CD_5= Time_All_CD (:,5); 
P_CD_6= Time_All_CD (:,6); 
P_CD_7= Time_All_CD (:,7);

%Average Temperature Data Date Conversion:
Time_All_CD_Temp = NaN(height(Precipitation_CD_1), 7);

for i=1:7
    filename = ['California, Climate Division ' num2str(i) ', Precipitation.csv'];
    [CD_Adjusted_Time] = TimeConversion(filename);
    Time_All_CD_Temp (:,i) = CD_Adjusted_Time;
end

T_CD_1= Time_All_CD_Temp (:,1);
T_CD_2= Time_All_CD_Temp (:,2);
T_CD_3= Time_All_CD_Temp (:,3);
T_CD_4= Time_All_CD_Temp (:,4);
T_CD_5= Time_All_CD_Temp (:,5); 
T_CD_6= Time_All_CD_Temp (:,6); 
T_CD_7= Time_All_CD_Temp (:,7);

%% Plotting Observed Precipitation Overtime in California Climate Divisions 

%Smoothing the Data to a 5-year moving mean (60 month values) 
CD1_Smoothed_Precip = movmean(Precipitation_CD_1.Value, 60);
CD2_Smoothed_Precip = movmean(Precipitation_CD_2.Value, 60);
CD3_Smoothed_Precip = movmean(Precipitation_CD_3.Value, 60);
CD4_Smoothed_Precip = movmean(Precipitation_CD_4.Value, 60);
CD5_Smoothed_Precip = movmean(Precipitation_CD_5.Value, 60);
CD6_Smoothed_Precip = movmean(Precipitation_CD_6.Value, 60);
CD7_Smoothed_Precip = movmean(Precipitation_CD_7.Value, 60);

%Linear Fit of Climate Division Precipitation Data
BF_P_CD1 = polyfit(P_CD_1,CD1_Smoothed_Precip,1);
LBF_P_CD1 =polyval(BF_P_CD1,P_CD_1);
BF_P_CD2 = polyfit(P_CD_2,CD2_Smoothed_Precip,1);
LBF_P_CD2 =polyval(BF_P_CD2,P_CD_2);
BF_P_CD3 = polyfit(P_CD_3,CD3_Smoothed_Precip,1);
LBF_P_CD3 =polyval(BF_P_CD3,P_CD_3);
BF_P_CD4 = polyfit(P_CD_4,CD4_Smoothed_Precip,1);
LBF_P_CD4 =polyval(BF_P_CD4,P_CD_4);
BF_P_CD5 = polyfit(P_CD_5,CD5_Smoothed_Precip,1);
LBF_P_CD5 =polyval(BF_P_CD5,P_CD_5);
BF_P_CD6 = polyfit(P_CD_6,CD6_Smoothed_Precip,1);
LBF_P_CD6 =polyval(BF_P_CD6,P_CD_6);
BF_P_CD7 = polyfit(P_CD_7,CD7_Smoothed_Precip,1);
LBF_P_CD7 =polyval(BF_P_CD7,P_CD_7);

%Plot of Historical Observed Precipitation Data in California 
figure(3); clf
plot(P_CD_1,CD1_Smoothed_Precip,'LineWidth', 0.5)
hold on
plot(P_CD_2,CD2_Smoothed_Precip,'LineWidth', 0.5)
hold on
plot(P_CD_3,CD3_Smoothed_Precip,'LineWidth', 0.5)
hold on
plot(P_CD_4,CD4_Smoothed_Precip,'LineWidth', 0.5)
hold on
plot(P_CD_5,CD5_Smoothed_Precip,'LineWidth', 0.5)
hold on
plot(P_CD_6,CD6_Smoothed_Precip,'LineWidth', 0.5)
hold on
plot(P_CD_7,CD7_Smoothed_Precip,'LineWidth', 0.5)
hold on 
plot(P_CD_1,LBF_P_CD1,'-.', 'LineWidth', 1)
plot(P_CD_2,LBF_P_CD2,'-.', 'LineWidth', 1)
plot(P_CD_3,LBF_P_CD3,'-.', 'LineWidth', 1)
plot(P_CD_4,LBF_P_CD4,'-.', 'LineWidth', 1)
plot(P_CD_5,LBF_P_CD5,'-.', 'LineWidth', 1)
plot(P_CD_6,LBF_P_CD6,'-.', 'LineWidth', 1)
plot(P_CD_7,LBF_P_CD7,'-.', 'LineWidth', 1)
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Precipitation (in)')
title ('Observed Precipitation in California from 1950 - Present')
lgd = legend ('Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7','Trendline Climate Division 1','Trendline Climate Division 2','Trendline Climate Division 3','Trendline Climate Division 4','Trendline Climate Division 5','Trendline Climate Division 6','Trendline Climate Division 7','Location', 'southoutside')
lgd.NumColumns = 2

%% Plotting Observed Average Temperature Overtime in California Climate Divisions

%Smoothing the Data to a 5-year moving mean (60 month values) 
CD1_Smoothed_Temp = movmean(AverageTemp_CD_1.Value, 60);
CD2_Smoothed_Temp = movmean(AverageTemp_CD_2.Value, 60);
CD3_Smoothed_Temp = movmean(AverageTemp_CD_3.Value, 60);
CD4_Smoothed_Temp = movmean(AverageTemp_CD_4.Value, 60);
CD5_Smoothed_Temp = movmean(AverageTemp_CD_5.Value, 60);
CD6_Smoothed_Temp = movmean(AverageTemp_CD_6.Value, 60);
CD7_Smoothed_Temp = movmean(AverageTemp_CD_7.Value, 60);

%Lineear Fit of Climate Division Temperature Data
BF_T_CD1 = polyfit(T_CD_1,CD1_Smoothed_Temp,1);
LBF_T_CD1 =polyval(BF_T_CD1,T_CD_1);
BF_T_CD2 = polyfit(T_CD_2,CD2_Smoothed_Temp,1);
LBF_T_CD2 =polyval(BF_T_CD2,T_CD_2);
BF_T_CD3 = polyfit(T_CD_3,CD3_Smoothed_Temp,1);
LBF_T_CD3 =polyval(BF_T_CD3,T_CD_3);
BF_T_CD4 = polyfit(T_CD_4,CD4_Smoothed_Temp,1);
LBF_T_CD4 =polyval(BF_T_CD4,T_CD_4);
BF_T_CD5 = polyfit(T_CD_5,CD5_Smoothed_Temp,1);
LBF_T_CD5 =polyval(BF_T_CD5,T_CD_5);
BF_T_CD6 = polyfit(T_CD_6,CD6_Smoothed_Temp,1);
LBF_T_CD6 =polyval(BF_T_CD6,T_CD_6);
BF_T_CD7 = polyfit(T_CD_7,CD7_Smoothed_Temp,1);
LBF_T_CD7 =polyval(BF_T_CD7,T_CD_7);

%Plot of Historical Observed Temperature Data in California 
figure(4); clf
plot(T_CD_1,CD1_Smoothed_Temp,'LineWidth', 0.5)
hold on
plot(T_CD_2,CD2_Smoothed_Temp,'LineWidth', 0.5)
hold on
plot(T_CD_3,CD3_Smoothed_Temp,'LineWidth', 0.5)
hold on
plot(T_CD_4,CD4_Smoothed_Temp,'LineWidth', 0.5)
hold on
plot(T_CD_5,CD5_Smoothed_Temp,'LineWidth', 0.5)
hold on
plot(T_CD_6,CD6_Smoothed_Temp,'LineWidth', 0.5)
hold on
plot(T_CD_7,CD7_Smoothed_Temp,'LineWidth', 0.5)
plot(T_CD_1,LBF_T_CD1,'-.', 'LineWidth', 1)
plot(T_CD_2,LBF_T_CD2,'-.', 'LineWidth', 1)
plot(T_CD_3,LBF_T_CD3,'-.', 'LineWidth', 1)
plot(T_CD_4,LBF_T_CD4,'-.', 'LineWidth', 1)
plot(T_CD_5,LBF_T_CD5,'-.', 'LineWidth', 1)
plot(T_CD_6,LBF_T_CD6,'-.', 'LineWidth', 1)
plot(T_CD_7,LBF_T_CD7,'-.', 'LineWidth', 1)
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Temperature ({^o}F)')
title ('Observed Average Temperature in California from 1950 - Present')
lgd = legend ('Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7','Trendline Climate Division 1','Trendline Climate Division 2','Trendline Climate Division 3','Trendline Climate Division 4','Trendline Climate Division 5','Trendline Climate Division 6','Trendline Climate Division 7','Location', 'southoutside')
lgd.NumColumns = 2
%% Lodgepole Station - Sequoia Forest Data

filename = 'SQF Location Temp.csv';
SQF_Climatology=readtable(filename);

%Map of California's Wildfires in 2020 and the Location of Lodegpole Station
latlim= [32 42.5]
lonlim = [-125 -114.133333]

figure (5); clf
ax= usamap(latlim,lonlim);
axis off
getm(gca, 'MapProjection')
states = shaperead('usastatehi',...
    'UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
geoshow(ax,states,'SymbolSpec',faceColors)
r(1)= scatterm(Wildfire_Locations_2020.latitude,Wildfire_Locations_2020.longitude,5,'filled','k', 'DisplayName', '2020 Wildfire Events')
hold on 
r(2) = scatterm(SQF_Climatology.LATITUDE(1), SQF_Climatology.LONGITUDE(1),200, 'p','filled','r', 'DisplayName', 'Sequoia Forest')
title('Location of California Wildfires in 2020')
legend(r)

%% Plotting Historical Precipitation at Lodgepole Station

%Smoothing the Data to a 2-year moving mean (730 days)
Smoothed_SQF_Precip = movmean(SQF_Climatology.PRCP(2189:end),730,'omitnan');
%added 'omitnan' to disregard nan values

%Linear Fit of Data
SQF_Date_Conversion = datenum(SQF_Climatology.DATE(2189:end));
BF_SQF_P = polyfit(SQF_Date_Conversion,Smoothed_SQF_Precip,1);
LBF_SQF_P =polyval(BF_SQF_P,SQF_Date_Conversion);

% Plot of Smoothed Historical Precipitation Data Alongside Raw Data at Sequoia Forest
figure (6); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') 
title('Daily Recorded Precipitation at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',2,'color', 'r')
legend('Observed Precipitation', 'Smoothed Precipitation Data')

% Plot of Smoothed Historical Precipitation Data with Linear Fit
figure(7);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',0.9,'color', '#0072BD')
hold on
plot(SQF_Climatology.DATE(2189:end), LBF_SQF_P, '-.', 'Linewidth', 1.2, 'color', '#77AC30') 
xlabel('Year')
ylabel ('Precipitation (in)') 
title('Observed Daily Precipitation at Sequoia Forest from 1970 to Present')
legend ('Smoothed Precipitation Data','Linear Trend', 'Box', 'on')



%% Plotting Historical Temperature at Lodgepole Station

%Smoothing the Data to a 2-year moving mean (730 days)
Smoothed_SQF_Temp = movmean(SQF_Climatology.TOBS(2189:end),730, 'omitnan');
%added 'omitnan' as well

%Linear Fit of Data
BF_SQF_T = polyfit(SQF_Date_Conversion,Smoothed_SQF_Temp,1);
LBF_SQF_T =polyval(BF_SQF_T,SQF_Date_Conversion);

%Plot of Smoothed Historical Temperature Data Alongside Raw Data at Sequoia Forest
figure(8); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.TOBS(2189:end), '.')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Daily Recorded Temperature at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',2,'color', 'r')

%Plot of Smoothed Historical Temperature Data with Linear Fit
figure(9);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',0.9,'color', '#0072BD')
hold on
plot(SQF_Climatology.DATE(2189:end), LBF_SQF_T, '-.', 'Linewidth', 1.2, 'color', '#77AC30') 
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Observed Daily Average Temperature at Sequoia Forest from 1970 to Present')
legend ({'Smoothed Observered Temperature Data','Linear Trend'}, 'Box', 'on')

%% Sequoia Forest Precipitation Predictions 

%Historical Trend Line Slope and Intercept
slope1 = BF_SQF_P(1,1);
intercept1 = BF_SQF_P(1,2);

%Creating Future Timeline
t1=datetime(2021,1,1);
t2=datetime(2050,1,1);
formatOut = 'yyyy/mm/dd';
Future_Years= [t1:t2]';
SQF_Future_Years = datenum(Future_Years);

%Future Precipitation Trendline
SQF_Proj_P = (slope1.* SQF_Future_Years) + intercept1;

%Plot of Historical and Projected Future Trends of Precipitation at Sequoia
%Forest
figure(10); clf
plot(SQF_Future_Years,SQF_Proj_P, '-.','Linewidth', 1.5,'color','#D95319')
hold on
plot(SQF_Date_Conversion,Smoothed_SQF_Precip,'Linewidth',1,'color', '#0072BD')
hold on
plot(SQF_Date_Conversion, LBF_SQF_P, '-.', 'Linewidth', 1,'color','#77AC30')
xlabel('Year')
ylabel ('Precipitation (in)') 
title('Historical and Projected Precipitation Trend at Sequoia Forest')
datetick ('x','yyyy') %add keeplimits if 10yr interval wanted
legend ('Projected Precipitation Trend', 'Smoothed Precipitation Data', 'Historical Linear Trend', 'Box', 'on', 'Location','best')

%% Sequoia Forest Temperature Predictions 

%Historical Trend Line Slope and Intercept
slope2 = BF_SQF_T(1,1);
intercept2 = BF_SQF_T(1,2);

%Future Temperature Trendline
SQF_Proj_T = (slope2.* SQF_Future_Years) + intercept2;

figure(11); clf
plot(SQF_Future_Years,SQF_Proj_T,'-.','Linewidth', 1.5,'color','#D95319')
hold on
plot(SQF_Date_Conversion,Smoothed_SQF_Temp,'Linewidth',1,'color', '#0072BD')
hold on
plot(SQF_Date_Conversion, LBF_SQF_T,'-.', 'Linewidth', 1,'color','#77AC30')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Historical and Projected Temperature Trend at Sequoia Forest')
datetick ('x','yyyy') %add keeplimits if 10yr interval wanted for xaxis
legend ('Projected Temperature Trend', 'Smoothed Temperature Data', 'Historical Linear Trend', 'Box', 'on', 'Location', 'best')

%% California Climate Divisions Precipitation Predictions 

%Creating Future Timeline
t1=datetime(2021,1,1);
t2=datetime(2050,1,1);
Future_Years= [t1:t2]';
CD_Future_Years = datenum(Future_Years);

%Historical Trendlines' Slope and Intercept
CD1_slope = BF_P_CD1(1,1); 
CD1_intercept = BF_P_CD1(1,2);
CD2_slope = BF_P_CD2(1,1); 
CD2_intercept = BF_P_CD2(1,2);
CD3_slope = BF_P_CD3(1,1); 
CD3_intercept = BF_P_CD3(1,2);
CD4_slope = BF_P_CD4(1,1); 
CD4_intercept = BF_P_CD4(1,2);
CD5_slope = BF_P_CD5(1,1); 
CD5_intercept = BF_P_CD5(1,2);
CD6_slope = BF_P_CD6(1,1); 
CD6_intercept = BF_P_CD6(1,2);
CD7_slope = BF_P_CD7(1,1); 
CD7_intercept = BF_P_CD7(1,2);

%Future Precipitation Trendlines
Proj_P_CD1 = (CD1_slope.* CD_Future_Years) + CD1_intercept;
Proj_P_CD2 = (CD2_slope.* CD_Future_Years) + CD2_intercept;
Proj_P_CD3 = (CD3_slope.* CD_Future_Years) + CD3_intercept;
Proj_P_CD4 = (CD4_slope.* CD_Future_Years) + CD4_intercept;
Proj_P_CD5 = (CD5_slope.* CD_Future_Years) + CD5_intercept;
Proj_P_CD6 = (CD6_slope.* CD_Future_Years) + CD6_intercept;
Proj_P_CD7 = (CD7_slope.* CD_Future_Years) + CD7_intercept;

%Plot of Historical and Projected Precipitation Trends in California
%Climate Divisions
figure(12); clf
h(1)=plot(P_CD_1,CD1_Smoothed_Precip,'r')
hold on
h(2)=plot(P_CD_2,CD2_Smoothed_Precip)
hold on
h(3)=plot(P_CD_3,CD3_Smoothed_Precip)
hold on
h(4)=plot(P_CD_4,CD4_Smoothed_Precip)
hold on
h(5)=plot(P_CD_5,CD5_Smoothed_Precip)
hold on
h(6)=plot(P_CD_6,CD6_Smoothed_Precip)
hold on
h(7)=plot(P_CD_7,CD7_Smoothed_Precip)
hold on
h(8)=plot(P_CD_1,LBF_P_CD1,'color','#0343df')
hold on
plot(P_CD_2,LBF_P_CD2,'color','#0343df')
hold on
plot(P_CD_3,LBF_P_CD3,'color','#0343df')
hold on
plot(P_CD_4,LBF_P_CD4,'color','#0343df')
hold on
plot(P_CD_5,LBF_P_CD5,'color','#0343df')
hold on
plot(P_CD_6,LBF_P_CD6,'color','#0343df')
hold on
plot(P_CD_7,LBF_P_CD7,'color','#0343df')
hold on
h(9)=plot(CD_Future_Years,Proj_P_CD1,'k-.','Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD2,'k-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD3,'k-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD4,'k-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD5,'k-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD6,'k-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD7,'k-.', 'Linewidth', 1)
hold on
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Precipitation (in)')
title ('Historical and Projected Precipitation in California Climate Divisions until 2050')
lgd = legend(h, {'Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7',...
        'Historical Trendline','Projected Trendline','Location', 'southoutside'})

%% California Climate Divisions Temperature Predictions 

%Historical Trendlines' Slope and Intercept
CD1_slope = BF_T_CD1(1,1); 
CD1_intercept = BF_T_CD1(1,2);
CD2_slope = BF_T_CD2(1,1); 
CD2_intercept = BF_T_CD2(1,2);
CD3_slope = BF_T_CD3(1,1); 
CD3_intercept = BF_T_CD3(1,2);
CD4_slope = BF_T_CD4(1,1); 
CD4_intercept = BF_T_CD4(1,2);
CD5_slope = BF_T_CD5(1,1); 
CD5_intercept = BF_T_CD5(1,2);
CD6_slope = BF_T_CD6(1,1); 
CD6_intercept = BF_T_CD6(1,2);
CD7_slope = BF_T_CD7(1,1); 
CD7_intercept = BF_T_CD7(1,2);

%Future Temperature Trendlines
Proj_T_CD1 = (CD1_slope.* CD_Future_Years) + CD1_intercept;
Proj_T_CD2 = (CD2_slope.* CD_Future_Years) + CD2_intercept;
Proj_T_CD3 = (CD3_slope.* CD_Future_Years) + CD3_intercept;
Proj_T_CD4 = (CD4_slope.* CD_Future_Years) + CD4_intercept;
Proj_T_CD5 = (CD5_slope.* CD_Future_Years) + CD5_intercept;
Proj_T_CD6 = (CD6_slope.* CD_Future_Years) + CD6_intercept;
Proj_T_CD7 = (CD7_slope.* CD_Future_Years) + CD7_intercept;

%Plot of Historical and Projected Temperature Trends in California
%Climate Divisions
figure(13); clf
t(1)=plot(T_CD_1,CD1_Smoothed_Temp)
hold on
t(2)=plot(T_CD_2,CD2_Smoothed_Temp)
hold on
t(3)=plot(T_CD_3,CD3_Smoothed_Temp)
hold on
t(4)=plot(T_CD_4,CD4_Smoothed_Temp)
hold on
t(5)=plot(T_CD_5,CD5_Smoothed_Temp)
hold on
t(6)=plot(T_CD_6,CD6_Smoothed_Temp)
hold on
t(7)=plot(T_CD_7,CD7_Smoothed_Temp)
hold on
t(8)=plot(CD_Future_Years,Proj_T_CD1,'k-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD2,'k-.','Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD3,'k-.','Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD4,'k-.','Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD5,'k-.','Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD6,'k-.','Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD7,'k-.', 'Linewidth', 1)
hold on
t(9)=plot(T_CD_1,LBF_T_CD1)
plot(T_CD_2,LBF_T_CD2,'color','#0343df')
plot(T_CD_3,LBF_T_CD3,'color','#0343df')
plot(T_CD_4,LBF_T_CD4,'color','#0343df')
plot(T_CD_5,LBF_T_CD5,'color','#0343df')
plot(T_CD_6,LBF_T_CD6,'color','#0343df')
plot(T_CD_7,LBF_T_CD7,'color','#0343df')
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Average Temperature ({^o}F)')
title ('Historical and Projected Temperature in California Climate Divisions until 2050')
lgd = legend(t, {'Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7',...
        'Projected Trendline','Historical Trendline','Location', 'best'},'NumColumns',2)
