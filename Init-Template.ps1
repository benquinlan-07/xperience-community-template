# Usage: .\Init-Template.ps1 -ExtensionName "YourExtensionName"
# Example: .\Init-Template.ps1 -ExtensionName "FormNotifications"

param(
    [Parameter(Mandatory = $true)]
    [string]$ExtensionName
)

# Validate the extension name
if ([string]::IsNullOrWhiteSpace($ExtensionName)) {
    Write-Error "ExtensionName parameter cannot be empty or whitespace."
    exit 1
}

# Convert extension name to lowercase for certain replacements
$extensionNameLower = $ExtensionName.ToLower()

Write-Host "Starting extension template transformation..." -ForegroundColor Green
Write-Host "Extension Name: $ExtensionName" -ForegroundColor Yellow
Write-Host "Extension Name (lowercase): $extensionNameLower" -ForegroundColor Yellow

# Get the script directory (template root)
$templateRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define file extensions to process for content replacement
$fileExtensions = @('*.sln', '*.csproj', '*.cs', '*.cshtml', '*.json', '*.config', '*.js', '*.tsx')

# Step 1: Rename directories and files containing 'XperienceCommunity.ExtensionTemplate'
Write-Host "`nStep 1: Renaming directories and files..." -ForegroundColor Cyan

# Find all directories with 'XperienceCommunity.ExtensionTemplate' in the name, excluding build/temp directories
$dirsToRename = Get-ChildItem -Path $templateRoot -Recurse -Directory | Where-Object { 
    $_.Name -like "*XperienceCommunity.ExtensionTemplate*" -and 
    $_.FullName -notmatch '\\(bin|obj|node_modules|\.vs|\.git)\\' 
}
foreach ($dir in $dirsToRename) {
    $newName = $dir.Name -replace 'XperienceCommunity.ExtensionTemplate', "XperienceCommunity.$ExtensionName"
    $newPath = Join-Path $dir.Parent.FullName $newName
    Write-Host "Renaming directory: $($dir.FullName) -> $newPath" -ForegroundColor Yellow
    
    try {
        # Check if target already exists
        if (Test-Path $newPath) {
            Write-Host "  - Target directory already exists, skipping" -ForegroundColor DarkGray
        } else {
            Rename-Item -Path $dir.FullName -NewName $newName -ErrorAction Stop
            Write-Host "  ✓ Directory renamed successfully" -ForegroundColor Green
        }
    }
    catch {
        Write-Warning "Failed to rename directory $($dir.FullName): $($_.Exception.Message)"
    }
}

# Find all files with 'XperienceCommunity.ExtensionTemplate' in the name, excluding build/temp files
$filesToRename = Get-ChildItem -Path $templateRoot -Recurse -File | Where-Object { 
    $_.Name -like "*XperienceCommunity.ExtensionTemplate*" -and 
    $_.FullName -notmatch '\\(bin|obj|node_modules|\.vs|\.git)\\' 
}
foreach ($file in $filesToRename) {
    $newName = $file.Name -replace 'XperienceCommunity.ExtensionTemplate', "XperienceCommunity.$ExtensionName"
    $newPath = Join-Path $file.Directory.FullName $newName
    Write-Host "Renaming file: $($file.FullName) -> $newPath" -ForegroundColor Yellow
    
    try {
        # Check if target already exists
        if (Test-Path $newPath) {
            Write-Host "  - Target file already exists, skipping" -ForegroundColor DarkGray
        } else {
            Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
            Write-Host "  ✓ File renamed successfully" -ForegroundColor Green
        }
    }
    catch {
        Write-Warning "Failed to rename file $($file.FullName): $($_.Exception.Message)"
    }
}

# Step 2: Process file content replacements
Write-Host "`nStep 2: Processing file content replacements..." -ForegroundColor Cyan

# Get all files matching the specified extensions, excluding node_modules, .vs, and .git directories
$filesToProcess = @()
foreach ($extension in $fileExtensions) {
    $filesToProcess += Get-ChildItem -Path $templateRoot -Recurse -File -Include $extension | Where-Object { 
        $_.FullName -notmatch '\\(node_modules|\.vs|\.git)\\' 
    }
}

# Remove duplicates
$filesToProcess = $filesToProcess | Sort-Object FullName | Get-Unique

Write-Host "Found $($filesToProcess.Count) files to process for content replacement." -ForegroundColor Yellow

foreach ($file in $filesToProcess) {
    Write-Host "Processing: $($file.FullName)" -ForegroundColor Gray
    
    try {
        # Read file content
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Pattern 1: XperienceCommunity.ExtensionTemplate -> XperienceCommunity.{ExtensionName}
        $content = $content -creplace 'XperienceCommunity\.ExtensionTemplate', "XperienceCommunity.$ExtensionName"
        
        # Pattern 2: xperiencecommunityextensiontemplate -> xperiencecommunity{extensionname}
        $content = $content -creplace 'xperiencecommunityextensiontemplate', "xperiencecommunity$extensionNameLower"
        
        # Pattern 3: ExtensionTemplate -> {ExtensionName}
        $content = $content -creplace 'ExtensionTemplate', $ExtensionName
        
        # Only write back if content changed
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  ✓ Updated content" -ForegroundColor Green
        } else {
            Write-Host "  - No changes needed" -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Warning "Failed to process file $($file.FullName): $($_.Exception.Message)"
    }
}

# Step 3: Special handling for package.json and package-lock.json name fields
Write-Host "`nStep 3: Processing package.json name fields..." -ForegroundColor Cyan

$packageJsonFiles = Get-ChildItem -Path $templateRoot -Recurse -File -Include "package.json", "package-lock.json" | Where-Object { 
    $_.FullName -notmatch '\\(node_modules|\.vs|\.git)\\' 
}
foreach ($packageFile in $packageJsonFiles) {
    Write-Host "Processing package file: $($packageFile.FullName)" -ForegroundColor Gray
    
    try {
        $content = Get-Content -Path $packageFile.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Handle package name patterns that might have -web-admin suffix
        $content = $content -creplace 'xperiencecommunityextensiontemplate-web-admin', "xperiencecommunity$extensionNameLower-web-admin"
        
        if ($content -ne $originalContent) {
            Set-Content -Path $packageFile.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  ✓ Updated package name" -ForegroundColor Green
        }
    }
    catch {
        Write-Warning "Failed to process package file $($packageFile.FullName): $($_.Exception.Message)"
    }
}

Write-Host "`nExtension template transformation completed!" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "- Renamed directories and files containing 'XperienceCommunity.ExtensionTemplate'" -ForegroundColor White
Write-Host "- Replaced 'XperienceCommunity.ExtensionTemplate' with 'XperienceCommunity.$ExtensionName'" -ForegroundColor White
Write-Host "- Replaced 'xperiencecommunityextensiontemplate' with 'xperiencecommunity$extensionNameLower'" -ForegroundColor White
Write-Host "- Replaced 'ExtensionTemplate' with '$ExtensionName'" -ForegroundColor White
Write-Host "`nDon't forget to review the changes and test your extension!" -ForegroundColor Cyan

# Step 4: Clean up - Delete the initialization script
Write-Host "`nStep 4: Cleaning up..." -ForegroundColor Cyan
$scriptPath = $MyInvocation.MyCommand.Path
Write-Host "Deleting initialization script: $scriptPath" -ForegroundColor Yellow

try {
    Remove-Item -Path $scriptPath -Force
    Write-Host "  ✓ Initialization script deleted successfully" -ForegroundColor Green
}
catch {
    Write-Warning "Failed to delete initialization script: $($_.Exception.Message)"
    Write-Host "You may need to manually delete: '$scriptPath'" -ForegroundColor Yellow
}
