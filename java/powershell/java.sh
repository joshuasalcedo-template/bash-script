# PowerShell script to download and install Java, JavaFX, Maven, and IntelliJ Toolbox
# Run as Administrator for best results

# Display banner
Write-Host @"
   _______          **      **_____          __         
  / ____\ \        / /\    / ____\ \        / /\        
 | (___  \ \  /\  / /  \  | (___  \ \  /\  / /  \       
  \___ \  \ \/  \/ / /\ \  \___ \  \ \/  \/ / /\ \      
  ____) |  \  /\  / ____ \ ____) |  \  /\  / ____ \     
 |_____/ ___\/__\/_/   *\*\_____/ ___\/_ \/_/___ \_\  __
 |  ** \|  \ \    / /        |  **__| \ | \ \    / /
 | |  | | |__   \ \  / /   ______| |__  |  \| |\ \  / / 
 | |  | |  **|   \ \/ /   |**____|  __| | . ` | \ \/ /  
 | |__| | |____   \  /           | |____| |\  |  \  /   
 |_____/|______|   \/            |______|_| \_|   \/    
"@

# Define directories
$DownloadDir = "$env:USERPROFILE\Downloads\JavaSetup"
$TempDir = "$env:TEMP\JavaSetup"
$ProgramFiles = "C:\Program Files"
$JavaDir = "$ProgramFiles\Java"
$MavenDir = "$ProgramFiles\Maven"
$SevenZipPath = "$env:ProgramFiles\7-Zip\7z.exe"

# Create necessary directories
function Create-Directories {
    Write-Host "`n[Creating Directories]" -ForegroundColor Cyan
    
    if (-not (Test-Path $DownloadDir)) {
        New-Item -Path $DownloadDir -ItemType Directory -Force | Out-Null
        Write-Host "Created download directory: $DownloadDir"
    }
    
    if (-not (Test-Path $TempDir)) {
        New-Item -Path $TempDir -ItemType Directory -Force | Out-Null
        Write-Host "Created temp directory: $TempDir"
    }
    
    if (-not (Test-Path $JavaDir)) {
        New-Item -Path $JavaDir -ItemType Directory -Force | Out-Null
        Write-Host "Created Java directory: $JavaDir"
    }
    
    if (-not (Test-Path $MavenDir)) {
        New-Item -Path $MavenDir -ItemType Directory -Force | Out-Null
        Write-Host "Created Maven directory: $MavenDir"
    }
}

# Check for 7-Zip and install if not present
function Ensure-7Zip {
    Write-Host "`n[Checking for 7-Zip]" -ForegroundColor Cyan
    
    if (-not (Test-Path $SevenZipPath)) {
        Write-Host "7-Zip not found. Installing..." -ForegroundColor Yellow
        
        # Use Chocolatey if available
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            choco install 7zip -y
        } else {
            # Manual download and install of 7-Zip
            $7zipUrl = "https://www.7-zip.org/a/7z2301-x64.exe"
            $7zipInstaller = "$DownloadDir\7z2301-x64.exe"
            
            Invoke-WebRequest -Uri $7zipUrl -OutFile $7zipInstaller
            Start-Process -FilePath $7zipInstaller -ArgumentList "/S" -Wait
        }
        
        if (Test-Path $SevenZipPath) {
            Write-Host "7-Zip installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to install 7-Zip. Some archive extractions may fail." -ForegroundColor Red
        }
    } else {
        Write-Host "7-Zip already installed." -ForegroundColor Green
    }
}

# Define the files to download
$DownloadList = @(
    @{
        Name = "OpenJDK 17";
        Url = "https://download.java.net/openjdk/jdk17.0.0.1/ri/openjdk-17.0.0.1+2_windows-x64_bin.zip";
        FileName = "openjdk-17.0.0.1+2_windows-x64_bin.zip";
        Type = "JDK";
        Version = "17";
    },
    @{
        Name = "OpenJDK 21";
        Url = "https://download.java.net/openjdk/jdk21/ri/openjdk-21+35_windows-x64_bin.zip";
        FileName = "openjdk-21+35_windows-x64_bin.zip";
        Type = "JDK";
        Version = "21";
    },
    @{
        Name = "OpenJDK 24";
        Url = "https://download.java.net/openjdk/jdk24/ri/openjdk-24+36_windows-x64_bin.zip";
        FileName = "openjdk-24+36_windows-x64_bin.zip";
        Type = "JDK";
        Version = "24";
    },
    @{
        Name = "OpenJFX 24";
        Url = "https://download.java.net/java/GA/javafx24/bde9f846c551418e80e98679ef280c36/29/openjfx-24_windows-x64_bin-sdk.zip";
        FileName = "openjfx-24_windows-x64_bin-sdk.zip";
        Type = "JavaFX";
        Version = "24";
    },
    @{
        Name = "OpenJDK 22 JExtract";
        Url = "https://download.java.net/java/early_access/jextract/22/6/openjdk-22-jextract+6-47_windows-x64_bin.tar.gz";
        FileName = "openjdk-22-jextract+6-47_windows-x64_bin.tar.gz";
        Type = "JExtract";
        Version = "22";
    },
    @{
        Name = "OpenJFX 23.0.2";
        Url = "https://download.java.net/java/GA/javafx23.0.2/512f2f157741485abda37a0a95f69984/3/openjfx-23.0.2_windows-x64_bin-sdk.zip";
        FileName = "openjfx-23.0.2_windows-x64_bin-sdk.zip";
        Type = "JavaFX";
        Version = "23.0.2";
    },
    @{
        Name = "Apache Maven 3.9.9";
        Url = "https://dlcdn.apache.org/maven/maven-3/3.9.9/source/apache-maven-3.9.9-src.zip";
        FileName = "apache-maven-3.9.9-src.zip";
        Type = "Maven";
        Version = "3.9.9";
    },
    @{
        Name = "IntelliJ Toolbox";
        Url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.exe";
        FileName = "jetbrains-toolbox-1.28.1.15219.exe";
        Type = "IntelliJ";
        Version = "latest";
    }
)

# Download all files
function Download-Files {
    Write-Host "`n[Downloading Files]" -ForegroundColor Cyan
    
    foreach ($download in $DownloadList) {
        $filePath = Join-Path -Path $DownloadDir -ChildPath $download.FileName
        
        if (-not (Test-Path $filePath)) {
            Write-Host "Downloading $($download.Name)..." -ForegroundColor Yellow
            try {
                Invoke-WebRequest -Uri $download.Url -OutFile $filePath
                Write-Host "Downloaded $($download.Name) successfully." -ForegroundColor Green
            } catch {
                Write-Host "Failed to download $($download.Name): $_" -ForegroundColor Red
            }
        } else {
            Write-Host "$($download.Name) already downloaded." -ForegroundColor Green
        }
    }
}

# Function to extract ZIP files
function Extract-ZipFile {
    param (
        [string]$zipFile,
        [string]$destination
    )
    
    try {
        Expand-Archive -Path $zipFile -DestinationPath $destination -Force
        return $true
    } catch {
        Write-Host "Error extracting $zipFile using built-in Expand-Archive: $_" -ForegroundColor Yellow
        
        # Try with 7-Zip if available
        if (Test-Path $SevenZipPath) {
            try {
                & $SevenZipPath x "$zipFile" -o"$destination" -y | Out-Null
                return $true
            } catch {
                Write-Host "Error extracting $zipFile using 7-Zip: $_" -ForegroundColor Red
                return $false
            }
        } else {
            return $false
        }
    }
}

# Function to extract TAR.GZ files (requires 7-Zip)
function Extract-TarGzFile {
    param (
        [string]$tarGzFile,
        [string]$destination
    )
    
    if (-not (Test-Path $SevenZipPath)) {
        Write-Host "7-Zip not found. Cannot extract tar.gz file: $tarGzFile" -ForegroundColor Red
        return $false
    }
    
    try {
        $tempDir = "$TempDir\$(New-Guid)"
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
        
        # Extract tar.gz to temporary directory (first pass extracts the tar file)
        & $SevenZipPath x "$tarGzFile" -o"$tempDir" -y | Out-Null
        
        # Get the tar file from the temporary directory
        $tarFile = Get-ChildItem -Path $tempDir -Filter "*.tar" | Select-Object -First 1
        
        if ($tarFile) {
            # Extract the tar file to destination
            & $SevenZipPath x "$($tarFile.FullName)" -o"$destination" -y | Out-Null
            Remove-Item -Path $tempDir -Recurse -Force
            return $true
        } else {
            Write-Host "No .tar file found after extracting: $tarGzFile" -ForegroundColor Red
            Remove-Item -Path $tempDir -Recurse -Force
            return $false
        }
    } catch {
        Write-Host "Error extracting $tarGzFile: $_" -ForegroundColor Red
        return $false
    }
}

# Install all the downloaded software
function Install-Software {
    Write-Host "`n[Installing Software]" -ForegroundColor Cyan
    
    # Maps to store installation paths
    $JavaJDKPaths = @{}
    $JavaFXPaths = @{}
    $MavenPath = ""
    
    foreach ($download in $DownloadList) {
        $filePath = Join-Path -Path $DownloadDir -ChildPath $download.FileName
        
        if (-not (Test-Path $filePath)) {
            Write-Host "File not found: $filePath. Skipping installation of $($download.Name)." -ForegroundColor Red
            continue
        }
        
        Write-Host "Installing $($download.Name)..." -ForegroundColor Yellow
        
        # Handle different types of software
        switch ($download.Type) {
            "JDK" {
                $targetDir = "$JavaDir\jdk-$($download.Version)"
                New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
                
                $extractSuccess = Extract-ZipFile -zipFile $filePath -destination $targetDir
                
                if ($extractSuccess) {
                    # JDK extraction typically creates a nested directory
                    $jdkDir = Get-ChildItem -Path $targetDir -Directory | Where-Object { $_.Name -like "jdk-*" -or $_.Name -like "openjdk-*" } | Select-Object -First 1
                    
                    if ($jdkDir) {
                        # Move all contents from nested directory to parent
                        $jdkContents = Get-ChildItem -Path $jdkDir.FullName
                        foreach ($item in $jdkContents) {
                            Move-Item -Path $item.FullName -Destination $targetDir -Force
                        }
                        Remove-Item -Path $jdkDir.FullName -Force -Recurse
                    }
                    
                    $JavaJDKPaths[$download.Version] = $targetDir
                    Write-Host "Installed $($download.Name) to $targetDir" -ForegroundColor Green
                } else {
                    Write-Host "Failed to extract $($download.Name)" -ForegroundColor Red
                }
            }
            "JavaFX" {
                $targetDir = "$JavaDir\javafx-$($download.Version)"
                New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
                
                $extractSuccess = Extract-ZipFile -zipFile $filePath -destination $targetDir
                
                if ($extractSuccess) {
                    # JavaFX extraction typically creates a nested directory
                    $jfxDir = Get-ChildItem -Path $targetDir -Directory | Where-Object { $_.Name -like "javafx-sdk*" } | Select-Object -First 1
                    
                    if ($jfxDir) {
                        # Move all contents from nested directory to parent
                        $jfxContents = Get-ChildItem -Path $jfxDir.FullName
                        foreach ($item in $jfxContents) {
                            Move-Item -Path $item.FullName -Destination $targetDir -Force
                        }
                        Remove-Item -Path $jfxDir.FullName -Force -Recurse
                    }
                    
                    $JavaFXPaths[$download.Version] = $targetDir
                    Write-Host "Installed $($download.Name) to $targetDir" -ForegroundColor Green
                } else {
                    Write-Host "Failed to extract $($download.Name)" -ForegroundColor Red
                }
            }
            "JExtract" {
                $targetDir = "$JavaDir\jextract-$($download.Version)"
                New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
                
                $extractSuccess = Extract-TarGzFile -tarGzFile $filePath -destination $targetDir
                
                if ($extractSuccess) {
                    # JExtract extraction typically creates a nested directory
                    $jextractDir = Get-ChildItem -Path $targetDir -Directory | Where-Object { $_.Name -like "jextract*" -or $_.Name -like "openjdk*" } | Select-Object -First 1
                    
                    if ($jextractDir) {
                        # Move all contents from nested directory to parent
                        $jextractContents = Get-ChildItem -Path $jextractDir.FullName
                        foreach ($item in $jextractContents) {
                            Move-Item -Path $item.FullName -Destination $targetDir -Force
                        }
                        Remove-Item -Path $jextractDir.FullName -Force -Recurse
                    }
                    
                    Write-Host "Installed $($download.Name) to $targetDir" -ForegroundColor Green
                } else {
                    Write-Host "Failed to extract $($download.Name)" -ForegroundColor Red
                }
            }
            "Maven" {
                $targetDir = "$MavenDir\apache-maven-$($download.Version)"
                New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
                
                $extractSuccess = Extract-ZipFile -zipFile $filePath -destination $targetDir
                
                if ($extractSuccess) {
                    # Maven extraction typically creates a nested directory
                    $mavenDir = Get-ChildItem -Path $targetDir -Directory | Where-Object { $_.Name -like "apache-maven*" } | Select-Object -First 1
                    
                    if ($mavenDir) {
                        # Move all contents from nested directory to parent
                        $mavenContents = Get-ChildItem -Path $mavenDir.FullName
                        foreach ($item in $mavenContents) {
                            Move-Item -Path $item.FullName -Destination $targetDir -Force
                        }
                        Remove-Item -Path $mavenDir.FullName -Force -Recurse
                    }
                    
                    $MavenPath = $targetDir
                    Write-Host "Installed $($download.Name) to $targetDir" -ForegroundColor Green
                    
                    # For source distributions, need to build using Maven
                    if ($filePath -like "*-src.zip") {
                        Write-Host "Maven source distribution detected. Building Maven..." -ForegroundColor Yellow
                        $buildCmd = "cd $targetDir && mvn clean install -DskipTests"
                        Invoke-Expression $buildCmd
                    }
                } else {
                    Write-Host "Failed to extract $($download.Name)" -ForegroundColor Red
                }
            }
            "IntelliJ" {
                try {
                    Start-Process -FilePath $filePath -ArgumentList "/S" -Wait
                    Write-Host "Installed $($download.Name) successfully" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to install $($download.Name): $_" -ForegroundColor Red
                }
            }
        }
    }
    
    # Return the installation paths
    return @{
        JavaJDKPaths = $JavaJDKPaths
        JavaFXPaths = $JavaFXPaths
        MavenPath = $MavenPath
    }
}

# Set up environment variables
function Setup-EnvironmentVariables {
    param (
        [hashtable]$InstallPaths
    )
    
    Write-Host "`n[Setting Up Environment Variables]" -ForegroundColor Cyan
    
    $JavaJDKPaths = $InstallPaths.JavaJDKPaths
    $JavaFXPaths = $InstallPaths.JavaFXPaths
    $MavenPath = $InstallPaths.MavenPath
    
    # Set JAVA_HOME to Java 17 if available
    if ($JavaJDKPaths.ContainsKey("17")) {
        [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $JavaJDKPaths["17"], [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Set JAVA_HOME to Java 17: $($JavaJDKPaths['17'])" -ForegroundColor Green
    } else {
        # Use the latest Java version available
        $latestJava = $JavaJDKPaths.Keys | ForEach-Object { [int]$_ } | Sort-Object -Descending | Select-Object -First 1
        if ($latestJava) {
            [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $JavaJDKPaths["$latestJava"], [System.EnvironmentVariableTarget]::Machine)
            Write-Host "Java 17 not found. Set JAVA_HOME to Java $latestJava: $($JavaJDKPaths["$latestJava"])" -ForegroundColor Yellow
        } else {
            Write-Host "No Java JDK found. JAVA_HOME not set." -ForegroundColor Red
        }
    }
    
    # Set environment variables for all Java versions
    foreach ($version in $JavaJDKPaths.Keys) {
        [System.Environment]::SetEnvironmentVariable("JAVA${version}_HOME", $JavaJDKPaths[$version], [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Set JAVA${version}_HOME to $($JavaJDKPaths[$version])" -ForegroundColor Green
    }
    
    # Set environment variables for all JavaFX versions
    foreach ($version in $JavaFXPaths.Keys) {
        [System.Environment]::SetEnvironmentVariable("PATH_TO_FX_$version", "$($JavaFXPaths[$version])\lib", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Set PATH_TO_FX_$version to $($JavaFXPaths[$version])\lib" -ForegroundColor Green
    }
    
    # If we have a JavaFX version, create a default PATH_TO_FX variable
    if ($JavaFXPaths.Count -gt 0) {
        $jfxKeys = $JavaFXPaths.Keys | Sort-Object -Descending
        $latestJavaFX = $jfxKeys[0]
        [System.Environment]::SetEnvironmentVariable("PATH_TO_FX", "$($JavaFXPaths[$latestJavaFX])\lib", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Set default PATH_TO_FX to JavaFX $latestJavaFX: $($JavaFXPaths[$latestJavaFX])\lib" -ForegroundColor Green
    }
    
    # Set Maven environment variables if Maven was installed
    if ($MavenPath -and (Test-Path $MavenPath)) {
        [System.Environment]::SetEnvironmentVariable("M2_HOME", $MavenPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Set M2_HOME to $MavenPath" -ForegroundColor Green
    }
    
    # Update PATH environment variable
    $Path = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
    $PathUpdated = $false
    
    # Add all Java bin directories to PATH
    foreach ($jdkPath in $JavaJDKPaths.Values) {
        $JavaBinPath = "$jdkPath\bin"
        if (-not $Path.Contains($JavaBinPath)) {
            $Path = "$Path;$JavaBinPath"
            $PathUpdated = $true
        }
    }
    
    # Add Maven bin to PATH if available
    if ($MavenPath -and (Test-Path $MavenPath)) {
        $MavenBinPath = "$MavenPath\bin"
        if (-not $Path.Contains($MavenBinPath)) {
            $Path = "$Path;$MavenBinPath"
            $PathUpdated = $true
        }
    }
    
    # Update PATH if changed
    if ($PathUpdated) {
        [System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Updated PATH environment variable" -ForegroundColor Green
    }
}

# Clean up temporary files
function Cleanup {
    param (
        [switch]$RemoveDownloads
    )
    
    Write-Host "`n[Cleanup]" -ForegroundColor Cyan
    
    # Always clean up temp directory
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned up temporary directory" -ForegroundColor Green
    }
    
    # Optionally remove downloads
    if ($RemoveDownloads -and (Test-Path $DownloadDir)) {
        Remove-Item -Path $DownloadDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed download directory" -ForegroundColor Green
    }
}

# Verify installations
function Verify-Installations {
    param (
        [hashtable]$InstallPaths
    )
    
    Write-Host "`n[Verifying Installations]" -ForegroundColor Cyan
    
    $JavaJDKPaths = $InstallPaths.JavaJDKPaths
    $JavaFXPaths = $InstallPaths.JavaFXPaths
    $MavenPath = $InstallPaths.MavenPath
    
    # Refresh environment variables for current session
    if ($JavaJDKPaths.ContainsKey("17")) {
        $env:JAVA_HOME = $JavaJDKPaths["17"]
    } elseif ($JavaJDKPaths.Count -gt 0) {
        $latestJava = $JavaJDKPaths.Keys | ForEach-Object { [int]$_ } | Sort-Object -Descending | Select-Object -First 1
        $env:JAVA_HOME = $JavaJDKPaths["$latestJava"]
    }
    
    # Update path for current session
    foreach ($jdkPath in $JavaJDKPaths.Values) {
        $env:Path = "$jdkPath\bin;$env:Path"
    }
    
    if ($MavenPath -and (Test-Path $MavenPath)) {
        $env:M2_HOME = $MavenPath
        $env:Path = "$MavenPath\bin;$env:Path"
    }
    
    # Test Java
    try {
        $JavaVersion = & java -version 2>&1
        Write-Host "Java Version: $JavaVersion" -ForegroundColor Green
    } catch {
        Write-Host "Failed to verify Java installation: $_" -ForegroundColor Red
    }
    
    # Test Maven
    if ($MavenPath -and (Test-Path $MavenPath)) {
        try {
            $MavenVersion = & mvn -version
            Write-Host "Maven Version: $MavenVersion" -ForegroundColor Green
        } catch {
            Write-Host "Failed to verify Maven installation: $_" -ForegroundColor Red
        }
    }
}

# Display summary of installations
function Display-Summary {
    param (
        [hashtable]$InstallPaths
    )
    
    Write-Host "`n[Installation Summary]" -ForegroundColor Cyan
    
    $JavaJDKPaths = $InstallPaths.JavaJDKPaths
    $JavaFXPaths = $InstallPaths.JavaFXPaths
    $MavenPath = $InstallPaths.MavenPath
    
    # Summary of Java versions installed
    if ($JavaJDKPaths.Count -gt 0) {
        Write-Host "`nJava JDK Versions Installed:" -ForegroundColor Green
        foreach ($version in $JavaJDKPaths.Keys | Sort-Object) {
            Write-Host "  Java $version: $($JavaJDKPaths[$version])"
        }
    } else {
        Write-Host "`nNo Java JDK versions were installed." -ForegroundColor Yellow
    }
    
    # Summary of JavaFX versions installed
    if ($JavaFXPaths.Count -gt 0) {
        Write-Host "`nJavaFX Versions Installed:" -ForegroundColor Green
        foreach ($version in $JavaFXPaths.Keys | Sort-Object) {
            Write-Host "  JavaFX $version: $($JavaFXPaths[$version])"
            Write-Host "    Environment Variable: PATH_TO_FX_$version = $($JavaFXPaths[$version])\lib"
        }
        
        $jfxKeys = $JavaFXPaths.Keys | Sort-Object -Descending
        $latestJavaFX = $jfxKeys[0]
        Write-Host "`nDefault JavaFX (PATH_TO_FX): JavaFX $latestJavaFX at $($JavaFXPaths[$latestJavaFX])\lib"
    } else {
        Write-Host "`nNo JavaFX versions were installed." -ForegroundColor Yellow
    }
    
    # Maven summary
    if ($MavenPath -and (Test-Path $MavenPath)) {
        Write-Host "`nMaven installed at: $MavenPath" -ForegroundColor Green
        Write-Host "  Environment Variable: M2_HOME = $MavenPath"
    } else {
        Write-Host "`nMaven was not installed successfully." -ForegroundColor Yellow
    }
    
    # Primary Java Home
    if ($JavaJDKPaths.ContainsKey("17")) {
        Write-Host "`nPrimary Java Version (JAVA_HOME): Java 17 at $($JavaJDKPaths['17'])" -ForegroundColor Green
    } elseif ($JavaJDKPaths.Count -gt 0) {
        $latestJava = $JavaJDKPaths.Keys | ForEach-Object { [int]$_ } | Sort-Object -Descending | Select-Object -First 1
        Write-Host "`nPrimary Java Version (JAVA_HOME): Java $latestJava at $($JavaJDKPaths["$latestJava"])" -ForegroundColor Yellow
    }
    
    Write-Host "`nIntelliJ Toolbox has been installed. You can find it in your Start menu."
    Write-Host "`nInstallation completed successfully!" -ForegroundColor Green
    Write-Host "You may need to restart your computer for all environment variables to take effect." -ForegroundColor Yellow
}

# Main script execution
function Main {
    param (
        [switch]$RemoveDownloads = $false
    )
    
    Write-Host "Java Development Environment Setup" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Green
    
    # Check if running as administrator
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "This script needs to be run as Administrator for best results." -ForegroundColor Red
        $proceed = Read-Host "Do you want to continue anyway? (Y/N)"
        if ($proceed -ne "Y") {
            exit
        }
    }
    
    # Execute all functions in sequence
    Create-Directories
    Ensure-7Zip
    Download-Files
    $InstallPaths = Install-Software
    Setup-EnvironmentVariables -InstallPaths $InstallPaths
    Verify-Installations -InstallPaths $InstallPaths
    Display-Summary -InstallPaths $InstallPaths
    Cleanup -RemoveDownloads:$RemoveDownloads
}

# Run the main function (set to $true to remove downloads after installation)
Main -RemoveDownloads:$fals
