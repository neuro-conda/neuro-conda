# Install miniconda3 if not installed
$CondaInstallationDirectory = "$Env:userprofile\miniconda3"
$MinicondaLatestUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
If ($Env:username -match " ") { $CondaInstallationDirectory = "$Env:public\miniconda3" }


function Find-Miniconda {           
    $name = "Miniconda3"
    $systemInstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match $name
    try {
        $userInstalled = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match $name
    }
    catch 
    {
        $userInstalled = ""
    }
    Write-Host "Found conda installations:"
    Write-Host $systemInstalled
    Write-Host $userInstalled
    return (($userInstalled.Length -gt 0) -or ($systemInstalled.Length -gt 0))
}

$CondaIsInstalled = Find-Miniconda

If (-not $CondaIsInstalled) {
    Write-Host "Downloading miniconda3"
    Invoke-WebRequest $MinicondaLatestUrl -OutFile $Env:temp\Miniconda3-latest-Windows-x86_64.exe
    Invoke-Expression "$Env:temp\Miniconda3-latest-Windows-x86_64.exe /RegisterPython=1 /S /InstallationType=JustMe /D=$CondaInstallationDirectory"
    Write-Host "Installed miniconda into $CondaInstallationDirectory"
    Invoke-Expression "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"
    conda init powershell
}
Else { Write-Host "miniconda3 is already installed" }

If (-not (Get-Command "conda" -errorAction SilentlyContinue)) {
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