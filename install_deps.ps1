<#
PowerShell installer script to set up a Python virtual environment and install dependencies.
- By default this installs the CPU-focused packages listed in requirements.txt
- For GPU, uncomment or modify the install lines as noted below (Pick the right cupy / torch wheel for your CUDA version)
#>

param(
    [switch]$Gpu,
    [switch]$RunNow
)

Write-Host "Running install_deps.ps1 (Gpu=$Gpu, RunNow=$RunNow)"

# Detect Python
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Error "Python not found in PATH. Please install Python 3.8+ and re-run this script."
    exit 1
}

# Create venv
if (-not (Test-Path -Path ".venv")) {
    Write-Host "Creating virtual environment in .venv ..."
    python -m venv .venv
} else {
    Write-Host ".venv already exists — will reuse it."
}

# Activate venv (PowerShell)
$activate = Join-Path (Get-Location) ".venv\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) {
    Write-Error "Can't find activate script at $activate"
    exit 1
}

Write-Host "Activating virtual environment"
. "$activate"

# Ensure pip/upstream tools are fresh
python -m pip install --upgrade pip setuptools wheel

# CPU default installs
pip install -r requirements.txt

if ($Gpu) {
    Write-Host "GPU flag set — attempting to install GPU-targeted packages. Please edit this script to match your CUDA version if needed."
    Write-Host "Example: pip install cupy-cuda118 \n   and pip install torch --index-url https://download.pytorch.org/whl/cu118"
    # Do not auto-install GPU packages to avoid mismatches — let the user run commands manually or edit as required.
}

Write-Host "Installation complete. To activate the environment later run:\n    .\.venv\Scripts\Activate.ps1"
