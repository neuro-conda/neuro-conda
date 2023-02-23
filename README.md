# neuro-conda
A Python distribution for Neuroscience based on [conda](https://www.anaconda.com)

Although creating a virtual environment for each project is considered best practice, it can be a major obstacle for early-career neuroscientists that are just starting to learn programming. neuro-conda aims to simplify learning and using Python in Neuroscience by bundling commonly used packages in Neuroscience into tested and versioned conda environments. 

It is inspired by similar projects at the [Ernst Strüngmann Institute for Neuroscience](https://github.com/esi-neuroscience/esi-conda) and [University of Cambridge](https://github.com/jooh/neuroconda) providing read-made environments at their computing clusters.


## Fresh installation

### Windows 10 and 11 (PowerShell)

```PowerShell
$CondaInstallationDirectory = "$Env:userprofile\miniconda3"; If ($Env:username -match " ") { $CondaInstallationDirectory = "$Env:public\miniconda3" }; winget list --id Anaconda.Miniconda3 | out-null; If ($LASTEXITCODE -ne 0) { winget install miniconda3 --override "/RegisterPython=1 /S /InstallationType=JustMe /D=$CondaInstallationDirectory"; Write-Host "Installed miniconda into $CondaInstallationDirectory"; iex "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"; conda init powershell; } Else {Write-Host "miniconda3 is already installed"}; If (-not (Get-Command "conda" -errorAction SilentlyContinue)) { throw "Conda is installed but not available in this PowerShell. Please continue with the neuro-conda installation from a PowerShell with conda activated." }; $NeuroCondaLatestUrl = "<url>"; Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "neuro-conda-latest.yml"; conda env create --file "neuro-conda-latest.yml";
```

If you don't like obscure one-liners, here are the same commands on multiple lines:

```PowerShell

# Install miniconda3 if not installed
$CondaInstallationDirectory = "$Env:userprofile\miniconda3"
If ($Env:username -match " ") { $CondaInstallationDirectory = "$Env:public\miniconda3" }

winget list --id Anaconda.Miniconda3 | out-null
If ($LASTEXITCODE -ne 0) 
{
    winget install miniconda3 --override "/RegisterPython=1 /S /InstallationType=JustMe /D=$CondaInstallationDirectory"
    Write-Host "Installed miniconda into $CondaInstallationDirectory"
    iex "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"
    conda init powershell
} Else {Write-Host "miniconda3 is already installed"}

If (-not (Get-Command "conda" -errorAction SilentlyContinue))
{
    throw "Conda is installed but not available in this PowerShell. Please continue with the neuro-conda installation from a PowerShell with conda activated."
} 


# activate conda and install environment
# download environment file
$NeuroCondaLatestUrl = "<url>"
Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "neuro-conda-latest.yml"

conda env create --file neuro-conda-latest.yml
```


