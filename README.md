# neuro-conda - a Python distribution for neuroscience based on [conda](https://www.anaconda.com)

Although creating a virtual environment for each project is considered best practice, it can be a major obstacle for early-career neuroscientists that are just starting to learn programming. **neuro-conda** aims to simplify learning and using Python in neuroscience by bundling commonly used packages in neuroscience into curated conda environments. 

It is inspired by the similar projects at the [Ernst Strüngmann Institute for Neuroscience](https://github.com/esi-neuroscience/esi-conda) and [University of Cambridge](https://github.com/jooh/neuroconda) as well as [NeuroDesk](https://www.neurodesk.org) providing easy-to-install Python environments for neuroscience.

Currently the neuro-conda includes the following neuroscientific Python packages (in alphabetic order):

- [bycycle](https://bycycle-tools.github.io)
- [elephant](https://elephant.readthedocs.io) + [viziphant](https://viziphant.readthedocs.io)
- [esi-syncopy](https://syncopy.readthedocs.io)
- [fooof](https://fooof-tools.github.io)
- [mne](https://mne.tools)
- [neo](https://neo.readthedocs.io)
- [neurodsp](https://neurodsp-tools.github.io)
- [nixio](https://nixio.readthedocs.io)
- [pynwb](https://pynwb.readthedocs.io)
- [spikeinterface](https://spikeinterface.readthedocs.io)

More neuroscience tools will be added in the future.

Other non-neuroscience includes are (see [the environment files](/envs) for details)
- [dask](https://www.dask.org)
- [esi-acme](https://esi-acme.readthedocs.io)
- [jupyter](https://jupyter.org)

## Fresh installation

### Windows 10 and 11 (PowerShell)

```PowerShell
$CondaInstallationDirectory = "$Env:userprofile\miniconda3"; $MinicondaLatestUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"; If ($Env:username -match " ") { $CondaInstallationDirectory = "$Env:public\miniconda3" }; winget list --id Anaconda.Miniconda3 | out-null; If ($LASTEXITCODE -ne 0) { Write-Host "Downloading miniconda3"; Invoke-WebRequest $MinicondaLatestUrl -OutFile $Env:temp\Miniconda3-latest-Windows-x86_64.exe; iex "$Env:temp\Miniconda3-latest-Windows-x86_64.exe /RegisterPython=1 /S /InstallationType=JustMe /D=$CondaInstallationDirectory"; Write-Host "Installed miniconda into $CondaInstallationDirectory"; iex "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"; conda init powershell; } Else {Write-Host "miniconda3 is already installed"}; If (-not (Get-Command "conda" -errorAction SilentlyContinue)) { throw "Conda is installed but not available in this PowerShell. Please continue with the neuro-conda installation from a PowerShell with conda activated." }; conda update -n base conda -c defaults -y; conda install mamba -n base -c conda-forge; $NeuroCondaLatestUrl = "https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml"; Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "$Env:temp\neuro-conda-latest.yml"; mamba env create --file "$Env:temp\neuro-conda-latest.yml"
```

If you don't like obscure one-liners, here are the same commands on multiple lines:

```PowerShell

# Install miniconda3 if not installed
$CondaInstallationDirectory = "$Env:userprofile\miniconda3"
$MinicondaLatestUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
If ($Env:username -match " ") { $CondaInstallationDirectory = "$Env:public\miniconda3" }

winget list --id Anaconda.Miniconda3 | out-null
If ($LASTEXITCODE -ne 0) 
{   
    Write-Host "Downloading miniconda3"
    Invoke-WebRequest $MinicondaLatestUrl -OutFile $Env:temp\Miniconda3-latest-Windows-x86_64.exe
    iex "$Env:temp\Miniconda3-latest-Windows-x86_64.exe /RegisterPython=1 /S /InstallationType=JustMe /D=$CondaInstallationDirectory"
    Write-Host "Installed miniconda into $CondaInstallationDirectory"
    iex "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"
    conda init powershell
} Else {Write-Host "miniconda3 is already installed"}

If (-not (Get-Command "conda" -errorAction SilentlyContinue))
{
    throw "Conda is installed but not available in this PowerShell. Please continue with the neuro-conda installation from a PowerShell with conda activated."
} 


# update conda
conda update -n base conda -c defaults -y

# install mamba for faster dependency resolution
conda install mamba -n base -c conda-forge -y

# activate conda and install environment
conda activate

# download environment file
$NeuroCondaLatestUrl = "https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml"
Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "$Env:temp\neuro-conda-latest.yml"

mamba env create --file "$Env:temp\neuro-conda-latest.yml"
```

### Linux


### macOS

## From an existing conda Installation

### Windows 10/11 (PowerShell)
```
Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "$Env:temp\neuro-conda-latest.yml"
mamba env create --file "$Env:temp\neuro-conda-latest.yml"
```
