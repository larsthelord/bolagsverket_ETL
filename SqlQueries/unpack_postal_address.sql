
CREATE OR REPLACE TABLE postadress_intermediate as
SELECT
    LEFT(organisationsidentitet, instr(organisationsidentitet, '$') - 1) as organisationsidentitet,
    generate_subscripts(string_split(postadress, '$'), 1) as indeks,
    unnest(string_split(postadress, '$')) as objekt
FROM
    bolagsverket;

CREATE OR REPLACE TABLE postadress as
SELECT
    organisationsidentitet,
    MAX(CASE WHEN indeks = 1 THEN objekt ELSE NULL END::VARCHAR) as postAdress,
    MAX(CASE WHEN indeks = 2 THEN objekt ELSE NULL END::VARCHAR) as CoAdress,
    MAX(CASE WHEN indeks = 3 THEN objekt ELSE NULL END::VARCHAR) as postStad,
    MAX(CASE WHEN indeks = 4 THEN objekt ELSE NULL END::VARCHAR) as postNummer,
    CASE 
        WHEN MAX(CASE WHEN indeks = 5 THEN objekt ELSE NULL END::VARCHAR) = 'SE-LAND' THEN 'Sverige'
        ELSE MAX(CASE WHEN indeks = 5 THEN objekt ELSE NULL END::VARCHAR)
        END as postLand,
FROM
    postadress_intermediate
GROUP BY
    organisationsidentitet;