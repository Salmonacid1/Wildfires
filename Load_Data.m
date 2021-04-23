%% Load Data

%Load 1987-2018 data; plot time vs acres burned graph 
filename='1987-2018CalWildfireData';
TotalAcresBurned=readtable(filename)
Total_Burned= table2array (TotalAcresBurned)
Total_Burned(9,2)=209815

%% Graphing Exploratory 

%plot(Total_Burned(:,1),Total_Burned(:,2), "markersize", 3)

figure (1)
bar(Total_Burned(:,1),Total_Burned(:,2))
xlabel("Year")
ylabel("Acres Burned")
title("Wildfires Acres Burned from 1987-2018")

%% wildfire 2020
%%loading filename for 2020 wildfire california
filename='fire_nrt_M-C61_195333';
WildfireLocations2020=readtable(filename);
LAT = WildfireLocations2020.latitude;
LON = WildfireLocations2020.longitude;
%%removing lat/lon not in CA
toDelete =LAT >42;
LAT(toDelete, :) = [];
toDelete = LAT<32;
LAT(toDelete, :) = [];
toDelete =LON >  ;
LON(toDelete, :) = [];
toDelete = LON<  ;
LON(toDelete, :) = [];

%%
figure (2)
%worldmap([32 42], [246 236])
cali = shaperead('usastatehi', 'UseGeoCoords', true,'Selector',{@(name) strcmpi(name,'California'), 'Name'});
axesm mercator; %Define Map axes
geoshow(cali); %Display map
plotm(LAT,LON,'Color','r','Marker','.','MarkerSize',1); %plot point at [lat,lon] location

%%use worldmap and constrain the lat/long for california 
