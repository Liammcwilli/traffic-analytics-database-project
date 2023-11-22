-- STEP 1 Let’s first try to understand the size of the table. Write a query to return the total size of the table (excluding indexes).

SELECT pg_size_pretty(pg_table_size('sensors.observations'));

-- STEP 2 Write a query that returns the size of each of these indexes. What’s the name of the largest index on this table?

SELECT 
    pg_size_pretty(pg_total_relation_size('sensors.observations_pkey')) as idx_1_size,
    pg_size_pretty(pg_total_relation_size('sensors.observations_location_id_datetime_idx')) as idx_2_size;

-- STEP 3 Write a query that returns the size of the table’s data, indexes, and the total relation size as three separate columns.

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size, 
    pg_size_pretty(pg_indexes_size('sensors.observations')) as idx_size,
    pg_size_pretty(pg_total_relation_size('sensors.observations')) as total_size;

-- STEP 4 Write a query that UPDATEs the value of distance to feet. You can do this by multiplying the current value of the column by 3.28

UPDATE sensors.observations
SET distance = (distance * 3.281)
WHERE TRUE;

-- STEP 5 Check the size of the tables and indexes now, are they significantly larger following the UPDATE?

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size, 
    pg_size_pretty(pg_indexes_size('sensors.observations')) as idx_size,
    pg_size_pretty(pg_total_relation_size('sensors.observations')) as total_size;

-- STEP 6 Run a regular vacuum on the table, what effect do you think this will have on table size? Check your hypothesis by querying the database for this table’s pg_table_size.

VACUUM sensors.observations;

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size;

-- STEP 7 A new software update has allowed us to add another 1000 observations of dogs, motorbikes, and trucks.

\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './additional_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

-- STEP 8 Check the table size of sensors.observations now. Given that we’ve just VACUUMed the table, what do you think will have happened to the table’s total size on disk?

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size;

-- STEP 9 Looks like this table hasn’t increased it’s space on disk because of the insert. Run a VACUUM FULL on this table to return any excess space this table is consuming to the operating system.

VACUUM FULL sensors.observations;

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size;

-- STEP 10 Let’s remove some of the sensors from our dataset, perhaps these cameras were faulty and need to be repaired before they can be re-deployed and have their observations included in the dataset. Write a query that DELETEs all cameras at a location_id greater than 24.

DELETE FROM sensors.observations
WHERE location_id > 24;

-- STEP 11 What effect do you expect this DELETE would have on the table’s disk usage? Check the size of the table’s data.

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size;

-- STEP 12 Using TRUNCATE, clear all the values from sensors.observations.

TRUNCATE sensors.observations;

-- STEP 13 To compare the results of TRUNCATE and VACUUM FULL, paste the following statements into the editor. These will load the values from the original (10,000 obs.) and supplemental (1,000 obs.) into the table. How would you expect the size of this table to compare to the size you found in step 9?

\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './original_obs_types.csv' WITH DELIMITER ',' CSV HEADER;


\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './additional_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size;


-- STEP 14 Write a query that checks the total table, index, and combined size of the table now. How does the size of the table size compare to the table size following the VACUUM FULL you ran earlier in this project?

SELECT 
    pg_size_pretty(pg_table_size('sensors.observations')) as tbl_size, 
    pg_size_pretty(pg_indexes_size('sensors.observations')) as idx_size,
    pg_size_pretty(pg_total_relation_size('sensors.observations')) as total_size;