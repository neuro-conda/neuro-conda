# Uninstall neuro-conda in Windows
# This script simply automates the official uninstallation instructions:
# https://docs.anaconda.com/free/anaconda/install/uninstall/#windows

# Set up env variables + functions
If ($Env:ncDebug){
    $DebugPreference = "Continue"
}
If ($Env:ncCI){
    Write-Debug "Running inside CI pipeline, turning on non-interactive mode"
    $Env:ncNoninteractive = $true
}
If ($Env:ncNoninteractive){
    Write-Warning "Running in non-interactive mode - will not prompt for input!"
}
If ($Env:username -match " "){
    $CondaInstallationDirectory = "$Env:public\miniconda3"
}
Else {
    $CondaInstallationDirectory = "$Env:userprofile\miniconda3"
}

function User-Input {
    $ans = Read-Host "Press RETURN/ENTER to continue or any other key to abort:"
    if ($ans -eq ""){
        Exit
    }
}

# Start actual script execution
Write-Debug "Installation started at $(Get-Date)"
$tic=(Get-Date).Minute

# Determine root dir of active conda installation
try {
    $condaBinPath = Split-Path (Split-Path (Get-Command conda).Path)
}
catch {
    Write-Error "No neuro-conda installation found on this system. Exiting..."
}

# Check if we're working with a default installation
If ($condaBinPath.Contains($CondaInstallationDirectory)) {
    Write-Debug "Found neuro-conda in default location"
}
Else {
    $CondaInstallationDirectory = $condaBinPath
    Write-Warning "Found non-standard neuro-conda installation at $CondaInstallationDirectory"
    If (-not $Env:ncNoninteractive){
        Write-Warning "Do you want to proceed removing this installation?"
        User-Input
    }
}

# Be specific: show which conda installation we're about to wipe
Write-Host "About to remove the conda installation found in $CondaInstallationDirectory"
If (-not $Env:ncNoninteractive){
    User-Input
}

# If deletion candidate does not contain a neuro-conda environment, ask for confirmation...
If (conda env list | Select-String -Pattern "neuro-conda"){
    Write-Debug "Found neuro-conda environment in $CondaInstallationDirectory"
}
Else {
    If (-not $Env:ncNoninteractive){
        Write-Warning "neuro-conda environment NOT found in $CondaInstallationDirectory. Are you sure you want to delete this installation?"
        User-Input
    }
    Else {
        Write-Warning "Removing $CondaInstallationDirectory despite it not containing a neuro-conda environment"
    }
}

# Step 1: delete `envs` and `pkgs` folders
Write-Host "Removing envs and pkgs folders..."
Remove-Item -Path (Join-Path -Path $CondaInstallationDirectory -ChildPath "envs") -Recurse -Force
Remove-Item -Path (Join-Path -Path $CondaInstallationDirectory -ChildPath "envs") -Recurse -Force
Write-Debug "Done"

# Step 2: run uninstaller
Write-Host "Running uninstaller..."
Start-Process "Uninstall-Miniconda3.exe" -ArgumentList "/S" -Wait
Write-Host "All done."
Write-Host "Please close this window and open a new terminal."

# If we're debugging, print timing info
$toc = (Get-Date).Minute
Write-Debug "Installation finished. Runtime: $($toc - $tic)  minutes"
