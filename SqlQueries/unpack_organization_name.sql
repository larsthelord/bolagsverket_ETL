CREATE OR REPLACE TABLE organisationsnamn_intermediate as
SELECT
    organisationsidentitet,
    unnest(string_split(objekt, '$')) as namnVerdi,
    generate_subscripts(string_split(objekt, '$'), 1) indeks,
    CASE 
        WHEN objekt::VARCHAR like '%FORETAGSNAMN-ORGNAM%' THEN 'Foretagsnamn'
        WHEN objekt::VARCHAR like '%NAMN-ORGNAM%' THEN 'Namn'
        WHEN objekt::VARCHAR like '%FORNAMN_FRSPRAK-ORGNAM%' THEN 'ForetagsnamnFremmedspråk'
        WHEN objekt::VARCHAR like '%SARS_FORNAMN-ORGNAM%' THEN 'SærskiltForetagsnamn'
        END as objektType
FROM (
    SELECT
        LEFT(organisationsidentitet, instr(organisationsidentitet, '$') - 1) as organisationsidentitet,
        unnest(string_split(organisationsnamn, '|')) as objekt
    FROM
        bolagsverket
) w;

CREATE OR REPLACE TABLE organisationsnamn as 
SELECT
    organisationsidentitet,
    objektType, 
    MAX(CASE WHEN indeks = 1 THEN namnVerdi ELSE NULL END::VARCHAR) as Namn,
    MAX(CASE WHEN indeks = 2 THEN namnVerdi ELSE NULL END::VARCHAR) as Namn_type,
    MAX(CASE WHEN indeks = 3 THEN namnVerdi ELSE NULL END::DATE) as Namn_datum,
    MAX(CASE WHEN indeks = 4 THEN namnVerdi ELSE NULL END::VARCHAR) as Namn_Beskrivelse,
FROM 
    organisationsnamn_intermediate
GROUP BY
    organisationsidentitet,
    objektType;