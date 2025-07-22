# Store COMPOSE_PROJECT_NAME from .env into a projectname variable
$projectname = (Get-Content .env | Where-Object { $_ -match '^COMPOSE_PROJECT_NAME=' }).Split('=')[1].Trim()
$nodeVersion = (Get-Content .env | Where-Object { $_ -match '^NODEJS_VERSION=' }).Split('=')[1].Trim()

# Clone the sxastarter from renderinghosts folder and rename the folder into projectname
$sourcePath = ".\src\renderinghosts\sxastarter"
$destinationPath = ".\src\renderinghosts\$projectname"
if (Test-Path $sourcePath) {
    if (-Not (Test-Path $destinationPath)) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse
        Write-Host "Cloned sxastarter to $destinationPath"
    } else {
        Write-Host "Destination path already exists: $destinationPath"
    }
} else {
    Write-Host "Source path does not exist: $sourcePath"
}
# Update the xmcloud.build.json file and add a new entry in renderingHosts node based on new projectname
$jsonFilePath = ".\xmcloud.build.json"
$jsonContent = Get-Content $jsonFilePath | ConvertFrom-Json
if (-not (Get-Member -InputObject $jsonContent.renderingHosts -Name $projectname -MemberType NoteProperty)) {
    $newEntry = @{
        name = $projectname
        path = "./src/renderinghosts/$projectname"
        nodeVersion = $nodeVersion
        jssDeploymentSecret = "110F1C44A496B45478640DD36F80C18C9"
        enabled = $true
        type = "sxa"
        lintCommand = "lint"
        startCommand = "start:production"
    }

    $jsonContent.renderingHosts | Add-Member -MemberType NoteProperty -Name $projectname -Value $newEntry
    $jsonContent | ConvertTo-Json -Depth 10 | Set-Content $jsonFilePath
    Write-Host "Updated $jsonFilePath with new rendering host: $projectname"
} else {
    Write-Host "Rendering host already exists: $projectname"
}

# Update the .env file RENDERING_HOST_PATH to .\src\renderinghosts\$projectname
$envFilePath = ".\.env"
$envContent = Get-Content $envFilePath
$renderingHostPathLine = $envContent | Where-Object { $_ -match '^RENDERING_HOST_PATH=' }
if ($renderingHostPathLine) {
    $newRenderingHostPath = "RENDERING_HOST_PATH=.\src\renderinghosts\$projectname"
    $envContent = $envContent -replace '^RENDERING_HOST_PATH=.*', $newRenderingHostPath
    Set-Content -Path $envFilePath -Value $envContent
    Write-Host "Updated RENDERING_HOST_PATH in .env to: $newRenderingHostPath"
} else {
    Write-Host "RENDERING_HOST_PATH not found in .env file."
}
#Update name and appName field in package.json file in the new rendering host folder 

# Rename
$packageJsonPath = ".\src\renderinghosts\$projectname\package.json"
if (Test-Path $packageJsonPath) {
    $packageJsonContent = Get-Content $packageJsonPath | ConvertFrom-Json
    $packageJsonContent.name = $projectname
    $packageJsonContent.config.appName = $projectname
    $packageJsonContent | ConvertTo-Json -Depth 10 | Set-Content $packageJsonPath
    Write-Host "Updated $packageJsonPath with new name and appName: $projectname"
} else {
    Write-Host "package.json not found: $packageJsonPath"
}
