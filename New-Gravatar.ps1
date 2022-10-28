<#
.DESCRIPTION
Generate and download a Gravatar for a EmailAddress.

.PARAMETER EmailAddress
The emailaddress for which to fetch a gravatar. Does not have to be a email address. String will be trimmed, and lowercased. After which a md5 hash will be generated. The MD5 is what really is used for the download.

.PARAMETER ForceImage
Always download a gravatar image, even if user has pushed "personal" image to the gravatar system.

.EXAMPLE
./New-Gravatar -EmailAddress joe@example.com
Download the gravatar for joe@example.com

.EXAMPLE
./New-Gravatar -EmailAddress joe@example.com -GravatarType robohash -ForceImage
Download a Robot Gravatar for joe@example.com, even if they have a personal gravatar image.

.LINK
https://en.gravatar.com/site/implement/images/

#>
[CmdletBinding()]
param (
    [Parameter()][String]$EmailAddress,
    [Parameter()][Switch]$ForceImage,
    [Parameter()][ValidateSet("identicon", "monsterid", "wavatar", "retro", "robohash")][String]$GravatarType = "robohash",
    [Parameter()][Int]$ImageSize = 400
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