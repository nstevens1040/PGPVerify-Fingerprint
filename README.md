# PGPVerify-Fingerprint
This PowerShell script takes a public PGP key and calculates it's fingerprint, then it evaluates whether the public PGP key's fingerprint matches a known fingerprint.  
  
This script uses **[BouncyCastle.NetFramework](https://www.nuget.org/packages/BouncyCastle.NetFramework/)** *(also [bc-chsarp](https://github.com/bcgit/bc-csharp))*.  
  
## Installation
The PowerShell snippet below will make the script available in the current PowerShell session.  
  
The first time you run **PGPEncrypt-Message** it will install BouncyCastle.NetFramework.  
```ps1
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
iex (irm https://raw.githubusercontent.com/nstevens1040/PGPVerify-Fingerprint/main/PGPVerify-Fingerprint.ps1)
```
