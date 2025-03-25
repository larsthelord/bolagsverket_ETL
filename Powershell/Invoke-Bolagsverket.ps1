$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = "stop"
$Uri = "https://vardefulla-datamangder.bolagsverket.se/bolagsverket/bolagsverket_bulkfil.zip"
$TempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "bolagsverket_bulkfil.zip")

#Use temp for zipped file
Invoke-WebRequest -Uri $Uri -UseBasicParsing -Method GET -OutFile $TempFile

#Extract to current folder
[System.IO.Compression.ZipFile]::ExtractToDirectory($TempFile, ".") 
Remove-Item $TempFile -Force

$Bolagsverket = Get-Item -Path ".\bolagsverket_bulkfil.txt"


Add-Type -Path ".\Powershell\duckdb\DuckDB.NET.Data.dll"
Add-Type -Path ".\Powershell\duckdb\DuckDB.NET.Bindings.dll"

$DuckDbConnection = [DuckDB.NET.Data.DuckDBConnection]::new("DataSource = :memory:")
$DuckDbConnection.Open()
$DuckdbCommand = $DuckDbConnection.CreateCommand()
$DuckdbCommand.CommandTimeout = 0


#Load Initial data
$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\read_bolagsverket.sql").Replace("<<FILEPATH>>", $Bolagsverket.FullName)
$null = $DuckdbCommand.ExecuteNonQuery()

#Run intemediate steps
$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\unpack_organization_name.sql")
$null = $DuckdbCommand.ExecuteNonQuery()
$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\unpack_ongoing_changes.sql")
$null = $DuckdbCommand.ExecuteNonQuery()
$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\unpack_postal_address.sql")
$null = $DuckdbCommand.ExecuteNonQuery()

$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\final_bolagsverket.sql")
$Reader = $DuckdbCommand.ExecuteReader()

#Do What you want with the result. For example write to datatable:
$Datatable = [System.Data.DataTable]::new()
$Datatable.Load($Reader)


#Cleanup and remove files
Remove-Item -Path $Bolagsverket.FullName -Force