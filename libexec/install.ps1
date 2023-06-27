# Set up env variables
If ($Env:ncDebug){
    $DebugPreference = "Continue"
}
If ($Env:ncCI)){
    Write-Debug "Running inside CI pipeline"
}
If ($Env:ncTargetDirectory){
    Write-Debug "Found ncTargetDirectory=$Env:ncTargetDirectory"
    $CondaInstallationDirectory = "$Env:ncTargetDirectory"
}
Else {
    If ($Env:username -match " "){
        $CondaInstallationDirectory = "$Env:public\miniconda3"
    }
    Else {
        $CondaInstallationDirectory = "$Env:userprofile\miniconda3"
    }
}
$MinicondaLatestUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"

# Start actual script execution
Write-Debug "Installation started at $(Get-Date)"
$tic=(Get-Date).Minute

Write-Debug "Using CondaInstallationDirectory=$CondaInstallationDirectory"

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

# On GH CI runners, conda is always installed
If ((-not $CondaIsInstalled) -or ($Env:ncCI)){
    Write-Host "Downloading miniconda3"
    Invoke-WebRequest $MinicondaLatestUrl -OutFile $Env:temp\Miniconda3-latest-Windows-x86_64.exe
    Write-Debug "Done"
    Write-Host "Installing miniconda3"
    Start-Process -WorkingDirectory "$Env:temp" -Wait -FilePath "Miniconda3-latest-Windows-x86_64.exe" -ArgumentList "/InstallationType=JustMe /S /D=`"$CondaInstallationDirectory`""
    Write-Debug "Done"
    Write-Debug "Initializing PowerShell for conda"
    Invoke-Expression "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"
    # (& "$CondaInstallationDirectory\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
    Write-Debug "Done"
}
Else { Write-Host "miniconda3 is already installed" }

If (-not (Get-Command "conda" -errorAction SilentlyContinue)) {
    throw "Conda is installed but not available in this PowerShell. Please continue with the neuro-conda installation from a PowerShell with conda activated."
}

# update conda
Write-Debug "Updating conda itself"
conda update -n base conda -c defaults -y
Write-Debug "Done"

# install mamba for faster dependency resolution
Write-Debug "Installing mamba"
conda install mamba -n base -c conda-forge -y
Write-Debug "Done"

# activate conda and install environment
Write-Debug "Activating conda"
conda activate

# download environment file if not on GitHub runner
If (-not $Env:ncCI)
{
    $NeuroCondaLatestUrl = "https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml"
    Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "$Env:temp\neuro-conda-latest.yml"
    $filename = "$Env:temp\neuro-conda-latest.yml"
    Write-Debug "Downloaded $NeuroCondaLatestUrl to $Env:temp\neuro-conda-latest.yml"
}
Else
{
    $filename = "envs\neuro-conda-latest.yml"
    Write-Debug "Using local repository version of latest environment file"
}

Write-Host "Creating latest neuro-conda environment"
mamba env create --file $filename
Write-Debug "Done"

If ($Env:ncEditor)
{
    Write-Host "Installing Spyder on Windows is not yet supported. You can add it later on by activating the neuro-conda environment and installing it via"
    Write-Host "    conda install spyder"
}

# If we're debugging, print timing info
$toc = (Get-Date).Minute
Write-Debug "Installation finished. Runtime: $($toc - $tic)  minutes"
