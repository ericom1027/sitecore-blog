# Write name in module.json replacing $name placeholder based on COMPOSE_PROJECT_NAME in the .env file
$envContent = Get-Content .env -Encoding UTF8
$composeProjectName = $envContent | Where-Object { $_ -imatch "^COMPOSE_PROJECT_NAME=.+" }
$composeProjectName = $composeProjectName.Split("=")[1]

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

  # Copy the contents of serializarion folder to the src/items folder
    $serializationPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "serialization"
    $srcItemsPath = Join-Path -Path $srcPath -ChildPath "items"
    $contentPath = Join-Path -Path $srcItemsPath -ChildPath "content"

     if (-not (Test-Path -Path $contentPath)) {
        if (Test-Path -Path $serializationPath) {
                # Ensure the src/items folder exists
                if (-not (Test-Path -Path $srcItemsPath)) {
                    New-Item -Path $srcItemsPath -ItemType Directory -Force | Out-Null
                }
                
                # Copy all files and folders from serialization to src/items recursively
                Copy-Item -Path "$serializationPath\*" -Destination $srcItemsPath -Recurse -Force
                Write-Host "Copied all content from $serializationPath to $srcItemsPath." -ForegroundColor Green
            } else {
                Write-Warning "Serialization path '$serializationPath' does not exist. Skipping copy."
            }
    }

    

    # Process all *.module.json files to replace $name placeholders

    $moduleJsonFiles = Get-ChildItem -Path $srcPath -Recurse -Filter "*.module.json"

    foreach ($moduleJsonFile in $moduleJsonFiles) {
        $moduleJson = Get-Content -Path $moduleJsonFile.FullName -Raw | ConvertFrom-Json
        if (-not $moduleJson) {
            Write-Warning "Could not parse JSON from $($moduleJsonFile.FullName). Skipping."
            continue
        }
        # Replace $name in path strings within includes
        if ($moduleJson.items -and $moduleJson.items.includes) {
            foreach ($include in $moduleJson.items.includes) {
                if ($include.path) {
                    $include.path = $include.path.Replace('$name', $composeProjectName)
                }
                if ($include.rules) {
                    foreach ($rule in $include.rules) {
                        if ($rule.path) {
                            $rule.path = $rule.path.Replace('$name', $composeProjectName)
                        }
                    }
                }
            }
        }
        
        # Save the updated JSON
        $moduleJson | ConvertTo-Json -Depth 10  | Set-Content -Path $moduleJsonFile.FullName -Force
        Write-Host "Updated $($moduleJsonFile.Name) with '$composeProjectName'." -ForegroundColor Green
    }
  

    # Process all yaml files to replace $projectname placeholders
    $srcItemsPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "src/items"
    $ymlFiles =  Get-ChildItem -Path $srcPath -Recurse -Filter "*.yml"
    foreach ($ymlFile in $ymlFiles) {
        $content = Get-Content -Path $ymlFile.FullName -Raw
        if ($content -match '\$projectname') {
            $updatedContent = $content -replace '\$projectname', $composeProjectName
            Set-Content -Path $ymlFile.FullName -Value $updatedContent -Force
            Write-Host "Updated $($ymlFile.Name) with '$composeProjectName'." -ForegroundColor Green
        } else {
            Write-Host "No placeholder found in $($ymlFile.Name). Skipping." -ForegroundColor Yellow
        }
    }

    # Rename the yml files to match the project name
    foreach ($ymlFile in $ymlFiles) {
        $newFileName = $ymlFile.Name -replace '\$projectname', $composeProjectName
        if ($newFileName -ne $ymlFile.Name) {
            $newFilePath = Join-Path -Path $ymlFile.DirectoryName -ChildPath $newFileName
            Rename-Item -Path $ymlFile.FullName -NewName $newFilePath -Force
            Write-Host "Renamed $($ymlFile.Name) to $newFileName." -ForegroundColor Green
        } else {
            Write-Host "No renaming needed for $($ymlFile.Name)." -ForegroundColor Yellow
        }
    }

    # Rename the folders that named $projectname to match the project name
    $folders = Get-ChildItem -Path $srcPath -Directory -Recurse | Where-Object { $_.Name -match '\$projectname' }
    # Sort folders by depth (deepest first) to avoid parent folder rename issues
    $folders = $folders | ForEach-Object {
        $depth = ($_.FullName -split '\\').Count
        $_ | Add-Member -MemberType NoteProperty -Name 'Depth' -Value $depth -PassThru
    } | Sort-Object -Property Depth -Descending

    foreach ($folder in $folders) {
        $newFolderName = $folder.Name -replace '\$projectname', $composeProjectName
        if ($newFolderName -ne $folder.Name) {
            $newFolderPath = Join-Path -Path $folder.Parent.FullName -ChildPath $newFolderName
            if (Test-Path -Path $folder.FullName) {
                Rename-Item -Path $folder.FullName -NewName $newFolderPath -Force
                Write-Host "Renamed folder $($folder.Name) to $newFolderName." -ForegroundColor Green
            } else {
                Write-Host "Skipping rename of $($folder.FullName) - path no longer exists." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No renaming needed for folder $($folder.Name)." -ForegroundColor Yellow
        }
    }     
} else {
    Write-Warning "COMPOSE_PROJECT_NAME not set in .env file. Skipping module.json update."
}