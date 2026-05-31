# ============================================================
# Swift Stride DBC Patcher
# Injects spell IDs 62010-62021 into client + server Spell.dbc
# Uses Sprint (ID 2983) as the binary template record.
# ============================================================

$clientDBC = "C:\TurtleWoW\client\dbc\Spell.dbc"
$serverDBC  = "C:\TurtleWoW\server\data\dbc\Spell.dbc"

function Patch-SpellDBC {
    param([string]$Path)

    Write-Host ""
    Write-Host "=== Patching: $Path ==="

    if (-not (Test-Path $Path)) {
        Write-Error "  File not found: $Path"
        return $false
    }

    $bytes = [System.IO.File]::ReadAllBytes($Path)

    # ---- Parse header (20 bytes) ----
    $magic         = [System.Text.Encoding]::ASCII.GetString($bytes, 0, 4)
    $recordCount   = [BitConverter]::ToInt32($bytes, 4)
    $fieldCount    = [BitConverter]::ToInt32($bytes, 8)
    $recordSize    = [BitConverter]::ToInt32($bytes, 12)
    $stringBlockSz = [BitConverter]::ToInt32($bytes, 16)

    if ($magic -ne "WDBC") {
        Write-Error "  Not a valid DBC (magic='$magic')"
        return $false
    }

    Write-Host ("  Header: records=$recordCount  fields=$fieldCount  " +
                "recSize=$recordSize  strBlock=$stringBlockSz")

    # ---- Guard: already patched? ----
    $headerSize = 20
    for ($i = 0; $i -lt $recordCount; $i++) {
        $off = $headerSize + ($i * $recordSize)
        if ([BitConverter]::ToInt32($bytes, $off) -eq 62010) {
            Write-Host "  SKIP - ID 62010 already exists in this file."
            return $true
        }
    }

    # ---- Find Sprint (ID 2983) ----
    $sprintOff = $null
    for ($i = 0; $i -lt $recordCount; $i++) {
        $off = $headerSize + ($i * $recordSize)
        if ([BitConverter]::ToInt32($bytes, $off) -eq 2983) {
            $sprintOff = $off
            Write-Host "  Sprint found at record index $i  (file offset $off)"
            break
        }
    }

    if ($null -eq $sprintOff) {
        Write-Error "  Sprint (ID 2983) not found - cannot continue."
        return $false
    }

    # Extract template bytes
    $tpl = New-Object byte[] $recordSize
    [Array]::Copy($bytes, $sprintOff, $tpl, 0, $recordSize)

    Write-Host ("  Sprint template key fields:" +
        "  cooldown(f20@80)={0}" +
        "  duration(f30@120)={1}" +
        "  basePoints(f76@304)={2}" +
        "  aura(f91@364)={3}" -f
        [BitConverter]::ToInt32($tpl,  80),
        [BitConverter]::ToInt32($tpl, 120),
        [BitConverter]::ToInt32($tpl, 304),
        [BitConverter]::ToInt32($tpl, 364))

    # ---- Build new strings ----
    $enc    = [System.Text.Encoding]::UTF8
    $newStr = New-Object System.Collections.Generic.List[byte]

    # "Swift Stride\0"  ->  offset = current string block size
    $ssOff   = $stringBlockSz
    $enc.GetBytes("Swift Stride") | ForEach-Object { $newStr.Add($_) }
    $newStr.Add(0)

    # "Rank 1\0" ... "Rank 12\0"
    $rankNames   = "Rank 1","Rank 2","Rank 3","Rank 4","Rank 5","Rank 6",
                   "Rank 7","Rank 8","Rank 9","Rank 10","Rank 11","Rank 12"
    $rankOffsets = @()
    foreach ($rn in $rankNames) {
        $rankOffsets += ($stringBlockSz + $newStr.Count)
        $enc.GetBytes($rn) | ForEach-Object { $newStr.Add($_) }
        $newStr.Add(0)
    }

    $newStrArr = $newStr.ToArray()
    Write-Host ("  String additions: {0} bytes  ssOff={1}  rankOffsets={2}" -f
        $newStrArr.Length, $ssOff, ($rankOffsets -join ","))

    # ---- Build 12 new spell records ----
    $spellIDs   = 62010..62021
    $basePoints = 4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59

    $newRecs = New-Object System.Collections.Generic.List[byte]

    for ($r = 0; $r -lt 12; $r++) {
        # Start with Sprint copy
        $rec = New-Object byte[] $recordSize
        [Array]::Copy($tpl, $rec, $recordSize)

        # field[0]  @   0 : Spell ID
        [Array]::Copy([BitConverter]::GetBytes([int32]($spellIDs[$r])), 0, $rec,   0, 4)

        # field[20] @  80 : RecoveryTime (cooldown ms) = 0
        [Array]::Copy([BitConverter]::GetBytes([int32]0),               0, $rec,  80, 4)

        # field[21] @  84 : CategoryRecoveryTime = 0
        [Array]::Copy([BitConverter]::GetBytes([int32]0),               0, $rec,  84, 4)

        # field[30] @ 120 : DurationIndex = 21 (permanent)
        [Array]::Copy([BitConverter]::GetBytes([int32]21),              0, $rec, 120, 4)

        # field[76] @ 304 : EffectBasePoints1 (desired_pct - 1)
        [Array]::Copy([BitConverter]::GetBytes([int32]($basePoints[$r])),0, $rec, 304, 4)

        # field[91] @ 364 : EffectApplyAuraName1 = 31 (MOD_INCREASE_SPEED)
        [Array]::Copy([BitConverter]::GetBytes([int32]31),              0, $rec, 364, 4)

        # Zero all SpellName string offsets (fields 120-127, bytes 480-511)
        for ($i = 480; $i -lt 512; $i++) { $rec[$i] = 0 }
        # field[128] @ 512 : SpellNameFlags - keep Sprint's value (locale mask)

        # Zero all SpellRank string offsets (fields 129-136, bytes 516-547)
        for ($i = 516; $i -lt 548; $i++) { $rec[$i] = 0 }
        # field[137] @ 548 : SpellRankFlags - keep Sprint's value

        # Zero all SpellDesc string offsets (fields 138-145, bytes 552-583)
        for ($i = 552; $i -lt 584; $i++) { $rec[$i] = 0 }
        # field[146] @ 584 : SpellDescFlags - keep Sprint's value

        # Zero all SpellToolTip string offsets (fields 147-154, bytes 588-619)
        for ($i = 588; $i -lt 620; $i++) { $rec[$i] = 0 }
        # field[155] @ 620 : SpellToolTipFlags - keep Sprint's value

        # field[120] @ 480 : SpellName0 (English) = "Swift Stride"
        [Array]::Copy([BitConverter]::GetBytes([int32]$ssOff),          0, $rec, 480, 4)

        # field[129] @ 516 : SpellRank0 (English) = "Rank N"
        [Array]::Copy([BitConverter]::GetBytes([int32]($rankOffsets[$r])),0,$rec,516, 4)

        $rec | ForEach-Object { $newRecs.Add($_) }
    }

    $newRecArr = $newRecs.ToArray()

    # ---- Assemble patched file ----
    # Layout: [Header(20)] [OldRecords] [NewRecords(12)] [OldStringBlock] [NewStrings]

    $newRecordCount = $recordCount + 12
    $newStrBlkSz    = $stringBlockSz + $newStrArr.Length
    $newTotalSize   = 20 + ($newRecordCount * $recordSize) + $newStrBlkSz

    $out = New-Object byte[] $newTotalSize

    # Copy header, then patch record_count and string_block_size
    [Array]::Copy($bytes, 0, $out, 0, 20)
    [Array]::Copy([BitConverter]::GetBytes([int32]$newRecordCount), 0, $out,  4, 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]$newStrBlkSz),   0, $out, 16, 4)

    # Old records (unchanged)
    [Array]::Copy($bytes, 20, $out, 20, $recordCount * $recordSize)

    # New records appended after old records
    $newRecStart = 20 + ($recordCount * $recordSize)
    [Array]::Copy($newRecArr, 0, $out, $newRecStart, $newRecArr.Length)

    # Old string block repositioned
    $oldStrSrcOff = 20 + ($recordCount * $recordSize)       # where it was in original file
    $newStrDstOff = 20 + ($newRecordCount * $recordSize)    # where it goes in new file
    [Array]::Copy($bytes, $oldStrSrcOff, $out, $newStrDstOff, $stringBlockSz)

    # New strings appended after old string block
    [Array]::Copy($newStrArr, 0, $out, $newStrDstOff + $stringBlockSz, $newStrArr.Length)

    # ---- Backup original ----
    $bak = $Path + ".bak"
    if (-not (Test-Path $bak)) {
        [System.IO.File]::WriteAllBytes($bak, $bytes)
        Write-Host "  Backup -> $bak"
    } else {
        Write-Host "  Backup already exists, skipping."
    }

    # ---- Write patched file ----
    [System.IO.File]::WriteAllBytes($Path, $out)
    Write-Host ("  Written: {0}  ({1} bytes total, {2} records, strBlock={3})" -f
        $Path, $out.Length, $newRecordCount, $newStrBlkSz)

    # ---- Quick sanity check: re-read and find ID 62010 ----
    $verify = [System.IO.File]::ReadAllBytes($Path)
    $vCount  = [BitConverter]::ToInt32($verify, 4)
    $found   = $false
    for ($i = 0; $i -lt $vCount; $i++) {
        $off = 20 + ($i * $recordSize)
        if ([BitConverter]::ToInt32($verify, $off) -eq 62010) {
            $found = $true
            $bp   = [BitConverter]::ToInt32($verify, $off + 304)
            $dur  = [BitConverter]::ToInt32($verify, $off + 120)
            $aura = [BitConverter]::ToInt32($verify, $off + 364)
            Write-Host ("  VERIFY OK: ID 62010 at record {0}  basePoints={1}  duration={2}  aura={3}" -f
                $i, $bp, $dur, $aura)
            break
        }
    }
    if (-not $found) { Write-Error "  VERIFY FAILED: ID 62010 not found in patched file!" }

    return $found
}

# ---- Run patches ----
$ok1 = Patch-SpellDBC -Path $clientDBC
$ok2 = Patch-SpellDBC -Path $serverDBC

if (-not ($ok1 -and $ok2)) {
    Write-Host ""
    Write-Error "One or more patches failed. Do NOT restart until errors are resolved."
    exit 1
}

Write-Host ""
Write-Host "Both DBC files patched. Restarting mangosd..."

# Kill existing mangosd
$proc = Get-Process -Name "mangosd" -ErrorAction SilentlyContinue
if ($proc) {
    $proc | Stop-Process -Force
    Write-Host "mangosd stopped."
    Start-Sleep -Seconds 4
} else {
    Write-Host "mangosd was not running."
}

# Start mangosd
$mangosExe = "C:\TurtleWoW\server\bin\mangosd.exe"
if (Test-Path $mangosExe) {
    Start-Process -FilePath $mangosExe `
                  -WorkingDirectory "C:\TurtleWoW\server\bin" `
                  -WindowStyle Normal
    Write-Host "mangosd started."
} else {
    Write-Error "mangosd.exe not found at $mangosExe"
}

Write-Host ""
Write-Host "Done. Wait ~20 seconds for the world server to finish loading,"
Write-Host "then log in and visit The Wandering Ancestor."
Write-Host "Open the trainer window - Swift Stride Rank 1-12 should appear."
