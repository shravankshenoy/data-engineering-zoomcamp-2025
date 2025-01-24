### Q1 

```
-- 24.3.1
docker run -it --entrypoint=bash python:3.12.8
pip -V

```

### Q2

```
docker-compose up -d
```

### Q3

```
-- Approach 1 : Separate column for each category
-- 104,802; 198,924; 109,603; 27,678; 35,189
select 
	sum(case when trip_distance <= 1 then 1 else 0 end) as "Up to 1 mile",
	sum(case when trip_distance > 1 and trip_distance <=3 then 1 else 0 end) as "1 - 3 miles",
	sum(case when trip_distance > 3 and trip_distance <=7 then 1 else 0 end) as "3 - 7 miles",
	sum(case when trip_distance > 7 and trip_distance <=10 then 1 else 0 end) as "7 - 10 miles",
	sum(case when trip_distance > 10 then 1 else 0 end) as "Over 10 miles"
from green_taxi_data
where lpep_pickup_datetime::date >= '2019-10-01' and 
lpep_pickup_datetime::date < '2019-11-01' and
lpep_dropoff_datetime::date >= '2019-10-01' and 
lpep_dropoff_datetime::date < '2019-11-01' 

-- Approach 2 : Separate row for each category
-- 104,802; 198,924; 109,603; 27,678; 35,189
-- notice the use of single quotes since these are values and not column names
select 
	case when trip_distance <= 1 then 'Up to 1 mile'
		when trip_distance > 1 and trip_distance <=3 then  '1 - 3 miles'
		when trip_distance > 3 and trip_distance <=7 then  '3 - 7 miles'
		when trip_distance > 7 and trip_distance <=10 then '7 - 10 miles'
		when trip_distance > 10 then 'Over 10 miles'
		end as trip_segment,
	count(*) as trip_count
from green_taxi_data
where lpep_pickup_datetime::date >= '2019-10-01' and 
lpep_pickup_datetime::date < '2019-11-01' and
lpep_dropoff_datetime::date >= '2019-10-01' and 
lpep_dropoff_datetime::date < '2019-11-01' 
group by trip_segment

```

### Q4 

```
-- 2019-10-31, trip distance was 515.89
select lpep_pickup_datetime::date
from green_taxi_data
where trip_distance = (select max(trip_distance) from green_taxi_data)


```

### Q5

```
-- East Harlem North, East Harlem South, Morningside Heights
with top_pickups as 
(
    select 
        "PULocationID", 
        sum(total_amount)
    from green_taxi_data
    where lpep_pickup_datetime::date = '2019-10-18'
    group by "PULocationID"
    having sum(total_amount) > 13000
    order by sum(total_amount) desc
)
select 
    * 
from 
    top_pickups tp 
left join 
    taxi_zone_lookup tzl
on tp."PULocationID" = tzl."LocationID"

```

### Q6

```
-- JFK Airport
with EastHarlemPU as (
    select *
    from 
    green_taxi_data
    where "PULocationID" = (select "LocationID" from taxi_zone_lookup where "Zone"='East Harlem North')
)
select 
	"Zone"
from 
	EastHarlemPU ehp 
left join 
    taxi_zone_lookup tzl
on ehp."DOLocationID" = tzl."LocationID"
where ehp.tip_amount = (select max(tip_amount) from EastHarlemPU)

```

### Q7

```
terraform init
terraform apply -auto-approve
terraform destroy

```
