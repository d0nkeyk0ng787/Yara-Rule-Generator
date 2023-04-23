# Yara-Rule-Generator

### Description
![GitHub](https://camo.githubusercontent.com/3dbcfa4997505c80ef928681b291d33ecfac2dabf563eb742bb3e269a5af909c/68747470733a2f2f696d672e736869656c64732e696f2f6769746875622f6c6963656e73652f496c65726961796f2f6d61726b646f776e2d6261646765733f7374796c653d666f722d7468652d6261646765) ![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)

A powershell script that uses a JSON configuration file and the output from floss to write YARA rules.

### Usage

Before running the script, you need to download floss and run it against the binary ensuring you save the output. You can download floss [here](https://github.com/mandiant/flare-floss/releases/tag/v2.2.0)

Run floss like so:
```posh
.\floss.exe C:\Binaries\mal.exe -o C:\Floss\Flossoutput.txt
```

Once you have you floss output, you can run the script like so:
```posh
.\yrgenerator.ps1 -BinaryPath C:\Binaries\mal.exe -OutputFile C:\YaraRules\malrule.yara -FlossOutput C:\FLoss\Flossoutput.txt
```

### JSON Setup

The following is an example JSON configuration setup.
```json
{
    "rulename" : "mal",
    "author": "D0nkeyk0ng787",
    "description": "Yara rule for mal.exe",
    "condition": "all of them"
}
```

