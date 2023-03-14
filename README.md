# 5-line-trainer

A utility for aviator training on grid callouts and 5-line radio transmissions.

## Usage

_Requires Powershell 5.1._

Download or copy the .ps1 file and run it.

### Parameters

_If no parameters are provided, you'll be prompted for these values in the console._

- `-DigitPrecision` - The precision of grid coordinate to use. Defaults to `8`.
- `-WorldSize` - The size of the world you're practicing on in meters. Defaults to `30720`, to match Altis.
- `-SpeechRate` - The rate at which the speech synthesizer speaks. Defaults to `2`.

### Examples

```powershell
C:\> C:\Users\username\Downloads\GridCoordTraining.ps1
```

```powershell
C:\> C:\Users\username\Downloads\GridCoordTraining.ps1 -DigitPrecision 8 -WorldSize 30720 -SpeechRate 2
```

## Credits

Original idea by Kerwin of the 17th Arma 3 unit.
