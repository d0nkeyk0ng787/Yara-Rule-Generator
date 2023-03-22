# Yara-Rule-Generator

### Description
A powershell script that uses a JSON configuration file to write YARA rules.

### Usage

This script only works on Windows. It can be run like so:
```posh
.\yrgenerator.ps1 -BinaryPath C:\Binaries\mal.exe -OutputFile C:\YaraRules\malrule.yara
```

### JSON Setup

The following is an example JSON configuration setup.
```json
{
    "rulename" : "mal",
    "author": "D0nkeyk0ng787",
    "description": "Yara rule for mal.exe",
    "strings": [
        {"name": "malware_string", "value": "malware", "modifiers": "nocase"},
        {"name": "suspicious_string", "value": "suspicious", "modifiers": "wide"},
        {"name": "exploit_string", "value": "exploit", "modifiers": "ascii"}
    ],
    "condition": "all of them"
}
```
