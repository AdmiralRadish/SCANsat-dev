$ErrorActionPreference='Continue'
$srcCandidates=@(
  'C:\KSP\LMP_RSS_ServerNotes\SCANsat-dev\SCANsat\bin\Release\net48',
  'C:\KSP\LMP_RSS_ServerNotes\SCANsat-dev\SCANsat\bin\Release\net4.8'
)
$srcDir=$srcCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if(-not $srcDir){ Write-Output 'Source release folder not found (net48/net4.8).'; exit 1 }
$dllNames=@('SCANsat.dll','SCANsat.Unity.dll')
$sources=foreach($n in $dllNames){ $p=Join-Path $srcDir $n; if(Test-Path $p){ Get-Item $p } }
if(-not $sources){ Write-Output "No source DLLs found in $srcDir"; exit 1 }
$destinations=@(
  [pscustomobject]@{Name='A LiveKSP'; Path='G:\Steam\steamapps\common\Kerbal Space Program\GameData\SCANsat\Plugins'},
  [pscustomobject]@{Name='B SourceGameData'; Path='C:\KSP\LMP_RSS_ServerNotes\SCANsat-dev\GameData\SCANsat\Plugins'},
  [pscustomobject]@{Name='C MostRecentBuild'; Path='C:\KSP\LMP_RSS_ServerNotes\MOST RECENT BUILD\SCANsat\Plugins'},
  [pscustomobject]@{Name='D Mainserver'; Path='\\mainserver\c\Program Files (x86)\Steam\steamapps\common\Kerbal Space Program Realtime\GameData\SCANsat\Plugins'}
)
$results=foreach($src in $sources){
  $srcHash=(Get-FileHash $src.FullName -Algorithm MD5).Hash
  foreach($dest in $destinations){
    $destFile=Join-Path $dest.Path $src.Name
    $copy='PASS'; $hash='FAIL'; $note=''
    try{
      if(-not (Test-Path $dest.Path)){ New-Item -ItemType Directory -Path $dest.Path -Force | Out-Null }
      Copy-Item $src.FullName $destFile -Force -ErrorAction Stop
    }catch{
      $copy='FAIL'; $note=$_.Exception.Message
      if($dest.Name -eq 'D Mainserver' -and $note -match 'used by another process|being used|cannot access the file'){ $note="LOCKED: $note" }
    }
    if($copy -eq 'PASS'){
      try{
        $dstHash=(Get-FileHash $destFile -Algorithm MD5).Hash
        if($dstHash -eq $srcHash){ $hash='PASS' } else { $hash='FAIL'; $note="Hash mismatch src=$srcHash dst=$dstHash" }
      }catch{ $hash='FAIL'; $note="Hash error: $($_.Exception.Message)" }
    }
    [pscustomobject]@{File=$src.Name;Destination=$dest.Name;Copy=$copy;Hash=$hash;Result=$(if($copy -eq 'PASS' -and $hash -eq 'PASS'){'PASS'}else{'FAIL'});Note=$note}
  }
}
"SourceDir=$srcDir"
$results | Format-Table -AutoSize
