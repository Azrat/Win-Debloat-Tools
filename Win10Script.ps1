Function QuickPrivilegesElevation {
    # Used from https://stackoverflow.com/a/31602095 because it preserves the working directory!
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
}

Function LoadLibs {

    Write-Host "Current Script Folder $PSScriptRoot"
    Write-Host ""
    Push-Location $PSScriptRoot
	
    Push-Location -Path .\lib
        Get-ChildItem -Recurse *.ps*1 | Unblock-File
    Pop-Location

    #Import-Module -DisableNameChecking $PSScriptRoot\lib\"Check-OS-Info.psm1"		# Not Used
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Count-N-Seconds.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Set-Script-Policy.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Setup-Console-Style.psm1" # Make the Console look how i want
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Simple-Message-Box.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Title-Templates.psm1"

}

Function PromptPcRestart {

    $Ask = "If you want to see the changes restart your computer!
    Do you want to Restart now?"
    
    switch (ShowQuestion -Title "Read carefully" -Message $Ask) {
        'Yes' {
            Write-Host "You choose Yes."
            Restart-Computer        
        }
        'No' {
            Write-Host "You choose to Restart later"
            Write-Host "You choose No. (No = Cancel)"
        }
        'Cancel' { # With Yes, No and Cancel, the user can press Esc to exit
            Write-Host "You choose to Restart later"
            Write-Host "You choose Cancel. (Cancel = No)"
        }
    }
    
}

Function RunScripts {

    Push-Location -Path .\scripts

        Get-ChildItem -Recurse *.ps*1 | Unblock-File
        
        Clear-Host
        $Scripts = @(
            # [Recommended order] List of Scripts
            "backup-system.ps1"
            "silent-debloat-softwares.ps1"
            "optimize-scheduled-tasks.ps1"
            "optimize-services.ps1"
            "remove-bloatware-apps.ps1"
            "optimize-privacy-and-performance.ps1"
            "personal-optimizations.ps1"
            "optimize-security.ps1"
            "enable-optional-features.ps1"
            "remove-onedrive.ps1"
            "manual-debloat-softwares.ps1"
        )
        
        ForEach ($FileName in $Scripts) {
            Title2Counter -Text "$FileName" -MaxNum $Scripts.Length
            PowerShell -NoProfile -ExecutionPolicy Bypass -file .\"$FileName"
            # pause ### FOR DEBUGGING PURPOSES
        }

        $Ask = "This part is OPTIONAL, only do this if you want to repair your Windows.
        Do you want to continue?"

        switch (ShowQuestion -Title "Read carefully" -Message $Ask) {
            'Yes' {
                Write-Host "You choose Yes."

                $Scripts = @(
                    # [Recommended order] List of Scripts
                    "repair-windows.ps1"
                )
                ForEach ($FileName in $Scripts) {
                    Title2 -Text "$FileName"
                    PowerShell -NoProfile -ExecutionPolicy Bypass -file .\"$FileName"
                    # pause ### FOR DEBUGGING PURPOSES
                }
            }
            'No' {
                Write-Host "You choose No. (No = Cancel)"
            }
            'Cancel' { # With Yes, No and Cancel, the user can press Esc to exit
                Write-Host "You choose Cancel. (Cancel = No)"
            }
        }

    Pop-Location
}

Function Credits {

    Clear-Host
    Write-Host "<=========================================================================================>"
    Write-Host "        Improve and Optimize Windows 10 (Made by Plínio Larrubia A.K.A. LeDragoX)"
    Write-Host "<=========================================================================================>"
    Write-Host ""
    
}

# Your script here

QuickPrivilegesElevation    # Check admin rights
LoadLibs                    # Import modules from lib folder
UnrestrictPermissions       # Unlock script usage
SetupConsoleStyle           # Just fix the font on the PS console
Write-Host ""
RunScripts                  # Run all scripts inside 'scripts' folder
Write-Host ""
RestrictPermissions         # Lock script usage
Write-Host ""

PromptPcRestart             # Prompt options to Restart the PC

Credits
CountNseconds               # Count 3 seconds (default) then exit
Taskkill /F /IM $PID        # Kill this task by PID because it won't exit with the command 'exit'