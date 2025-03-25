CREATE OR REPLACE TABLE scb AS 
select
    *
from
    read_csv('<<FILEPATH>>', sample_size = -1, delim="\t")