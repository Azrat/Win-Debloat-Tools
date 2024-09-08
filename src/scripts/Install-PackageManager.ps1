Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"Get-HardwareInfo.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"Get-TempScriptFolder.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"Request-FileDownload.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"Title-Templates.psm1"

# Adapted from: https://github.com/ChrisTitusTech/win10script/blob/master/win10debloat.ps1
# Adapted from: https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/utils/install-basic-software.ps1

function Install-PackageManager() {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [String]	  $PackageManagerFullName,
        [Parameter(Position = 1, Mandatory)]
        [ScriptBlock] $CheckExistenceBlock,
        [Parameter(Position = 2, Mandatory)]
        [ScriptBlock] $InstallCommandBlock,
        [String]      $Time,
        [ScriptBlock] $UpdateScriptBlock,
        [ScriptBlock] $PostInstallBlock
    )

    Try {
        $Err = (Invoke-Expression "$CheckExistenceBlock")
        If (($LASTEXITCODE)) { throw $Err } # 0 = False, 1 = True
        Write-Status -Types "?", $PackageManagerFullName -Status "$PackageManagerFullName is already installed." -Warning
    } Catch {
        Write-Status -Types "?", $PackageManagerFullName -Status "$PackageManagerFullName was not found." -Warning
        Write-Status -Types "+", $PackageManagerFullName -Status "Downloading and Installing $PackageManagerFullName package manager."

        Invoke-Expression "$InstallCommandBlock"

        If ($PostInstallBlock) {
            Write-Status -Types "+", $PackageManagerFullName -Status "Executing post install script: { $("$PostInstallBlock".Trim(' ')) }."
            Invoke-Expression "$PostInstallBlock"
        }
    }

    # Self-reminder, this part stay out of the Try-Catch block
    If ($UpdateScriptBlock) {
        # Adapted from: https://blogs.technet.microsoft.com/heyscriptingguy/2013/11/23/using-scheduled-tasks-and-scheduled-jobs-in-powershell/
        Write-Status -Types "@", $PackageManagerFullName -Status "Creating a daily task to automatically upgrade $PackageManagerFullName packages at $Time."
        $JobName = "$PackageManagerFullName Daily Upgrade"
        $ScheduledJob = @{
            Name               = $JobName
            ScriptBlock        = $UpdateScriptBlock
            Trigger            = New-JobTrigger -Daily -At $Time
            ScheduledJobOption = New-ScheduledJobOption -RunElevated -MultipleInstancePolicy StopExisting -RequireNetwork
        }

        If ((Get-ScheduledTask -TaskName $JobName -ErrorAction SilentlyContinue) -or (Get-ScheduledJob -Name $JobName -ErrorAction SilentlyContinue)) {
            Write-Status -Types "@", $PackageManagerFullName -Status "ScheduledJob: $JobName FOUND!"
            Write-Status -Types "@", $PackageManagerFullName -Status "Re-Creating with the command:"
            Write-Host " { $("$UpdateScriptBlock".Trim(' ')) }`n" -ForegroundColor Cyan
            Stop-ScheduledTask -TaskPath "\Microsoft\Windows\PowerShell\ScheduledJobs" -TaskName $JobName
            Unregister-ScheduledJob -Name $JobName
            Register-ScheduledJob @ScheduledJob | Out-Null
        } Else {
            Write-Status -Types "@", $PackageManagerFullName -Status "Creating Scheduled Job with the command:"
            Write-Host " { $("$UpdateScriptBlock".Trim(' ')) }`n" -ForegroundColor Cyan
            Register-ScheduledJob @ScheduledJob | Out-Null
        }
    }
}

function Install-WingetDependency() {
    # Dependency for Winget: https://docs.microsoft.com/en-us/troubleshoot/developer/visualstudio/cpp/libraries/c-runtime-packages-desktop-bridge#how-to-install-and-update-desktop-framework-packages
    $OSArchList = Get-OSArchitecture

    ForEach ($OSArch in $OSArchList) {
        If ($OSArch -like "x64" -or "x86" -or "arm64" -or "arm") {
            $WingetDepOutput = Request-FileDownload -FileURI "https://aka.ms/Microsoft.VCLibs.$OSArch.14.00.Desktop.appx" -OutputFile "Microsoft.VCLibs.14.00.Desktop.appx"
            $AppName = Split-Path -Path $WingetDepOutput -Leaf

            Try {
                Write-Status -Types "@" -Status "Trying to install the App: $AppName" -Warning
                $InstallPackageCommand = { Add-AppxPackage -Path $WingetDepOutput }
                Invoke-Expression "$InstallPackageCommand"
                If ($LASTEXITCODE) { Throw "Couldn't install automatically" }
            } Catch {
                Write-Status -Types "@" -Status "Couldn't install '$AppName' automatically, trying to install the App manually..." -Warning
                Start-Process -FilePath $WingetDepOutput
                $AppInstallerId = (Get-Process AppInstaller).Id
                Wait-Process -Id $AppInstallerId
            }

            Return $WingetDepOutput
        } Else {
            Write-Status -Types "?" -Status "$OSArch is not supported!" -Warning
        }
    }

    Return $false
}

$WingetParams = @{
    Name                = "Winget"
    CheckExistenceBlock = { winget --version }
    InstallCommandBlock =
    {
        New-Item -Path "$(Get-TempScriptFolder)\downloads\" -Name "winget-install" -ItemType Directory -Force | Out-Null
        Push-Location -Path "$(Get-TempScriptFolder)\downloads\winget-install\"
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        Install-Script -Name winget-install -Force
        winget-install.ps1
        Pop-Location
        Remove-Item -Path "$(Get-TempScriptFolder)\downloads\winget-install\"
    }
    Time                = "12:00"
    UpdateScriptBlock   =
    {
        Remove-Item -Path "$env:TEMP\Win-Debloat-Tools\logs\*" -Include "WingetDailyUpgrade_*.log"
        Start-Transcript -Path "$env:TEMP\Win-Debloat-Tools\logs\WingetDailyUpgrade_$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss").log"
        Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force # Only needed to run Winget
        winget source update --disable-interactivity | Out-Host
        winget upgrade --all --silent | Out-Host
        Stop-Transcript
    }
}

$WingetParams2 = @{
    Name                = "Winget (Method 2)"
    CheckExistenceBlock = { winget --version }
    InstallCommandBlock =
    {
        $WingetDepOutput = Install-WingetDependency
        $WingetOutput = Get-APIFile -URI "https://api.github.com/repos/microsoft/winget-cli/releases/latest" -ObjectProperty "assets" -FileNameLike "*.msixbundle" -PropertyValue "browser_download_url" -OutputFile "Microsoft.DesktopAppInstaller.msixbundle"
        $AppName = Split-Path -Path $WingetOutput -Leaf

        Try {
            # Method from: https://github.com/microsoft/winget-cli/blob/master/doc/troubleshooting/README.md#machine-wide-provisioning
            If ($WingetDepOutput) {
                Write-Status -Types "@" -Status "Trying to install the App (w/ dependency): $AppName" -Warning
                $InstallPackageCommand = { Add-AppxProvisionedPackage -Online -PackagePath $WingetOutput -SkipLicense -DependencyPackagePath $WingetDepOutput | Out-Null }
                Invoke-Expression "$InstallPackageCommand"
            }

            Write-Status -Types "@" -Status "Trying to install the App (no dependency): $AppName" -Warning
            $InstallPackageCommand = { Add-AppxProvisionedPackage -Online -PackagePath $WingetOutput -SkipLicense | Out-Null }
            Invoke-Expression "$InstallPackageCommand"
        } Catch {
            Write-Status -Types "@" -Status "Couldn't install '$AppName' automatically, trying to install the App manually..." -Warning
            Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1" -Wait # GUI App installer can't install itself
        }

        Remove-Item -Path $WingetOutput
        Remove-Item -Path $WingetDepOutput
    }
}

$ChocolateyParams = @{
    Name                = "Chocolatey"
    CheckExistenceBlock = { choco --version }
    InstallCommandBlock =
    {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    Time                = "13:00"
    UpdateScriptBlock   =
    {
        Remove-Item -Path "$env:TEMP\Win-Debloat-Tools\logs\*" -Include "ChocolateyDailyUpgrade_*.log"
        Start-Transcript -Path "$env:TEMP\Win-Debloat-Tools\logs\ChocolateyDailyUpgrade_$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss").log"
        choco upgrade all --ignore-dependencies --yes | Out-Host
        Stop-Transcript
    }
    PostInstallBlock    = { choco install --ignore-dependencies --yes "chocolatey-core.extension" "chocolatey-fastanswers.extension" "dependency-windows10" }
}

# Install Winget on Windows (Method 1)
Install-PackageManager -PackageManagerFullName $WingetParams.Name -CheckExistenceBlock $WingetParams.CheckExistenceBlock -InstallCommandBlock $WingetParams.InstallCommandBlock -Time $WingetParams.Time -UpdateScriptBlock $WingetParams.UpdateScriptBlock
# Install Winget on Windows (Method 2)
Install-PackageManager -PackageManagerFullName $WingetParams2.Name -CheckExistenceBlock $WingetParams2.CheckExistenceBlock -InstallCommandBlock $WingetParams2.InstallCommandBlock
# Install Chocolatey on Windows
Install-PackageManager -PackageManagerFullName $ChocolateyParams.Name -CheckExistenceBlock $ChocolateyParams.CheckExistenceBlock -InstallCommandBlock $ChocolateyParams.InstallCommandBlock -Time $ChocolateyParams.Time -UpdateScriptBlock $ChocolateyParams.UpdateScriptBlock -PostInstallBlock $ChocolateyParams.PostInstallBlock

