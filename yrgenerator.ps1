<#
.SYNOPSIS
    Yara Rule Generator v0.1 - Config Based Yara Rule Builder

.DESCRIPTION
    Yara-Rule-Generator uses a JSON configuration file and the output from floss to write YARA rules.

.EXAMPLE
    PS> .\yrgenerator.ps1 -BinaryPath C:\Binaries\mal.exe -OutputFile C:\YaraRules\malrule.yara -FlossOutput C:\FLoss\Flossoutput.txt

.NOTES
    You will need to install and run floss, save the output and feed it into the script. The configuration file has placeholder information but also will also need to be filled out.

.LINK
    https://github.com/d0nkeyk0ng787/Yara-Rule-Generator
#>

# Define mandatory parameters
param(
    [Parameter(Mandatory = $true)] $BinaryPath,
    [Parameter(Mandatory = $true)] $OutputFile,
    [Parameter(Mandatory = $true)] $FlossOutput
)

. .\getstrings.ps1

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

$strings = Get-Strings -InputFile $FlossOutput

foreach($key in $strings.Keys){
    $yaraRule += "        `$$($key) = `"$($strings[$key])`""
    if($key -like "*url*"){
        $yaraRule += " wide"
    }
    $yaraRule += "`n"
}

$yaraRule += @"
    condition:
        $($config.condition)
}
"@

Set-Content -Path $OutputFile -Value $yaraRule
