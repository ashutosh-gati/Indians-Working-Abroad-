$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$wb = $excel.Workbooks.Open((Resolve-Path 'clean_combined.xlsx').Path)

# Only read sheet 3 (Healthcare)
$sheet = $wb.Sheets.Item(3)
Write-Host "=== $($sheet.Name) ==="
$usedRange = $sheet.UsedRange
$rowCount = $usedRange.Rows.Count
$colCount = $usedRange.Columns.Count
Write-Host "Rows: $rowCount, Cols: $colCount"

for($r = 1; $r -le [Math]::Min($rowCount, 50); $r++) {
    $vals = @()
    for($c = 1; $c -le $colCount; $c++) {
        $vals += $usedRange.Cells.Item($r, $c).Text
    }
    Write-Host ($vals -join ' | ')
}

$wb.Close($false)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
