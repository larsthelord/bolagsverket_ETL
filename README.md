# Bolagsverket
Download and transform of data-files from Bolagsverket in Sweden using DuckDB and powershell.
I did this because the structure of the downloadable files is horible.

There are two PowerShell-scripts downloading the Bolagsverket-file and SCB-file and then using duckdb to perform a transformation.

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


# Links to DuckDB
This project uses [DuckDB](https://duckdb.org/) and [DuckDb.net](https://duckdb.net/).
The .dll-files included in this project is of version 1.2.1