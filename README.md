# Debloat-Win10-One-Click 

## Original Project from [W4RH4WK](https://github.com/W4RH4WK/Debloat-Windows-10)

This project collects PowerShell scripts which help to *debloat* Windows 10,
tweak common settings and install basic software components.

I test these scripts on a Windows 10 Professional 64-Bit (English/Brazilian) virtual
machine. Please let me know if you encounter any issues. Home Edition and
different languages are not supported. These scripts are intended for
tech-savvy administrators, who know what they are doing and just want to
automate this phase of their setup. If this profile does not fit you, I
recommend using a different (more interactive) tool -- and there are a lot of
them out there.

Also, note that gaming-related apps and services will be removed/disabled. If
you intend to use your system for gaming, adjust the scripts accordingly.

**There is (maybe) a undo**, because i did a restoration point script before 
doing everything.
I recommend only using these scripts on a fresh
installation (including Windows Updates). Test everything after running them
before doing anything else. Also, there is no guarantee that everything will
work after future updates since I cannot predict what Microsoft will do next.

## Interactivity

The scripts are designed to run without any user interaction. Modify them
beforehand. If you want a more interactive approach check out
- [DisableWinTracking](https://github.com/10se1ucgo/DisableWinTracking) from
[10se1ucgo](https://github.com/10se1ucgo).
- [Windows10Debloater](https://github.com/Sycnex/Windows10Debloater) from [Sycnex](https://github.com/Sycnex).
- [win10script](https://github.com/ChrisTitusTech/win10script) from [ChrisTitusTech](https://github.com/ChrisTitusTech).

## Download Latest Version

Code located in the `master` branch is always considered under development, but
you'll probably want the most recent version anyway.

- [Download [zip]](https://github.com/LeDragoX/Debloat-Windows-10-One-Click/archive/master.zip)

## Execution
If the `Script-Win10.bat` do not make that automatically, follow these steps.

Enable execution of PowerShell scripts:

    PS> Set-ExecutionPolicy Unrestricted -Scope CurrentUser

Unblock PowerShell scripts and modules within this directory:

    PS> ls -Recurse *.ps*1 | Unblock-File

## Usage

Scripts can be run individually, pick what you need.

1. Install all available updates for your system.
2. Edit the scripts to fit your need.
3. Run the scripts you want to apply from a PowerShell with administrator privileges (Explorer
   `Files > Open Windows PowerShell > Open Windows PowerShell as
   administrator`)
4. `PS > Restart-Computer`
5. Run `disable-windows-defender.ps1` one more time if you ran it in step 3
6. `PS > Restart-Computer`

## Start menu

In the past I included small fixes to make the start menu more usable, like
removing default tiles, disabling web search and so on. This is no longer the
case since I am fed up with it. This fucking menu breaks for apparently
no reason, is slow, is a pain to configure / script and even shows ads out of
the box!

Please replace it with something better, either use [Open Shell] or [Start
is Back], but stop using that shit.

[Open Shell]: <https://open-shell.github.io/Open-Shell-Menu/>
[Start is Back]: <http://startisback.com/>

## Known Issues

### Start menu Search

After running the scripts, the start menu search-box may no longer work on newly
created accounts. It seems like there is an issue with account initialization
that is triggered when disabling the GeoLocation service. Following workaround
has been discovered by BK from Atlanta:

1. Delete registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc\TriggerInfo\3`
2. Re-enable GeoLocation service (set startup type to `Automatic`)
3. Reboot
4. Login with the account having the stated issue
5. Start Cortana and set your preferences accordingly (web search and whatnot)

You may now disable the GeoLocation service again, the search box should remain
functional.

### Sysprep will hang

If you are deploying images with MDT and running these scripts, the sysprep
step will hang unless `dmwappushserivce` is active.

### Xbox Wireless Adapter

Apparently running the stock `remove-default-apps` script will cause Xbox
Wireless Adapters to stop functioning. I suspect one should not remove the Xbox
App when wanting to use one. But I haven't confirmed this yet, and there is a
workaround to re-enable it afterwards. See
[#78](https://github.com/W4RH4WK/Debloat-Windows-10/issues/78).

### Issues with Skype

Some of the domains blocked by adding them to the hosts-file are required for
Skype. I highly discourage using Skype, however some people may not have
the option to use an alternative. See the
[#79](https://github.com/W4RH4WK/Debloat-Windows-10/issues/79).

### Fingerprint Reader / Facial Detection not Working

Ensure *Windows Biometric Service* is running. See
[#189](https://github.com/W4RH4WK/Debloat-Windows-10/issues/189).

## Liability

**All scripts are provided as-is and you use them at your own risk.**

## Contribute

I would be happy to extend the collection of scripts. Just open an issue or
send me a pull request.

### Thanks To

- [10se1ucgo](https://github.com/10se1ucgo)
- [Plumebit](https://github.com/Plumebit)
- [aramboi](https://github.com/aramboi)
- [maci0](https://github.com/maci0)
- [narutards](https://github.com/narutards)
- [tumpio](https://github.com/tumpio)

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
