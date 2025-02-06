CREATE OR REPLACE EXTERNAL TABLE terraform-demo-448805.trips_data_all.external_yellow_tripdata
OPTIONS(
  format='parquet',
  uris = ['gs://terraform-demo-448805-terra-bucket/trip_data/yellow_tripdata_2024-*.parquet']
);

CREATE OR REPLACE TABLE terraform-demo-448805.trips_data_all.yellow_tripdata
AS
SELECT * FROM terraform-demo-448805.trips_data_all.external_yellow_tripdata;

-- Question 1
-- 20332093
SELECT COUNT(*) FROM terraform-demo-448805.trips_data_all.external_yellow_tripdata;

-- 20332093
SELECT COUNT(*) FROM terraform-demo-448805.trips_data_all.yellow_tripdata;


-- Question 2

SELECT COUNT(DISTINCT PULocationID) FROM terraform-demo-448805.trips_data_all.external_yellow_tripdata;
-- Bytes processed 155.12 MB
SELECT COUNT(DISTINCT PULocationID) FROM terraform-demo-448805.trips_data_all.yellow_tripdata;


-- Question 3
-- Bytes processed 155.12 MB
SELECT PULocationID FROM terraform-demo-448805.trips_data_all.yellow_tripdata;

-- Bytes processed : 310.24 MB
SELECT PULocationID, DOLocationID  FROM terraform-demo-448805.trips_data_all.yellow_tripdata;

-- Question 4
-- 8333
-- Bytes processed 155.12 MB
SELECT COUNT(*) FROM terraform-demo-448805.trips_data_all.yellow_tripdata WHERE fare_amount = 0;


-- 8333
-- Bytes processed 155.12 MB
SELECT COUNT(fare_amount) FROM terraform-demo-448805.trips_data_all.yellow_tripdata WHERE fare_amount = 0;

-- Question 5
CREATE OR REPLACE TABLE terraform-demo-448805.trips_data_all.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS SELECT * FROM  terraform-demo-448805.trips_data_all.yellow_tripdata;

-- Question 6
-- Bytes processed 310.24 MB

SELECT DISTINCT VendorID
FROM terraform-demo-448805.trips_data_all.yellow_tripdata
WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' and DATE(tpep_dropoff_datetime) <= '2024-03-15';


-- Bytes processed 26.84 MB
SELECT DISTINCT VendorID
FROM terraform-demo-448805.trips_data_all.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' and DATE(tpep_dropoff_datetime) <= '2024-03-15';

-- Question 9
-- Estimated Bytes Processed : This query will process 0 B when run
-- Because COUNT(*) with no filters is a metadata operation which doesn't involve scanning rows or using slots i.e. data is 
-- already available in the metadata
SELECT count(*) FROM terraform-demo-448805.trips_data_all.yellow_tripdata
