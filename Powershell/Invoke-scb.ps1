$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = "stop"

$Uri = "https://vardefulla-datamangder.bolagsverket.se/bolagsverket/bolagsverket_bulkfil.zip"

$Uri = "https://vardefulla-datamangder.bolagsverket.se/scb/scb_bulkfil.zip"
$TempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "scb_bulkfil.zip")

#Use temp for zipped file
Invoke-WebRequest -Uri $Uri -UseBasicParsing -Method GET -OutFile $TempFile

#Extract to current folder
[System.IO.Compression.ZipFile]::ExtractToDirectory($TempFile, ".") 
Remove-Item $TempFile -Force

$ScbFile = Get-Item -Path ".\scb_bulkfil*.txt"

#Convert from Windows 1252 to UTF8 to be able to use DuckDB:
try{
    $Reader = [System.IO.StreamReader]::new($ScbFile.FullName, [System.Text.Encoding]::GetEncoding(1252))
    $Writer = [System.IO.StreamWriter]::new(".\scb_bulkfil.tsv")

    $SourceEncoding = [System.Text.Encoding]::GetEncoding(1252)
    $DestinationEncoding = [System.Text.Encoding]::UTF8
    while(-not $Reader.EndOfStream){
        $ReadLine = [System.Text.Encoding]::GetEncoding(1252).GetBytes($Reader.ReadLine())
        $WriteLine = [System.Text.Encoding]::UTF8.GetString(
            [System.Text.Encoding]::Convert(
                $SourceEncoding,
                $DestinationEncoding,
                $ReadLine
            )
        )
        $Writer.WriteLine($WriteLine)
    }

} finally{
    $Writer.Dispose()
    $Reader.Dispose()
}

Remove-Item $ScbFile.FullName

Add-Type -Path ".\Powershell\duckdb\DuckDB.NET.Data.dll"
Add-Type -Path ".\Powershell\duckdb\DuckDB.NET.Bindings.dll"

$DuckDbConnection = [DuckDB.NET.Data.DuckDBConnection]::new("DataSource = :memory:")
$DuckDbConnection.Open()
$DuckdbCommand = $DuckDbConnection.CreateCommand()
$DuckdbCommand.CommandTimeout = 0

$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\read_scb.sql").Replace("<<FILEPATH>>", ".\scb_bulkfil.tsv")
$null = $DuckdbCommand.ExecuteNonQuery()

$DuckdbCommand.CommandText = (Get-Content ".\SqlQueries\final_scb.sql")
$Reader = $DuckdbCommand.ExecuteReader()
$Datatable = [System.Data.DataTable]::new()
$Datatable.Load($Reader)
