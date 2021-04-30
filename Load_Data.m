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

%Exploratory Map: Plotting 2020 Wildfire Data on a Map 
latlim= [32 42.5];
lonlim = [-125 -114.133333];

figure (2); clf
ax= usamap(latlim,lonlim);
axis off
getm(gca, 'MapProjection')
states = shaperead('usastatehi',...
    'UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
geoshow(ax,states,'SymbolSpec',faceColors)
scatterm(Wildfire_Locations_2020.latitude,Wildfire_Locations_2020.longitude,5,'filled','k')
title('Location of Wildfires in California in 2020')

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

% for i=1:7
%     filename = ['California, Climate Division ' num2str(i) ', Precipitation.csv'];
%     Precipitation_CD_{i}=readtable(filename);
% end

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

%% Plotting Observed Precipitation Overtime in California  

%Smoothing the Data to a 5-year moving mean (60 month values) 
CD1_Smoothed_Precip = movmean(Precipitation_CD_1.Value, 60);
CD2_Smoothed_Precip = movmean(Precipitation_CD_2.Value, 60);
CD3_Smoothed_Precip = movmean(Precipitation_CD_3.Value, 60);
CD4_Smoothed_Precip = movmean(Precipitation_CD_4.Value, 60);
CD5_Smoothed_Precip = movmean(Precipitation_CD_5.Value, 60);
CD6_Smoothed_Precip = movmean(Precipitation_CD_6.Value, 60);
CD7_Smoothed_Precip = movmean(Precipitation_CD_7.Value, 60);

%Linear Fit (HELP!)
LBF_P_CD1 = polyfit(P_CD_1,CD1_Smoothed_Precip,1);

%Plot of Historical Observed Precipitation Data in California 
figure(3); clf
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
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Precipitation (in)')
title ('Historical Observed Precipitation in California Climate Divisions from 1950 - Present')
legend ('Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7', 'Location', 'southoutside')

%% %%Plotting Observed Average Temperature Overtime in California  

%Smoothing the Data to a 5-year moving mean (60 month values) 
CD1_Smoothed_Temp = movmean(AverageTemp_CD_1.Value, 60);
CD2_Smoothed_Temp = movmean(AverageTemp_CD_2.Value, 60);
CD3_Smoothed_Temp = movmean(AverageTemp_CD_3.Value, 60);
CD4_Smoothed_Temp = movmean(AverageTemp_CD_4.Value, 60);
CD5_Smoothed_Temp = movmean(AverageTemp_CD_5.Value, 60);
CD6_Smoothed_Temp = movmean(AverageTemp_CD_6.Value, 60);
CD7_Smoothed_Temp = movmean(AverageTemp_CD_7.Value, 60);

%Plot of Historical Observed Precipitation Data in California 
figure(4); clf
plot(P_CD_1,CD1_Smoothed_Temp)
hold on
plot(P_CD_2,CD2_Smoothed_Temp)
hold on
plot(P_CD_3,CD3_Smoothed_Temp)
hold on
plot(P_CD_4,CD4_Smoothed_Temp)
hold on
plot(P_CD_5,CD5_Smoothed_Temp)
hold on
plot(P_CD_6,CD6_Smoothed_Temp)
hold on
plot(P_CD_7,CD7_Smoothed_Temp)
datetick('x','YYYY','keeplimits')
xlabel ('Year')
ylabel ('Average Temperature ({^o}F)')
title ('Historical Observed Average Temperature in California Climate Divisions from 1950 - Present')
legend ('Climate Division 1','Climate Division 2','Climate Division 3','Climate Division 4','Climate Division 5','Climate Division 6','Climate Division 7', 'Location', 'southoutside')

%% Sequoia Forest Data

filename = 'SQF Location Temp.csv';
SQF_Climatology=readtable(filename);

%Exploratory Figure - Location of SQF Lodegpole Station
latlim= [32 42.5]
lonlim = [-125 -114.133333]

figure (5); clf
ax= usamap(latlim,lonlim)
axis off
getm(gca, 'MapProjection')
states = shaperead('usastatehi',...
    'UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
geoshow(ax,states,'SymbolSpec',faceColors)
scatterm(SQF_Climatology.LATITUDE(1), SQF_Climatology.LONGITUDE(1),60, 'p','filled','k')
title('Location of Sequoia Forest')

%% Plotting Historical Precipitation at SQF Station

%Plotting Observed Daily Precipitation Amounts
figure(6);clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Daily Recorded Precipitation at SQF from 1970 to Present')

%Smoothing the Data to a 6-month moving mean (183 days)
Smoothed_SQF_Precip = movmean(SQF_Climatology.PRCP(2189:end),183);

%Plot of Smoothed Historical Precipitation Data at Sequoia Forest
figure (7); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.PRCP(2189:end), '.')
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Daily Recorded Precipitation at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',2,'color', 'r')

figure(8);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Precip,'Linewidth',1,'color', 'r')
xlabel('Year')
ylabel ('Precipitation (in)') %%Is this in, cm, or mm
title('Smoothed Daily Recorded Precipitation at SQF from 1970 to Present')



%% Plotting Historical Temperature at SQF Station

%Plotting Observed Daily Temperatures
figure(9);clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.TOBS(2189:end), '.')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Daily Recorded Temperature at SQF from 1970 to Present')

%Smoothing the Data to a 6-month moving mean (183 days)
Smoothed_SQF_Temp = movmean(SQF_Climatology.TOBS(2189:end),183);

%Plot of Smoothed Historical Precipitation Data at Sequoia Forest
figure(10); clf
scatter(SQF_Climatology.DATE(2189:end), SQF_Climatology.TOBS(2189:end), '.')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Daily Recorded Temperature at SQF from 1970 to Present')
hold on
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',2,'color', 'r')

figure(11);clf
plot(SQF_Climatology.DATE(2189:end),Smoothed_SQF_Temp,'Linewidth',1,'color', 'r')
xlabel('Year')
ylabel ('Temperature ({^o}F)') 
title('Smoothed Daily Recorded Temperature Data at SQF from 1970 to Present')





