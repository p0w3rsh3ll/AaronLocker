
## What is AaronLocker?

> AaronLocker is designed to make the creation and maintenance of robust, strict, AppLocker-based whitelisting rules as easy and practical as possible. The entire solution involves a small number of PowerShell scripts. You can easily customize rules for your specific requirements with simple text-file edits. AaronLocker includes scripts that document AppLocker policies and capture event data into Excel workbooks that facilitate analysis and policy maintenance.

> AaronLocker is designed to restrict program and script execution by non-administrative users. Note that AaronLocker does not try to stop administrative users from running anything they want – and AppLocker cannot meaningfully restrict administrative actions anyway. A determined user with administrative rights can easily bypass AppLocker rules.

> AaronLocker’s strategy can be summed up as: if a non-admin could have put a program or script onto the computer – i.e., it is in a user-writable directory – don’t allow it to execute unless it has already been specifically allowed by an administrator. This will stop execution if a user is tricked into downloading malware, if an exploitable vulnerability in a program the user is running tries to put malware on the computer, or if a user intentionally tries to download and run unauthorized programs.

> AaronLocker works on all supported versions of Windows that can provide AppLocker.

## Source of the zip files

* [v0.9](https://msdnshared.blob.core.windows.net/media/2018/06/AaronLocker-v0.9.zip) 
SHA256 = 0x7cc5c659af07f2239a7d3b1246aa9244bc171010b2277964407ea36b9b1f70b9

* [v0.91](https://msdnshared.blob.core.windows.net/media/2018/10/AaronLocker-v0.91.zip) 
SHA256 = 0xad50fbb75505c10c9ffa495f9e0f04eb0c0b8e2ae96c05af597ce05dcda720b7

## Goal of this repo

Git repo created for AaronLocker to follow changes made to the code.

As of January 2019 the official repo is on GitHub: https://github.com/Microsoft/AaronLocker

## More info

[“AaronLocker” updates (13 May 2019)](https://blogs.msdn.microsoft.com/aaron_margosis/2019/05/14/aaronlocker-updates-13-may-2019/)
>Hot on the heels of yesterday's changes, "AaronLocker" now handles EXE and DLL files with non-standard extensions. Scan a directory with, say, "*.pyd" files or "*.api" files or any other non-standard extension, the "AaronLocker" scripts now identify them, distinguish whether they are Win32 EXE or DLL rules, and builds rules to cover them.

[“AaronLocker” updates (12 May 2019)](https://blogs.msdn.microsoft.com/aaron_margosis/2019/05/12/aaronlocker-updates-12-may-2019/)
>Rule-generation for files in unsafe paths: always used to create one publisher or hash rule for each file in the directory hierarchy. >New granularity options enable rules tied only to publisher name or publisher+product name instead of one-rule-per-file. Can dramatically reduce the number of rules generated, and increases flexibility/resilience when product updates might introduce new files and reduce the likelihood that the AppLocker rules also need to be updated. See the documentation for details, as well as the special handling for Microsoft-signed files.

>UnsafePaths... - called out in rule name and description when hash rule is created for a signed file that doesn't have version information needed for a publisher rule;
>Used new lower-granularity rules for provided OneDrive XML rules; dramatically reduces number of rules required.
>Small difference in inert timestamp rule so that Compare-Policies shows it as a rule change instead of an added rule + a deleted rule
>Scan-Directories.ps1 - fixed bug in -SearchAllUsersProfiles
>Scan-Directories.ps1 also outputs BinaryName and BinaryVersion
>Exe files to blacklist: added Microsoft.Workflow.Compiler.exe

[“AaronLocker” videos on YouTube](https://blogs.msdn.microsoft.com/aaron_margosis/2019/02/22/aaronlocker-videos-on-youtube/)
>7 minute "Intro to 'AaronLocker'," a set of PowerShell scripts that automate AppLocker-related tasks to achieve robust, practical, customizable, and maintainable application whitelisting for Windows.  https://youtu.be/nQyODwPR5qo

>13 minute "AaronLocker Quick Start:" how to build, customize, and deploy robust and practical AppLocker rules quickly using AaronLocker. https://youtu.be/E-IrqFtJOKU

[“AaronLocker” moved to GitHub](https://blogs.msdn.microsoft.com/aaron_margosis/2019/01/28/aaronlocker-moved-to-github)
>The generated rule set now includes an inoperative rule that contains the date and time the rule set was generated to help differentiate policy versions, and to associate an in-use policy with a policy rule file with the same timestamp in its filename. You can retrieve this time stamp from the policy even after it has been imported into Group Policy:
>Added Get-AaronLockerTimestamp.ps1 to retrieve the generated timestamp from local policy, effective policy, or a saved policy XML file.
>Added DownloadAccesschk.ps1 to download the current version of AccessChk.exe from Sysinternals.
>Improvements to the workbook produced by Generate-EventWorkbook.ps1 (three user-focused tabs).
>Added -Objects switch to Get-AppLockerEvents.ps1 to output PSCustomObjects instead of CSV.
>Scan-Directories.ps1 produces more data, recognizes additional “default” root directories.


[ANNOUNCING: Application whitelisting with “AaronLocker”](https://blogs.msdn.microsoft.com/aaron_margosis/2018/06/26/announcing-application-whitelisting-with-aaronlocker/)

[“AaronLocker” update (v0.91) — and see “AaronLocker” in action on Channel 9!](https://blogs.msdn.microsoft.com/aaron_margosis/2018/10/11/aaronlocker-update-v0-91-and-see-aaronlocker-in-action-on-channel-9/)

[Defrag Tools #198 - AaronLocker](https://channel9.msdn.com/Shows/Defrag-Tools/Defrag-Tools-198-AaronLocker)

## Credits

* Aaron Margosis
* Chris Jackson [@appcompatguy](https://twitter.com/appcompatguy)
