#value to be replaced
$v1 = "0a4c4889-6df1-47af-a741-79a69602a755"
#new value
$v2 = "703d5567-c8a2-47b0-b98b-c425014f5ccd"
#repo location for search
$path = "C:\Source\Repos\procter-gamble\cloud-azure-pim"

Set-Location -Path $path -PassThru
$paths2 = Get-ChildItem -recurse | Select-String -pattern $v1 | Group-Object path | Select-Object Name


foreach ($path2 in $paths2) { 
    $path3 = $path2 | Select-Object -ExpandProperty Scope -first 1
    Get-Content $path3
    $content = Get-Content $path3
    $content | ForEach-Object {$_ -replace $v1, $v2} | Set-Content $path3
}

Set-Location -Path C:\Source\Repos\Kuba-scripts -PassThru