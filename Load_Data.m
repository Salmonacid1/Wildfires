%% Data for Acres Burned due to Wildfires in California

filename='1987-2018CalWildfireData';
TotalAcresBurned=readtable(filename);
Total_Burned=table2array(TotalAcresBurned);
Total_Burned(9,2)=209815; %had to fill in value from table because comma caused it to be a NaN

%Graphing Exploratory 
figure (1)
bar(Total_Burned(:,1),Total_Burned(:,2), 'FaceColor', '#77AC30')
xlabel("Year")
ylabel("Acres Burned")
title("Acres Burned due to California Wildfires from 1987-2018")

%% Spatial Data for 2020 Wildfires in California

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


%% Climatological Data for California's Climate Divisions

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
figure(2); clf
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

%% Plotting Observed Average Temperature Overtime in California  

%Smoothing the Data to a 5-year moving mean (60 month values) 
CD1_Smoothed_Temp = movmean(AverageTemp_CD_1.Value, 60);
CD2_Smoothed_Temp = movmean(AverageTemp_CD_2.Value, 60);
CD3_Smoothed_Temp = movmean(AverageTemp_CD_3.Value, 60);
CD4_Smoothed_Temp = movmean(AverageTemp_CD_4.Value, 60);
CD5_Smoothed_Temp = movmean(AverageTemp_CD_5.Value, 60);
CD6_Smoothed_Temp = movmean(AverageTemp_CD_6.Value, 60);
CD7_Smoothed_Temp = movmean(AverageTemp_CD_7.Value, 60);

%Line of Best Fit Temperature
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
figure(3); clf
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
%% Sequoia Forest Data

filename = 'SQF Location Temp.csv';
SQF_Climatology=readtable(filename);

%Exploratory Figure - Location of SQF Lodegpole Station
latlim= [32 42.5]
lonlim = [-125 -114.133333]

figure (4); clf
ax= usamap(latlim,lonlim);
axis off
getm(gca, 'MapProjection')
states = shaperead('usastatehi',...
    'UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
geoshow(ax,states,'SymbolSpec',faceColors)
h(1)= scatterm(Wildfire_Locations_2020.latitude,Wildfire_Locations_2020.longitude,5,'filled','k', 'DisplayName', '2020 Wildfire Events')
hold on 
h(2) = scatterm(SQF_Climatology.LATITUDE(1), SQF_Climatology.LONGITUDE(1),200, 'p','filled','r', 'DisplayName', 'Sequoia Forest')
title('Location of California Wildfires in 2020')
legend(h)

%% Plotting Historical Precipitation at SQF Station

%Exploratory Graph: Plotting Observed Daily Precipitation Amounts
figure(5);clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Daily Recorded Precipitation at SQF from 1970 to Present')
legend ('Observed Precipitation', 'Box', 'on')

%Smoothing the Data to a 2-year moving mean (730 days)
Smoothed_SQF_Precip = movmean(SQF_Climatology.PRCP(2189:end),730,'omitnan');
%added 'omitnan' to disregard nan values

%Linear Fit of Data
SQF_Date_Conversion = datenum(SQF_Climatology.DATE(2189:end));
BF_SQF_P = polyfit(SQF_Date_Conversion,Smoothed_SQF_Precip,1);
LBF_SQF_P =polyval(BF_SQF_P,SQF_Date_Conversion);

%Exploratory Graph: Plot of Smoothed Historical Precipitation Data at Sequoia Forest
figure (6); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') 
title('Daily Recorded Precipitation at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',2,'color', 'r')
legend('Observed Precipitation', 'Smoothed Precipitation Data')

figure(7);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',0.9,'color', '#0072BD')
hold on
plot(SQF_Climatology.DATE(2189:end), LBF_SQF_P, '-.', 'Linewidth', 1.2, 'color', '#77AC30') 
xlabel('Year')
ylabel ('Precipitation (in)') 
title('Observed Daily Precipitation at Sequoia Forest from 1970 to Present')
legend ('Smoothed Precipitation Data','Linear Trend', 'Box', 'on')



%% Plotting Historical Temperature at SQF Station

%Exploratory Graph: Plotting Observed Daily Temperatures
figure(8);clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.TOBS(2189:end), '.')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Daily Recorded Temperature at SQF from 1970 to Present')

%Smoothing the Data to a 2-year moving mean (730 days)
Smoothed_SQF_Temp = movmean(SQF_Climatology.TOBS(2189:end),730, 'omitnan');
%added 'omitnan' as well

%Linear Fit of Data
BF_SQF_T = polyfit(SQF_Date_Conversion,Smoothed_SQF_Temp,1);
LBF_SQF_T =polyval(BF_SQF_T,SQF_Date_Conversion);

%Exploratory Graph: Plot of Smoothed Historical Precipitation Data at Sequoia Forest
figure(9); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.TOBS(2189:end), '.')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Daily Recorded Temperature at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',2,'color', 'r')

figure(11);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',0.9,'color', '#0072BD')
hold on
plot(SQF_Climatology.DATE(2189:end), LBF_SQF_T, '-.', 'Linewidth', 1.2, 'color', '#77AC30') 
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Observed Daily Average Temperature at Sequoia Forest from 1970 to Present')
legend ({'Smoothed Observered Temperature Data','Linear Trend'}, 'Box', 'on')

%% Sequoia Forest Precipitation Predictions 

%Trend Line Slope and Intercept
slope1 = BF_SQF_P(1,1);
intercept1 = BF_SQF_P(1,2);

%Creating Future Timeline
t1=datetime(2021,1,1);
t2=datetime(2050,1,1);
formatOut = 'yyyy/mm/dd';
Future_Years= [t1:t2]';
SQF_Future_Years = datenum(Future_Years);
%%SQF_Future_Years = datestr(Future_Years, formatOut);

%Creating Future Trend
SQF_Proj_P = (slope1.* SQF_Future_Years) + intercept1;

figure(12); clf
plot(SQF_Future_Years,SQF_Proj_P, '-.','Linewidth', 1.5,'color','#D95319')
hold on
plot(SQF_Date_Conversion,Smoothed_SQF_Precip,'Linewidth',1,'color', '#0072BD')
hold on
plot(SQF_Date_Conversion, LBF_SQF_P, '-.', 'Linewidth', 1,'color','#77AC30')
xlabel('Year')
ylabel ('Precipitation (in)') 
title('Projected Precipitation Trend at Sequoia Forest')
datetick ('x','yyyy')
legend ('Projected Precipitation Trend', 'Smoothed Precipitation Data', 'Historical Linear Trend', 'Box', 'on')

%% Sequoia Forest Temperature Predictions 

%Trend Line Slope and Intercept
slope2 = BF_SQF_T(1,1);
intercept2 = BF_SQF_T(1,2);
SQF_Proj_T = (slope2.* SQF_Future_Years) + intercept2;

figure(13); clf
plot(SQF_Future_Years,SQF_Proj_T,'-.','Linewidth', 1.5,'color','#D95319')
hold on
plot(SQF_Date_Conversion,Smoothed_SQF_Temp,'Linewidth',1,'color', '#0072BD')
hold on
plot(SQF_Date_Conversion, LBF_SQF_T,'-.', 'Linewidth', 1,'color','#77AC30')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Projected Temperature Trend at Sequoia Forest')
datetick ('x','yyyy')
legend ('Projected Temperature Trend', 'Smoothed Temperature Data', 'Linear Trend', 'Box', 'on')

%% California Climate Divisions Precipitation Predictions 


%Creating Future Timeline
t1=datetime(2021,1,1);
t2=datetime(2050,1,1);
Future_Years= [t1:t2]';
CD_Future_Years = datenum(Future_Years);

%Trend Lines, Slope, and Intercept
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

%Creating Future Trend
Proj_P_CD1 = (CD1_slope.* CD_Future_Years) + CD1_intercept;
Proj_P_CD2 = (CD2_slope.* CD_Future_Years) + CD2_intercept;
Proj_P_CD3 = (CD3_slope.* CD_Future_Years) + CD3_intercept;
Proj_P_CD4 = (CD4_slope.* CD_Future_Years) + CD4_intercept;
Proj_P_CD5 = (CD5_slope.* CD_Future_Years) + CD5_intercept;
Proj_P_CD6 = (CD6_slope.* CD_Future_Years) + CD6_intercept;
Proj_P_CD7 = (CD7_slope.* CD_Future_Years) + CD7_intercept;

figure(14); clf
plot(CD_Future_Years,Proj_P_CD1,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD2,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD3,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD4,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD5,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD6,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_P_CD7,'-.', 'Linewidth', 1)
hold on
plot(P_CD_1,CD1_Smoothed_Precip)
hold on
plot(P_CD_2,CD2_Smoothed_Precip)
hold on
plot(P_CD_3,CD3_Smoothed_Precip)
hold on
plot(P_CD_4,CD4_Smoothed_Precip)
hold on
plot(P_CD_5,CD5_Smoothed_Precip)
hold on
plot(P_CD_6,CD6_Smoothed_Precip)
hold on
plot(P_CD_7,CD7_Smoothed_Precip)
hold on 
plot(P_CD_1,LBF_P_CD1)
plot(P_CD_2,LBF_P_CD2)
plot(P_CD_3,LBF_P_CD3)
plot(P_CD_4,LBF_P_CD4)
plot(P_CD_5,LBF_P_CD5)
plot(P_CD_6,LBF_P_CD6)
plot(P_CD_7,LBF_P_CD7)
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Precipitation (in)')
title ('Historical and Projected Precipitation in California Climate Divisions until 2050')
lgd = legend ('Climate Division 1 Projected Trend', 'Climate Division 2 Projected Trend', 'Climate Division 3 Projected Trend', 'Climate Division 4 Projected Trend', 'Climate Division 5 Projected Trend', 'Climate Division 6 Projected Trend', 'Climate Division 7 Projected Trend',...
    'Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7',...
    'Trendline Climate Division 1','Trendline Climate Division 2','Trendline Climate Division 3','Trendline Climate Division 4','Trendline Climate Division 5','Trendline Climate Division 6','Trendline Climate Division 7',...
    'Location', 'southoutside')
lgd.NumColumns = 3

%% California Climate Divisions Temperature Predictions 

%Trend Lines, Slope, and Intercept
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

%Creating Future Trend
Proj_T_CD1 = (CD1_slope.* CD_Future_Years) + CD1_intercept;
Proj_T_CD2 = (CD2_slope.* CD_Future_Years) + CD2_intercept;
Proj_T_CD3 = (CD3_slope.* CD_Future_Years) + CD3_intercept;
Proj_T_CD4 = (CD4_slope.* CD_Future_Years) + CD4_intercept;
Proj_T_CD5 = (CD5_slope.* CD_Future_Years) + CD5_intercept;
Proj_T_CD6 = (CD6_slope.* CD_Future_Years) + CD6_intercept;
Proj_T_CD7 = (CD7_slope.* CD_Future_Years) + CD7_intercept;

figure(15); clf
plot(CD_Future_Years,Proj_T_CD1,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD2,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD3,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD4,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD5,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD6,'-.', 'Linewidth', 1)
hold on
plot(CD_Future_Years,Proj_T_CD7,'-.', 'Linewidth', 1)
hold on
plot(T_CD_1,CD1_Smoothed_Temp)
hold on
plot(T_CD_2,CD2_Smoothed_Temp)
hold on
plot(T_CD_3,CD3_Smoothed_Temp)
hold on
plot(T_CD_4,CD4_Smoothed_Temp)
hold on
plot(T_CD_5,CD5_Smoothed_Temp)
hold on
plot(T_CD_6,CD6_Smoothed_Temp)
hold on
plot(T_CD_7,CD7_Smoothed_Temp)
plot(T_CD_1,LBF_T_CD1)
plot(T_CD_2,LBF_T_CD2)
plot(T_CD_3,LBF_T_CD3)
plot(T_CD_4,LBF_T_CD4)
plot(T_CD_5,LBF_T_CD5)
plot(T_CD_6,LBF_T_CD6)
plot(T_CD_7,LBF_T_CD7)
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Average Temperature ({^o}F)')
title ('Historical and Projected Temperature in California Climate Divisions until 2050')
lgd = legend ('Climate Division 1 Projected Trend', 'Climate Division 2 Projected Trend', 'Climate Division 3 Projected Trend', 'Climate Division 4 Projected Trend', 'Climate Division 5 Projected Trend', 'Climate Division 6 Projected Trend', 'Climate Division 7 Projected Trend',...
    'Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7',...
    'Trendline Climate Division 1','Trendline Climate Division 2','Trendline Climate Division 3','Trendline Climate Division 4','Trendline Climate Division 5','Trendline Climate Division 6','Trendline Climate Division 7',...
    'Location', 'southoutside')
lgd.NumColumns = 3

%% Acres Burned by Wildfires Prediction 

figure (16); clf
plot(Total_Burned(:,1),Total_Burned(:,2), '.', 'MarkerSize', 8)
xlabel("Year")
ylabel("Acres Burned")
title("Acres Burned due to Wildfires from 1987-2018")

%Trend Line
Wildfire_Time = Total_Burned(:,1);
Wildfire_BF = polyfit(Total_Burned(:,1), Total_Burned(:,2), 1);
Wildfire_LBF = polyval(Wildfire_BF, Total_Burned(:,1));

figure (17); clf
plot(Total_Burned(:,1),Total_Burned(:,2), '.', 'MarkerSize', 8)
hold on
plot(Total_Burned(:,1), Wildfire_LBF)
xlabel("Year")
ylabel("Acres Burned")
title("Acres Burned due to Wildfires from 1987-2018")

%%Projections Trend Line
slope1= Wildfire_BF(1,1)
intercept1=Wildfire_BF(1,2)
Wildfire_Future_Time = [2018:1:2050]'
Proj_Acres_Burned = slope1.*Wildfire_Future_Time + intercept1;

figure (18); clf
plot(Total_Burned(:,1),Total_Burned(:,2), '.', 'MarkerSize', 11)
hold on
plot(Total_Burned(:,1), Wildfire_LBF, 'color','#77AC30','LineWidth', 1)
hold on 
plot(Wildfire_Future_Time, Proj_Acres_Burned,'r','LineWidth', 1)
xlabel("Year")
ylabel("Acres Burned")
title("Historical and Projected Acres Burned due to Wildfires until 2050")
legend('Wildfire Acres Burned', 'Wildfire Acres Trendline', 'Wildfire Acres Projected Trendline') 









