<#
.SYNOPSIS
    Yara Rule Generator v0.1 - Config Based Yara Rule Builder

.DESCRIPTION
    Yara-Rule-Generator uses a json configuration file to create a yara rule for a suspicious binary

.EXAMPLE
    PS> .\yrgenerator.ps1 -BinaryPath C:\Binaries\mal.exe -OutputFile C:\YaraRules\malrule.yara

.NOTES
    The configuration file has placeholder information but will need to be filled out as you require. An example config is provided.

.LINK
    https://github.com/d0nkeyk0ng787/Yara-Rule-Generator
#>

# Define mandatory parameters
param(
    [Parameter(Mandatory = $false)] $BinaryPath,
    [Parameter(Mandatory = $false)] $OutputFile
)

# Read in the config file
$configFile = Get-Content -Path ".\yrgconfig.json" -Raw
$config = ConvertFrom-Json -InputObject $configFile

# Getting values for the rule
$Date = Get-Date -UFormat "%d/%m/%Y"
$MD5 = (Get-FileHash $BinaryPath -Algorithm MD5).Hash
$SHA256 = (Get-FileHash $BinaryPath -Algorithm SHA256).Hash

# Write the rule
$yaraRule = @"
import `"hash`"

rule $($config.rulename)
{
    meta:
        Author = `"$($config.author)`"
        Date = `"$Date`"
        Version = `"1.0`"
        Description = `"$($config.description)`"
        MD5 = `"$MD5`"
        SHA256 = `"$SHA256`"
    strings:

"@

foreach($string in $config.strings){
    $yaraRule += "        `$$($string.name) = `"$($string.value)`""
    if($string.modifiers){
        $yaraRule += " $($string.modifiers)"
    }
    $yaraRule += "`n"
}

$yaraRule += @"
    condition:
        $($config.condition)
}
"@

Set-Content -Path $OutputFile -Value $yaraRule
