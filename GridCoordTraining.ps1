[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [UInt16] $WorldSize = 30720,
    [Parameter(Mandatory = $false)]
    [UInt16] $digitPrecision = 8,
    [Parameter(Mandatory = $false)]
    [Float] $SpeechRate = 2
)

Add-Type -AssemblyName PresentationFramework;
Add-Type -AssemblyName System.Speech;
$Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer

$host.ui.RawUI.WindowTitle = "Grid Coordinate Training"

# prompt for worldsize and precision
$worldsize = Read-Host "What is the world size im km^2? (30720)"
if ($worldsize -eq '') { $worldsize = 30720 } else {
    $worldsize = [UInt16] $worldsize
}

if (-not $PSBoundParameters.ContainsKey('Precision')) {
    [UInt16] $digitPrecision = Read-Host "How many digits of precision? (6, 8, or 10)"
    if ($digitPrecision -eq '') { $digitPrecision = 8 }
}
if (-not ($digitPrecision % 2 -eq 0)) {
    $digitPrecision = 8
    Write-Warning "Precision must be an even number. Setting digit precision to $digitPrecision."
}
if ($digitPrecision -notin @(6, 8, 10)) {
    $digitPrecision = 8
    Write-Warning "Precision must be 6, 8, or 10. Setting digit precision to $digitPrecision."
}

if (-not $PSBoundParameters.ContainsKey('SpeechRate')) {
    [Float] $SpeechRate = Read-Host "How quickly do you want it spoken? (2)"
    if ($SpeechRate -eq '') { $SpeechRate = 2 }
}
$Speech.Rate = $SpeechRate


$segment, $segmentStr, $x, $y, $xArr, $yArr, $input = $null
function Format-GridCoord ([UInt16] $segment) {

    [Int] $segmentPrecision = [Math]::Floor($digitPrecision / 2)


    [String] $segmentStr = $segment.ToString()

    switch ($true) {
        ($segmentStr.Length -lt $segmentPrecision) {
            $extraLength = $segmentPrecision - $segmentStr.Length
            Write-Debug (
                "Segment is $extraLength digit short of precision.`nORIG: {0}`nPADDED: {1}" -f (
                    $segmentStr,
                    $segmentStr.PadLeft($segmentPrecision, '0')
                )
            )
            $segmentStr = $segmentStr.PadLeft($segmentPrecision, '0')
            break
        }
        ($segmentStr.Length -eq $segmentPrecision) {
            Write-Debug (
                "Segment is equal to precision.`nORIG: {0}" -f (
                    $segmentStr

                )
            )
            break
        }
        ($segmentStr.Length -gt $segmentPrecision) {
            $extraLength = $segmentStr.Length - $segmentPrecision

            $segmentStrNew = $segmentStr
            $segmentNew = $segment
            while ($segmentStrNew.Length -gt $segmentPrecision) {
                $segmentNew = [Math]::floor($segmentNew / 10)
                $segmentStrNew = $segmentNew.ToString()
            }

            Write-Debug (
                "Segment is $extraLength longer than precision.`nORIG: {0}`nDIVIDED: {1}" -f (
                    $segmentStr,
                    $segmentStrNew
                )
            )

            $segmentStr = $segmentStrNew

            break
        }
    }

    # return array
    $segmentArr = $segmentStr.ToCharArray()
    return $segmentArr
}


for ($input = 'no'; !($input -eq 'cancel'); ) {
    if ($input -eq 'no') {
        $x = Get-Random -Minimum 0 -Maximum $worldsize
        $xArr = Format-GridCoord $x
        $y = Get-Random -Minimum 0 -Maximum $worldsize
        $yArr = Format-GridCoord $y
    }

    Write-Debug "$($digitPrecision) digit grid reference is: $($xArr -join ', '). break. $($yArr -join ', ')" | Out-Host

    $Speech.Speak("$($digitPrecision) digit grid reference is: $($xArr -join ', '), break. $($yArr -join ', ')");

    $input = [System.Windows.MessageBox]::Show('How copy? Should I say again?', '8 Digit Grid Coordinate Practice', [System.Windows.MessageBoxButton]::YesNoCancel)
}