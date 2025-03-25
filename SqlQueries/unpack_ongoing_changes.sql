CREATE OR REPLACE TABLE pagandeAvvecklingsEllerOmstruktureringsforfarande as 
SELECT DISTINCT
    organisationsidentitet,
    LEFT(objekt, instr(objekt, '$') - 1) as pagandeAvvecklingsEllerOmstruktureringsforfarande_kode,
    CASE 
        WHEN RIGHT(b.objekt, LEN(b.objekt) - instr(b.objekt, '$')) = 'null' THEN NULL::DATE
        ELSE RIGHT(b.objekt, LEN(b.objekt) - instr(b.objekt, '$'))::DATE
        END  as pagandeAvvecklingsEllerOmstruktureringsforfarande_datum
FROM (
    SELECT
        LEFT(organisationsidentitet, instr(organisationsidentitet, '$') - 1) as organisationsidentitet,
        unnest(string_split(pagandeAvvecklingsEllerOmstruktureringsforfarande, '|')) as objekt
    FROM
        bolagsverket
) b
WHERE
    TRIM(b.objekt::VARCHAR) <> '';