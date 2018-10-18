<#
.SYNOPSIS
Produces a multi-tab Excel workbook containing summary and details of AppLocker events to support advanced analysis.

.DESCRIPTION
Converts the saved output from the Get-AppLockerEvents.ps1 or Save-WEFEvents.ps1 scripts to a multi-tab Excel workbook supporting numerous views of the data, including:
* Summary tab showing date/time ranges of the reported events and other summary information.
* List of machines reporting events, and the number of events per machine.
* List of publishers of signed files appearing in events, and the number of events per publisher.
* All combinations of publishers/products for signed files in events.
* All combinations of publishers/products and generic file paths ("generic" meaning that user-specific paths are replaced with %LOCALAPPDATA%, %USERPROFILE%, etc., as appropriate)
* All combinations of publishers/products and generic directory names (paths minus file names)
* Paths of unsigned files, with filename alone, file type, and file hash
* Directory locations (without file names) of unsigned files
* Full details from Get-AppLockerEvents.ps1.
These separate tabs enable quick determination of the files running afoul of AppLocker rules and help quickly determine whether/how to adjust the rules.

.PARAMETER AppLockerEventsCsvFile
Path to CSV file produced by Get-AppLockerEvents.ps1 or Save-WEFEvents.ps1, ideally without any attributes removed, but must contain at least these: MachineName, PublisherName, ProductName, GenericPath, GenericDir, FileName, FileType, Hash

.PARAMETER SaveWorkbook
If set, saves workbook to same directory as input file with same file name and default Excel file extension.
#>


param(
    # Path to CSV file produced by Get-AppLockerEvents.ps1
    [parameter(Mandatory=$true)]
    [String]
    $AppLockerEventsCsvFile, 

    [switch]
    $SaveWorkbook
)

if (!(Test-Path($AppLockerEventsCsvFile)))
{
    Write-Warning "File not found: $AppLockerEventsCsvFile"
    return
}

$rootDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
# Get configuration settings and global functions from .\Support\Config.ps1)
# Dot-source the config file. Contains Excel-generation scripts.
. $rootDir\Support\Config.ps1

$OutputEncodingPrevious = $OutputEncoding
$OutputEncoding = [System.Text.ASCIIEncoding]::Unicode

# String constant
$sFiltered = "FILTERED"

if (CreateExcelApplication)
{
    Write-Host "Reading data from $AppLockerEventsCsvFile" -ForegroundColor Cyan
    $csvFull = Get-Content $AppLockerEventsCsvFile
    $dataUnfiltered = ($csvFull | ConvertFrom-Csv -Delimiter "`t")
    $dataFiltered = $dataUnfiltered | Where-Object { $_.EventType -ne $sFiltered }
    #Write-Host ("dataUnfiltered.Count = " + $dataUnfiltered.Count) -ForegroundColor Yellow
    #Write-Host ("data.Count = " + $dataFiltered.Count) -ForegroundColor Yellow

    # Lines of text for the summary page
    $text = @()
    $dtsort = ($dataFiltered.EventTime | Sort-Object); 
    $text += "Summary information"
    $text += ""
    $text += "Data source: " + [System.IO.Path]::GetFileName($AppLockerEventsCsvFile)
    $text += "First event: " + ([datetime]($dtsort | Select-Object -First 1)).ToString()
    $text += "Last event: " + ([datetime]($dtsort | Select-Object -Last 1)).ToString()
    $text += "Number of events: " + $dataFiltered.Count.ToString()
    #Write-Host ("data | Select-Object MachineName -Unique: " + ($dataFiltered | Select-Object MachineName -Unique) ) -ForegroundColor Yellow
    # Make sure the result of the pipe is an array, even if only one item.
    $text += "Number of machines reporting events: " + ( @() + ($dataUnfiltered | Select-Object MachineName -Unique)).Count.ToString()
    AddWorksheetFromText -text $text -tabname "Summary"

    # Events per machine:
    $csv = ($dataFiltered | Select-Object MachineName | Group-Object MachineName | Select-Object Name, Count | Sort-Object Name | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    $csv += ($dataUnfiltered | Where-Object { $_.EventType -eq $sFiltered } | ForEach-Object { $_.MachineName + "`t0" })
    AddWorksheetFromCsvData -csv $csv -tabname "Machines and event counts" -CrLfEncoded ""

    # Counts of each publisher:
    $csv = ($dataFiltered | Select-Object PublisherName | Group-Object PublisherName | Select-Object Name, Count | Sort-Object Name | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    AddWorksheetFromCsvData -csv $csv -tabname "Publishers and event counts"

    # Publisher/product combinations:
    $csv = ($dataFiltered | Where-Object { $_.PublisherName -ne "-" } | Select-Object PublisherName, ProductName -Unique | Sort-Object PublisherName, ProductName | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    AddWorksheetFromCsvData -csv $csv -tabname "Publisher-product combinations"

    # Publisher/product/file combinations:
    $csv = ($dataFiltered | Where-Object { $_.PublisherName -ne "-" } | Select-Object PublisherName, ProductName, GenericPath, FileName, FileType -Unique | Sort-Object PublisherName, ProductName, GenericPath | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    AddWorksheetFromCsvData -csv $csv -tabname "Signed file info"

    # Publisher/product/directory combinations:
    $csv = ($dataFiltered | Where-Object { $_.PublisherName -ne "-" } | Select-Object PublisherName, ProductName, GenericDir, FileType -Unique | Sort-Object PublisherName, ProductName, GenericDir | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    AddWorksheetFromCsvData -csv $csv -tabname "Signed file info (dir only)"

    # Analysis of unsigned files:
    $csv = ($dataFiltered | Where-Object { $_.PublisherName -eq "-" } | Select-Object GenericPath, FileName, FileType, Hash -Unique | Sort-Object GenericPath | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    AddWorksheetFromCsvData -csv $csv -tabname "Unsigned file info"

    # Analysis of unsigned files (dir only):
    $csv = ($dataFiltered | Where-Object { $_.PublisherName -eq "-" } | Select-Object GenericDir -Unique | Sort-Object GenericDir | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation)
    AddWorksheetFromCsvData -csv $csv -tabname "Dirs of unsigned files"

    # All event data
    AddWorksheetFromCsvData -csv $csvFull -tabname "Full details"

    SelectFirstWorksheet

    if ($SaveWorkbook)
    {
        $xlFname = [System.IO.Path]::ChangeExtension($AppLockerEventsCsvFile, ".xlsx")
        # Ensure absolute path
        if (!([System.IO.Path]::IsPathRooted($xlFname)))
        {
            $xlFname = [System.IO.Path]::Combine((Get-Location).Path, $xlFname)
        }
        SaveWorkbook -filename $xlFname
    }

    ReleaseExcelApplication
}

$OutputEncoding = $OutputEncodingPrevious


