# Write name in module.json replacing $name placeholder based on COMPOSE_PROJECT_NAME in the .env file
$buildJsonPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "xmcloud.build.json"
if (Test-Path -Path $buildJsonPath) {
    $buildJson = Get-Content -Path $buildJsonPath -Raw | ConvertFrom-Json
    $composeProjectName = $buildJson.renderingHosts.xmcloudpreview.name
} else {
    $composeProjectName = $null
}

if ($composeProjectName) {
  # Replace the name and appName with placeholder $name in package.json file to match the project name
    Write-Host "Updating package.json with project name '$composeProjectName'..." -ForegroundColor Green
    $packageJsonPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "src/sxastarter/package.json"
    if (Test-Path -Path $packageJsonPath) {
        $packageJson = Get-Content -Path $packageJsonPath -Raw | ConvertFrom-Json
        if ($packageJson) {
            # Update the name and appName properties
            $packageJson.name = $composeProjectName
            $packageJson.config.appName = $composeProjectName
            
            # Save the updated JSON back to the file
            $packageJson | ConvertTo-Json -Depth 10 | Set-Content -Path $packageJsonPath -Force
            Write-Host "Updated package.json with '$composeProjectName'." -ForegroundColor Green
        } else {
            Write-Warning "Could not parse JSON from $packageJsonPath. Skipping update."
        }
    } else {
        Write-Warning "Package.json file not found at path '$packageJsonPath'. Skipping update."
    }
  # Copy the contents of the modules folder to src folder
    $srcPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "src"
    $modulesPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "modules"
    
    if (Test-Path -Path $modulesPath) {
        # Ensure the src folder exists
        if (-not (Test-Path -Path $srcPath)) {
            New-Item -Path $srcPath -ItemType Directory -Force | Out-Null
        }
        
        # Copy all files and folders from modules to src recursively
        Copy-Item -Path "$modulesPath\*" -Destination $srcPath -Recurse -Force
        Write-Host "Copied all content from $modulesPath to $srcPath." -ForegroundColor Green
    } else {
        Write-Warning "Modules path '$modulesPath' does not exist. Skipping copy."
    }

        
} else {
    Write-Warning "COMPOSE_PROJECT_NAME not set in .env file. Skipping module.json update."
}