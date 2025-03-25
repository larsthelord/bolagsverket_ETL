CREATE OR REPLACE TABLE bolagsverket as 
SELECT
    *
FROM
    read_csv('<<FILEPATH>>', sample_size = -1, delim='";"', skip = 1, columns = {
        'organisationsidentitet': 'VARCHAR',
        'namnskyddslopnummer': 'VARCHAR',
        'registreringsland': 'VARCHAR',
        'organisationsnamn': 'VARCHAR',
        'organisationsform': 'VARCHAR',
        'avregistreringsdatum': 'VARCHAR',
        'avregistreringsorsak': 'VARCHAR',
        'pagandeAvvecklingsEllerOmstruktureringsforfarande': 'VARCHAR',
        'registreringsdatum': 'VARCHAR',
        'verksamhetsbeskrivning': 'VARCHAR',
        'postadress': 'VARCHAR'
    })
;