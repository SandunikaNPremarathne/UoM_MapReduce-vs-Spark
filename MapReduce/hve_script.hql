DROP TABLE IF EXISTS Airline_Delay;

CREATE EXTERNAL TABLE Airline_Delay 
(RowNumber bigint, Year int, Month int, DayofMonth int, DayOfWeek int, DepTime double, CRSDepTime int, ArrTime double, CRSArrTime int, UniqueCarrier string, FlightNum int, TailNum String, ActualElapsedTime double, CRSElapsedTime double, AirTime double, ArrDelay double, DepDelay double, Origin String, Dest String, Distance int, TaxiIn double, TaxiOut double, Cancelled int, CancellationCode String, Diverted int, CarrierDelay double, WeatherDelay double, NASDelay double, SecurityDelay double, LateAircraftDelay double ) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE 
LOCATION "s3://data-loader-assignment-1/input/";


CREATE EXTERNAL TABLE Summery_Delay(
Year string,
carrier_delay string,
nas_delay string,
weather_delay string,
late_aircraft_delay string,
security_delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://data-loader-assignment-1/tables/';

-- Compute year wise summery delay from 2003-2010
INSERT OVERWRITE TABLE Summery_Delay
SELECT Year, SUM(CarrierDelay) AS Carrier_Delay, 
SUM(NASDelay) AS Nas_Delay,
SUM(WeatherDelay) AS Weather_Delay,
SUM(LateAircraftDelay) AS Late_Aircraft_Delay,
SUM(SecurityDelay) AS Security_Delay
FROM Airline_Delay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;


--Creating tables for delay types
CREATE EXTERNAL TABLE Carrier_Delay(
Year string,
Delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://data-loader-assignment-1/tables/';


CREATE EXTERNAL TABLE Nas_Delay(
Year string,
Delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://data-loader-assignment-1/tables/';

CREATE EXTERNAL TABLE Weather_Delay(
Year string,
Delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://data-loader-assignment-1/tables/';


CREATE EXTERNAL TABLE Late_Aircraft_Delay(
Year string,
Delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://data-loader-assignment-1/tables/';


CREATE EXTERNAL TABLE Security_Delay(
Year string,
Delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://data-loader-assignment-1/tables/';




-- Compute year wise carrier_delay from 2003-2010
INSERT OVERWRITE TABLE Carrier_Delay
SELECT Year, SUM(CarrierDelay) AS Carrier_Delay_Count
FROM Airline_Delay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise nas_delay from 2003-2010
INSERT OVERWRITE TABLE Nas_Delay
SELECT Year,SUM(NASDelay) AS Nas_Delay_Count
FROM Airline_Delay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise weather_delay from 2003-2010
INSERT OVERWRITE TABLE Weather_Delay
SELECT Year, SUM(WeatherDelay) AS Weather_Delay_Count
FROM Airline_Delay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise late_aircraft_delay from 2003-2010
INSERT OVERWRITE TABLE Late_Aircraft_Delay
SELECT Year, SUM(LateAircraftDelay) AS Late_Aircraft_Delay_Count
FROM Airline_Delay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise late_security_delay from 2003-2010
INSERT OVERWRITE TABLE Security_Delay
SELECT Year, SUM(SecurityDelay) AS Security_Delay_Count
FROM Airline_Delay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;
