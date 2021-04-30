%% Data for Acres Burned due to Wildfires in California

filename='1987-2018CalWildfireData';
TotalAcresBurned=readtable(filename);
Total_Burned=table2array(TotalAcresBurned);
Total_Burned(9,2)=209815; %had to fill in value from table because comma caused it to be a NaN

%Graphing Exploratory 
figure (1)
bar(Total_Burned(:,1),Total_Burned(:,2))
xlabel("Year")
ylabel("Acres Burned")
title("Acres Burned due to Wildfires from 1987-2018")

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
LBF_P_CD1 =polyval(BF_P_CD1,P_CD_1)
BF_P_CD2 = polyfit(P_CD_2,CD2_Smoothed_Precip,1);
LBF_P_CD2 =polyval(BF_P_CD2,P_CD_2)
BF_P_CD3 = polyfit(P_CD_3,CD3_Smoothed_Precip,1);
LBF_P_CD3 =polyval(BF_P_CD3,P_CD_3)
BF_P_CD4 = polyfit(P_CD_4,CD4_Smoothed_Precip,1);
LBF_P_CD4 =polyval(BF_P_CD4,P_CD_4)
BF_P_CD5 = polyfit(P_CD_5,CD5_Smoothed_Precip,1);
LBF_P_CD5 =polyval(BF_P_CD5,P_CD_5)
BF_P_CD6 = polyfit(P_CD_6,CD6_Smoothed_Precip,1);
LBF_P_CD6 =polyval(BF_P_CD6,P_CD_6)
BF_P_CD7 = polyfit(P_CD_7,CD7_Smoothed_Precip,1);
LBF_P_CD7 =polyval(BF_P_CD7,P_CD_7)

%Plot of Historical Observed Precipitation Data in California 
figure(2); clf
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
plot(P_CD_1,LBF_P_CD1,'-.')
plot(P_CD_2,LBF_P_CD2,'-.')
plot(P_CD_3,LBF_P_CD3,'-.')
plot(P_CD_4,LBF_P_CD4,'-.')
plot(P_CD_5,LBF_P_CD5,'-.')
plot(P_CD_6,LBF_P_CD6,'-.')
plot(P_CD_7,LBF_P_CD7,'-.')
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Precipitation (in)')
title ('Historical Observed Precipitation in California Climate Divisions from 1950 - Present')
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
LBF_T_CD1 =polyval(BF_T_CD1,T_CD_1)
BF_T_CD2 = polyfit(T_CD_2,CD2_Smoothed_Temp,1);
LBF_T_CD2 =polyval(BF_T_CD2,T_CD_2)
BF_T_CD3 = polyfit(T_CD_3,CD3_Smoothed_Temp,1);
LBF_T_CD3 =polyval(BF_T_CD3,T_CD_3)
BF_T_CD4 = polyfit(T_CD_4,CD4_Smoothed_Temp,1);
LBF_T_CD4 =polyval(BF_T_CD4,T_CD_4)
BF_T_CD5 = polyfit(T_CD_5,CD5_Smoothed_Temp,1);
LBF_T_CD5 =polyval(BF_T_CD5,T_CD_5)
BF_T_CD6 = polyfit(T_CD_6,CD6_Smoothed_Temp,1);
LBF_T_CD6 =polyval(BF_T_CD6,T_CD_6)
BF_T_CD7 = polyfit(T_CD_7,CD7_Smoothed_Temp,1);
LBF_T_CD7 =polyval(BF_T_CD7,T_CD_7)

%Plot of Historical Observed Temperature Data in California 
figure(3); clf
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
plot(T_CD_1,LBF_T_CD1,'-.')
plot(T_CD_2,LBF_T_CD2,'-.')
plot(T_CD_3,LBF_T_CD3,'-.')
plot(T_CD_4,LBF_T_CD4,'-.')
plot(T_CD_5,LBF_T_CD5,'-.')
plot(T_CD_6,LBF_T_CD6,'-.')
plot(T_CD_7,LBF_T_CD7,'-.')
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Average Temperature ({^o}F)')
title ('Historical Observed Average Temperature in California Climate Divisions from 1950 - Present')
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
scatterm(Wildfire_Locations_2020.latitude,Wildfire_Locations_2020.longitude,5,'filled','k')
hold on 
scatterm(SQF_Climatology.LATITUDE(1), SQF_Climatology.LONGITUDE(1),200, 'p','filled','r')
title('Location of Wildfires in California in 2020')
% legend ('Wildfire Events','Sequoia Forest Location')

%% Plotting Historical Precipitation at SQF Station

%Plotting Observed Daily Precipitation Amounts
figure(5);clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Daily Recorded Precipitation at SQF from 1970 to Present')

%Smoothing the Data to a 2-year moving mean (730 days)
Smoothed_SQF_Precip = movmean(SQF_Climatology.PRCP(2189:end),730,'omitnan');
%added 'omitnan' to disregard nan values

%Linear Fit of Data
SQF_Date_Conversion = datenum(SQF_Climatology.DATE(2189:end));
BF_SQF_P = polyfit(SQF_Date_Conversion,Smoothed_SQF_Precip,1);
LBF_SQF_P =polyval(BF_SQF_P,SQF_Date_Conversion);

%Plot of Smoothed Historical Precipitation Data at Sequoia Forest
figure (6); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Daily Recorded Precipitation at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',2,'color', 'r')

figure(7);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',1,'color', 'r')
hold on
plot(SQF_Climatology.DATE(2189:end), LBF_SQF_P, '-.b') 
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Smoothed Daily Recorded Precipitation at SQF from 1970 to Present')
%legend



%% Plotting Historical Temperature at SQF Station

%Plotting Observed Daily Temperatures
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

%Plot of Smoothed Historical Precipitation Data at Sequoia Forest
figure(9); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.TOBS(2189:end), '.')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Daily Recorded Temperature at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',2,'color', 'r')

figure(11);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',1,'color', 'r')
hold on
plot(SQF_Climatology.DATE(2189:end), LBF_SQF_T, '-.b')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Smoothed Daily Recorded Temperature Data at SQF from 1970 to Present')
%legend

%% Future Predictions for Climatology and Wildfires

%Sequoia Forest Precipitation Predictions 
%Future_Years = [2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032 2033 2034 2035 2036 2037 2038 2039 2040 2041 2042 2043 2044 2045 2046 2047 2048 2049 2050];

%hline
slope1 = BF_SQF_P(1,1)
intercept1 = BF_SQF_P(1,2)
SQF_Proj_P = refline(slope1,intercept1);

figure(12);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',1,'color', 'r')
SQF_Proj_P = refline(slope1,intercept1)


% hold on
% plot(SQF_Climatology.DATE(2189:end), LBF_SQF_P, '-.b') 
% xlabel('Year')
% ylabel ('Precipitation (in)') %%Is this in, cm, or mm
% title('Smoothed Daily Recorded Precipitation at SQF from 1970 to Present')
% %legend






%set up variable thats equation of line, and make an array with all x
%values
%m9x) + b = yall
%plot (xall, yall) 

%OR

%hline/ refline function 
%plug in M+B and makes like as long as we want to 








