
## What is AaronLocker?

> AaronLocker is designed to make the creation and maintenance of robust, strict, AppLocker-based whitelisting rules as easy and practical as possible. The entire solution involves a small number of PowerShell scripts. You can easily customize rules for your specific requirements with simple text-file edits. AaronLocker includes scripts that document AppLocker policies and capture event data into Excel workbooks that facilitate analysis and policy maintenance.
> AaronLocker is designed to restrict program and script execution by non-administrative users. Note that AaronLocker does not try to stop administrative users from running anything they want – and AppLocker cannot meaningfully restrict administrative actions anyway. A determined user with administrative rights can easily bypass AppLocker rules.
> AaronLocker’s strategy can be summed up as: if a non-admin could have put a program or script onto the computer – i.e., it is in a user-writable directory – don’t allow it to execute unless it has already been specifically allowed by an administrator. This will stop execution if a user is tricked into downloading malware, if an exploitable vulnerability in a program the user is running tries to put malware on the computer, or if a user intentionally tries to download and run unauthorized programs.
> AaronLocker works on all supported versions of Windows that can provide AppLocker.

## Source of the zip files

* [v0.9](https://msdnshared.blob.core.windows.net/media/2018/06/AaronLocker-v0.9.zip) SHA256 = 0x7cc5c659af07f2239a7d3b1246aa9244bc171010b2277964407ea36b9b1f70b9

* [v0.91](https://msdnshared.blob.core.windows.net/media/2018/10/AaronLocker-v0.91.zip) SHA256 = 0xad50fbb75505c10c9ffa495f9e0f04eb0c0b8e2ae96c05af597ce05dcda720b7

## Goal of this repo

Git repo created for AaronLocker to follow changes made to the code.

## More info

[ANNOUNCING: Application whitelisting with “AaronLocker”](https://blogs.msdn.microsoft.com/aaron_margosis/2018/06/26/announcing-application-whitelisting-with-aaronlocker/)
[“AaronLocker” update (v0.91) — and see “AaronLocker” in action on Channel 9!](https://blogs.msdn.microsoft.com/aaron_margosis/2018/10/11/aaronlocker-update-v0-91-and-see-aaronlocker-in-action-on-channel-9/)

[Defrag Tools #198 - AaronLocker](https://channel9.msdn.com/Shows/Defrag-Tools/Defrag-Tools-198-AaronLocker)

## Credits

* Aaron Margosis
* Chris Jackson [@appcompatguy](https://twitter.com/appcompatguy)
