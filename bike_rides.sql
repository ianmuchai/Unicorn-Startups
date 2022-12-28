create table bike_rides (ride_id varchar(250), bike_type varchar(250), started_at varchar(250), 
						 ended_at varchar(250), start_station_name varchar(250), start_station_id varchar(250),
						 end_station_name varchar(250), end_station_id varchar(250), usertype varchar(250), 
						 date_id date, days_of_week varchar(250), trip_duration numeric)
select * from bike_rides						

-- Separating the date from the time to start and end the race into a new table.
select *,split_part(started_at,' ',1) as starting_date, split_part(started_at,' ',2) as start_time,
split_part(ended_at,' ',1) as ending_date, split_part(ended_at,' ',2) as ending_time
into RAMP_table from bike_rides

select * from ramp_table

--Changing the data type os starting date to date
select to_char(to_date(starting_date, 'MM/DD/YYYY'), 'YYYY-MM-DD') as new_starting_date,
to_char(to_date(ending_date, 'MM/DD/YYYY'), 'YYYY-MM-DD')
into fresh_table from ramp_table

select * from fresh_table

alter table fresh_table rename column to_char to new_ending_date

--Updating the datatypes in columns to date datatypes
alter table fresh_table alter column new_starting_date type date 
USING new_starting_date::date

alter table fresh_table alter column new_ending_date type date 
USING new_ending_date::date

--joining fresh_table to ramp_table
select new_starting_date, new_ending_date from fresh_table cross join ramp_table

ALTER TABLE ramp_table ALTER starting_date TYPE DATE 
using to_date(starting_date, 'YYYY-MM-DD')


--Deleting duplicate rows and columns
Alter table bike_rides drop column started_at
Alter table bike_rides drop column ended_at

--Checking relationship between bike type and trip duration
select ride_id, bike_type, usertype, trip_duration from bike_rides
order by trip_duration desc, bike_type

--Calculating number of classic bikes, electric bikes, and docked bikes
Select bike_type, count(bike_type) as total_bikes
from bike_rides group by bike_type order by bike_type


alter table bike_rides alter column trip_duration type numeric

--average trip duration for each bike type
select avg(trip_duration) from bike_rides where bike_type = 'electric_bike' 
select avg(trip_duration) from bike_rides where bike_type = 'docked_bike'
select avg(trip_duration) from bike_rides where bike_type = 'classic_bike'

--checking the numbers by usertype
Select usertype, count(bike_type) as total_users
from bike_rides group by usertype order by usertype

--checking riding frequency by day of the week
Select days_of_week, count(days_of_week) as user_by_day
from bike_rides group by days_of_week order by user_by_day