<h1>
e    <img width=40px src="https://cdn.icon-icons.com/icons2/843/PNG/512/Windows_icon-icons.com_67026.png"> DebloatWin10-OneClick 
    <img width=40px src="https://cdn.icon-icons.com/icons2/92/PNG/256/cmd_16549.png">
</h1>

## Original Project from [W4RH4WK](https://github.com/W4RH4WK/Debloat-Windows-10)

## Warning

==> **All scripts are provided as-is and you use them at your own risk.** <==

## Download Latest Version

Code located in the `master` branch is always considered under development, but
you'll probably want the most recent version anyway.

- [Download [zip]](https://github.com/LeDragoX/Debloat-Win10-One-Click/archive/master.zip)

## Resume

This project is a modified version of [another project](https://github.com/W4RH4WK/Debloat-Windows-10) 
that was made for debloat and tweak Windows 10 for better performance and less issues, 
i've done some changes so it won't annoy by unninstalled apps, and keeps stability for games and daily drive.

**There is (if works) a undo**, because i did a restoration point script before 
doing everything. 
**Use on a fresh windows install to note the differences, and if something breaks, 
you can rely on a pre-made restoration point.**

## Usage

This is kinda simple, on the `Script-Win10.ps1` file,
- Right click on it
- Select "Run with Powershell"
- Put your password and click yes, and there you go. 
But, if you're seeing errors, then stop and do whats in 
[**Execution**](https://github.com/LeDragoX/Debloat-Win10-One-Click#execution).

Scripts can be run individually, pick what you need.

## Execution
If the `Script-Win10.ps1` or `OLD-Script-Win10.bat` do not make that automatically, follow these steps.

Open the Powershell as admin and Enable execution of PowerShell scripts:

    PS> Set-ExecutionPolicy Unrestricted -Scope CurrentUser

Unblock PowerShell scripts and modules within this directory:

    PS> ls -Recurse *.ps*1 | Unblock-File

## Known Issues 

- ~Start menu Search~ (Fixed i think)
- ~Sysprep will hang~? (Don't know whats that)
- [~Xbox Wireless Adapter~](https://github.com/W4RH4WK/Debloat-Windows-10/issues/78) (Fixed)
- [Issues with Skype](https://github.com/W4RH4WK/Debloat-Windows-10/issues/79) (will be deleted)
- [Fingerprint Reader / Facial Detection not Working](https://github.com/W4RH4WK/Debloat-Windows-10/issues/189)
(I don't recommend using that)

## Contribute

I would be happy to extend the collection of scripts. 
Just open an issue or send me a pull request. (Yes, if its useful, you can).

### Thanks To

- [W4RH4WK](https://github.com/W4RH4WK) (For his project ^^)
- [10se1ucgo](https://github.com/10se1ucgo)
- [Plumebit](https://github.com/Plumebit)
- [aramboi](https://github.com/aramboi)
- [maci0](https://github.com/maci0)
- [narutards](https://github.com/narutards)
- [tumpio](https://github.com/tumpio)

## Interactivity

The scripts are designed to run without any user interaction. Modify them
beforehand. If you want a more interactive approach check out:
- [DisableWinTracking](https://github.com/10se1ucgo/DisableWinTracking) from [10se1ucgo](https://github.com/10se1ucgo).
- [Windows10Debloater](https://github.com/Sycnex/Windows10Debloater) from [Sycnex](https://github.com/Sycnex).
- [win10script](https://github.com/ChrisTitusTech/win10script) from [ChrisTitusTech](https://github.com/ChrisTitusTech).

## License

    "The Unlicense License"

    This is free and unencumbered software released into the public domain.

    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.

    In jurisdictions that recognize copyright laws, the author or authors
    of this software dedicate any and all copyright interest in the
    software to the public domain. We make this dedication for the benefit
    of the public at large and to the detriment of our heirs and
    successors. We intend this dedication to be an overt act of
    relinquishment in perpetuity of all present and future rights to this
    software under copyright law.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.

    For more information, please refer to <http://unlicense.org/>
