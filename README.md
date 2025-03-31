# Bolagsverket

## English
Download and ETL-process of data-files from Bolagsverket in Sweden using DuckDB and powershell.
I did this because the structure of the downloadable files is horible.

There are two PowerShell-scripts downloading the Bolagsverket-file and SCB-file (Swedish Statistics Office) and then using duckdb to perform a transformation.

There are three final outputs for bolagsverket: 

- final_bolagsverket:
    - Main file containing one line for every Organization. OrganizationIdentity is the primary key
- final_ongoing_changes:
    - All ongoing changes for organizations. Multiple changes may be ongoing for one organization. Connected by OrganizationIdentity
- final_organization_name:
    - An organization might have multiple names and name types. These are connected by OrganizationIdentiy

And one final output for SCB:

- final_scb:
    - Main file containing one line for every Person/Organization from Swedish Statistics Office PersonOrganizationNumber is the primary key

## Norsk
Nedlasting og ETL-prosess av data-filene tilgjengelig fra Bolagsverket i Sverige ved hjelp av DuckDB og PowerShell
Jeg legger ut dette fordi strukturen på filene til Bolagsverket er horribel

Det er to PowerShell-skript som laster ned eksportfilen fra Bolagsverket og SCB, og deretter transformerer dette til en god struktur for lagring i database

Det er tre endelige tabeller for Bolagsverket:

- final_bolagsverket:
    - Hoved-tabellen som inneholder en linje for hver organisasjon. OrganizationIdentity er primærnøkkelen.
- final_ongoing_changes:
    - Alle pågående endringer for organisasjoner. Flere endringer kan være pågående for en organisasjon. Disse er koblet mot organisasjon med OrganizationIdentity
- final_organization_name:
    - En organisasjon kan ha flere navn og navnetyper. Koblet mot organisasjon med OrganizationIdentity

Og en endelig tabell for SCB:

- final_scb:
    - Hovedfil som inneholder en linjer per person/organisasjon fra Statistikmyndigheten SCB. PersonOrganizationNumber er primærnøkkelen.


# Links to DuckDB
This project uses [DuckDB](https://duckdb.org/) and [DuckDb.net](https://duckdb.net/).
The .dll-files included in this project is of version 1.2.1