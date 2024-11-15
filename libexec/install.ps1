# Set up env variables
If ($Env:ncDebug) {
    $DebugPreference = "Continue"
}
If ($Env:ncCI) {
    Write-Debug "Running inside CI pipeline, turning on non-interactive mode"
    $Env:ncNoninteractive = $true
}
If ($Env:ncNoninteractive) {
    Write-Warning "Running in non-interactive mode - will not prompt for input!"
}
If ($Env:ncTargetDirectory) {
    Write-Debug "Found ncTargetDirectory=$Env:ncTargetDirectory"
    $CondaInstallationDirectory = "$Env:ncTargetDirectory"
}
Else {
    If ($Env:username -match " ") {
        $CondaInstallationDirectory = "$Env:public\miniforge3"
    }
    Else {
        $CondaInstallationDirectory = "$Env:userprofile\miniforge3"
    }
}
$MiniforgeLatestUrl = "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe"

function User-Input {
    $ans = Read-Host "Press RETURN/ENTER to continue or any other key to abort"
    if ($ans -ne "") {
        Exit
    }
}

# Start actual script execution
Write-Debug "Installation started at $(Get-Date)"
$tic = (Get-Date).Minute

Write-Debug "Using CondaInstallationDirectory=$CondaInstallationDirectory"

function Find-Miniforge {
    $name = "miniforge3"
    $systemInstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match $name
    try {
        $userInstalled = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match $name
    }
    catch {
        $userInstalled = ""
    }
    Write-Host "Found conda installations:"
    Write-Host $systemInstalled
    Write-Host $userInstalled
    return (($userInstalled.Length -gt 0) -or ($systemInstalled.Length -gt 0))
}

$CondaIsInstalled = Find-Miniforge

# On GH CI runners, conda is always installed
If ((-not $CondaIsInstalled) -or ($Env:ncCI)) {
    Write-Host "Downloading miniforge3"
    Invoke-WebRequest $MiniforgeLatestUrl -OutFile $Env:temp\Miniforge3-Windows-x86_64.exe
    Write-Debug "Done"
    Write-Host "Installing miniforge"
    
    Start-Process -WorkingDirectory "$Env:temp" -Wait -FilePath "Miniforge3-Windows-x86_64.exe" -ArgumentList "/InstallationType=JustMe /RegisterPython=1 /S /D=$CondaInstallationDirectory"
    Write-Debug "Done"
    Write-Debug "Initializing PowerShell for conda"
    Invoke-Expression "$CondaInstallationDirectory\shell\condabin\conda-hook.ps1"
    Write-Debug "Done"
}
Else {
    Write-Warning "miniforge3 is already installed"
    If (-not $Env:ncNoninteractive) {
        Write-Warning "Do you really want to install neuro-conda alongside the existing miniforge3?"
        User-Input
    }
    Else {
        Write-Host "Installing neuro-conda alongside existing miniforge3"
    }
}

If (-not (Get-Command "conda" -errorAction SilentlyContinue)) {
    throw "Conda is installed but not available in this PowerShell. Please continue with the neuro-conda installation from a PowerShell with conda activated."
}

# update conda
Write-Debug "Updating conda itself"
conda update -n base conda -c conda-forge -y
Write-Debug "Done"

# activate conda and install environment
Write-Debug "Activating conda"
conda activate

# download environment file if not on GitHub runner
If (-not $Env:ncCI) {
    $NeuroCondaLatestUrl = "https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml"
    Invoke-WebRequest $NeuroCondaLatestUrl -OutFile "$Env:temp\neuro-conda-latest.yml"
    $filename = "$Env:temp\neuro-conda-latest.yml"
    Write-Debug "Downloaded $NeuroCondaLatestUrl to $Env:temp\neuro-conda-latest.yml"
}
Else {
    $filename = "envs\neuro-conda-latest.yml"
    Write-Debug "Using local repository version of latest environment file"
}

Write-Host "Creating latest neuro-conda environment"
mamba env create --file $filename
Write-Debug "Done"

If ($Env:ncEditor) {
    Write-Host "Installing Spyder on Windows is not yet supported. You can add it later on by activating the neuro-conda environment and installing it via"
    Write-Host "    conda install spyder"
}

# If we're debugging, print timing info
$toc = (Get-Date).Minute
Write-Debug "Installation finished. Runtime: $($toc - $tic)  minutes"
