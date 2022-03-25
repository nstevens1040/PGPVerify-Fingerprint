function PGPVerify-Fingerprint
{
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$recipient_public_key,
        [Parameter(Mandatory=$true)]
        [string]$known_fingerprint
    )
    if(!(get-package -Name BouncyCastle.NetFramework -ea 0))
    {
        Add-Type -TypeDefinition "namespace Bouncy`n{`n    using System;`n    using System.Diagnostics;`n    using System.Threading;`n    using System.Threading.Tasks;`n    using System.Linq;`n    using System.Collections.Generic;`n    public class Castle`n    {`n        public static void Install()`n        {`n            using(Process p = new Process()`n            {`n                StartInfo = new ProcessStartInfo()`n                {`n                    FileName = @`"C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe`",`n                    Arguments = `"-noprofile -ep remotesigned -c \`"[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; `$i = 0;`$name = 'nuget'; `$packageSources = Get-PackageSource | ? {`$_.Name -eq `$name };while(`$packageSources.count -gt 0){`$name = 'nuget' + `$i;`$packageSources = Get-PackageSource | ? {`$_.Name -eq `$name};`$i++};Register-PackageSource -Name `$name -Location 'https://www.nuget.org/api/v2' -ProviderName NuGet -Trusted; Install-Package -Name BouncyCastle.NetFramework -Source `$name; Unregister-PackageSource -Name `$name\`"`",`n                    Verb = `"RunAs`"`n                }`n            })`n            {`n                p.Start();`n                p.WaitForExit();`n            }`n        }`n    }`n}`n"
        [Bouncy.Castle]::Install()
        while(!(get-package -Name BouncyCastle.NetFramework -ea 0)){}
    }
    $dll = [IO.FileInfo]::New((get-package -Name BouncyCastle.NetFramework | % source)).Directory.EnumerateFiles("*.dll",[System.IO.SearchOption]::AllDirectories)[0].FullName
    Add-Type -Path $dll
    $pgp_pub = [Org.BouncyCastle.Bcpg.OpenPgp.PgpPublicKeyRing]::new(
        [System.Convert]::FromBase64String(
            [string]::Join(
                [string]::Empty,
                @([regex]::new("(?m)^((?!(-|`r|`n|=))\S+)").Matches($recipient_public_key).ForEach({ $_.Groups[1].value }) )
            )
        )
    )
    $fingerprint = @($pgp_pub.GetPublicKey().GetFingerprint().ForEach({ $_.ToString('X2') })) -join ''
    if($fingerprint -eq $known_fingerprint)
    {
        return $true
    } else {
        return $false
    }
}