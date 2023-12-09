CREATE TABLE taxi_analis (
  vendor_id real,
  tpep_pickup_datetime timestamp,
  tpep_dropoff_datetime timestamp,
  passenger_count real,
  trip_distance real,
  ratecode_id real,
  store_and_fwd_flag varchar(1),
  pulocation_id integer,
  dolocation_id integer,
  payment_type real,
  fare_amount real,
  extra real,
  mta_tax real,
  tip_amount real,
  tolls_amount real,
  improvement_surcharge real,
  total_amount real,
  congestion_surcharge real
);

COPY taxi_analis(vendor_id, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count,
trip_distance, ratecode_id, store_and_fwd_flag, pulocation_id, dolocation_id, payment_type, fare_amount,
extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge)
FROM '/etc/data/yellow_tripdata_2020-01.csv'
DELIMITER ','
CSV HEADER;

select count(*) from taxi_analis



