CREATE OR REPLACE TABLE scb AS 
SELECT
    *
FROM
    read_csv('<<FILEPATH>>', sample_size = -1, delim="\t")