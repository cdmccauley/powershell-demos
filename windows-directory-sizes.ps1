# windows explorer can probably display sum of size of files in a folder
# but instead of figuring out how, i wasted time making powershell do it

$targetFolders = Get-ChildItem -Path "C:\Program Files (x86)\Steam\steamapps\common\" -ErrorAction SilentlyContinue
$csvStrings = New-Object -TypeName 'System.Collections.ArrayList'

foreach ($folder in $targetFolders) {
    $line = "{0},{1}" -f $folder, ((Get-ChildItem "C:\Program Files (x86)\Steam\steamapps\common\$folder" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1GB)
    $null = $csvStrings.Add($line)
}

$csvStrings = $csvStrings | Sort-Object -Descending { [double]$_.Split(",")[1] }

$tableObjects = New-Object -TypeName 'System.Collections.ArrayList'

foreach ($stringRep in $csvStrings) {
    $splitter = $stringRep.Split(",")
    $null = $tableObjects.Add([PSCustomObject]@{
        'Name' = $splitter[0]
        'Size(GB)' = [math]::Round([double]$splitter[1], 4)
    })
}

$tableObjects | Format-Table
