function Get-Strings{
    param(
        [Parameter(Mandatory = $true)] $InputFile
        )


    $urlRegex = '^(?:https://|http://)(?:www\.)?[\w\-.]+(?:\.[a-z]{2,})(?:[/\w\-.]*)*(?:\?(?:[\w\-%]+=[\w\-%]+&?)*)?(?:#[\w\-]*)?$'
    $hashRegex = '\b[a-fA-F0-9]{32}\b|\b[a-fA-F0-9]{40}\b|\b[a-fA-F0-9]{64}\b'
    $pathRegex = '^[a-zA-Z]:\\(?:[^\\/:*?"<>|\r\n]+\\)*[^\\/:*?"<>|\r\n]*$'
    $ipRegex = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

    $strings = Get-Content -Path $InputFile
    $outputStrings = @{}

    # Gather strings and put them in a hash table
    foreach($string in $strings){
        if($string -match $urlRegex){
            $randomNumber = Get-Random -Minimum 1 -Maximum 999
            $outputStrings.Add("url$randomNumber", $string)
        }
        elseif($string -match $hashRegex){
            $randomNumber = Get-Random -Minimum 1 -Maximum 999
            $result = Hash-Validator -Hash $string
            $key = $result[0]
            $hash = $result[1]
            if($result){
                $outputStrings.Add("$key$randomNumber", $hash)
            }  
        }
        elseif($string -match $pathRegex){
            $randomNumber = Get-Random -Minimum 1 -Maximum 999
            $updatedString = ""
            foreach($char in $string.ToCharArray()) {
                $updatedString += $char
                if($char -eq '\'){
                    $updatedString += $char
                }
            }
            $outputStrings.Add("path$randomNumber", $updatedString)
        }
        elseif($string -match $ipRegex){
            $randomNumber = Get-Random -Minimum 1 -Maximum 999
            $outputStrings.Add("ip$randomNumber", $string)
        }
    }
    
    return $outputStrings
}

function Hash-Validator{
    param(
        [Parameter(Mandatory = $true)] $hash
        )

    $hashLengths = @{MD5 = "32"; SHA1 = "40"; SHA224 = "56"; SHA256 = "64"; SHA512 = "128"}
    if($hash -match '^[0-9A-Fa-f]+$'){
        foreach($key in $hashLengths.Keys){
            if ($hashLengths[$key] -eq $hash.Length){
                return @($key, $hash)
            }
        }
    }   
    else{
        return
    }   
}
