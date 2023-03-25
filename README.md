# Yara-Rule-Generator

### Description
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

### TODO

* [ ]  Have the script download floss, run it against the binary and save the output to be turned into strings for the rule
