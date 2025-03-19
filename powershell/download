# Define a hashtable to map names to download links
$downloads = @{
    "openjdk-17" = "https://download.java.net/openjdk/jdk17.0.0.1/ri/openjdk-17.0.0.1+2_windows-x64_bin.zip"
    "openjdk-21" = "https://download.java.net/openjdk/jdk21/ri/openjdk-21+35_windows-x64_bin.zip"
    "openjdk-24" = "https://download.java.net/openjdk/jdk24/ri/openjdk-24+36_windows-x64_bin.zip"
    "openjfx-24" = "https://download.java.net/java/GA/javafx24/bde9f846c551418e80e98679ef280c36/29/openjfx-24_windows-x64_bin-sdk.zip"
    "openjdk-23" = "https://download.java.net/java/GA/javafx23.0.2/512f2f157741485abda37a0a95f69984//3/openjfx-23.0.2_windows-x64_bin-sdk.zip"
    "maven" = "https://dlcdn.apache.org/maven/maven-3/3.9.9/source/apache-maven-3.9.9-src.zip"
    "jetbrains-toolbox" = "https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=windows"
}

# Iterate over the hashtable and download each file
foreach ($name in $downloads.Keys) {
    $url = $downloads[$name]
    $output = "$name.zip"
    Write-Output "Downloading $name from $url"
    Invoke-WebRequest -Uri $url -OutFile $output

    # Determine the extraction path based on the name
    if ($name -like "openjdk*" -or $name -like "openjfx*") {
        $extractPath = "C:\Program Files\Java\$name"
    } elseif ($name -eq "maven") {
        $extractPath = "C:\Program Files\Maven"
    } else {
        $extractPath = "C:\Program Files\$name"
    }

    # Create the directory if it doesn't exist
    if (-not (Test-Path -Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath
    }

    # Unzip the file to the specified directory
    Write-Output "Extracting $name to $extractPath"
    Expand-Archive -Path $output -DestinationPath $extractPath
}
