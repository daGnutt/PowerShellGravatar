
[CmdletBinding()]
param (
    [Parameter()][String]$EmailAddress,
    [Parameter()][Switch]$ForceImage,
    [Parameter()][ValidateSet("identicon", "monsterid", "wavatar", "retro", "robohash")][String]$GravatarType = "monsterid",
    [Parameter()][Int]$ImageSize = 200
)

$EmailAddress = $EmailAddress.Trim().toLower()

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($EmailAddress)))
$hash = $hash -replace '[-]'
$hash = $hash.toLower()

$uri = "https://gravatar.com/avatar/${hash}?s=${ImageSize}"
$uri += "&d=$GravatarType"
if ($ForceImage)
{
    $uri += "&f=y"
}

Invoke-WebRequest -Uri $uri -OutFile "$emailAddress.png"