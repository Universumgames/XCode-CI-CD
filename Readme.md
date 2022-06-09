# Use XCode with CI/CD

<!-- I've written a whole article over on our blog at [mt32.net](https://mt32.net). -->

Here some cut down basics:

This repository contains all necessary files to compile, archive and upload your XCode application to AppStoreConnect (if you have an Apple Developer Account). For this construction of shell scripts to work, here some requirements:

-   obviously you have to run this script on MacOS, how to do that is up to you, I've provided an example Gitlab script
-   if you want to upload your application to the AppStore, the same rules apply when uploading via XCode (owning an Developer Account for example)
-   you need to edit some files to work on your machine:
    -   [`appleOTP.sh`](appleOTP.sh): you have to provide an Apple-ID and an OTP generated on [https://appleid.apple.com/account/manage](https://appleid.apple.com/account/manage) and "App-Specific Passwords"
    -   [`exportPlist.plist`](exportPlist.plist): you have to provide your TeamID you want your app to be archived to
    -   [`exportArchive.sh`](exportArchive.sh): your have to edit the Path to the exportPlist.plist file you want to use

IMPORTANT
You may need to adjust some lines down the line, I was yet unable to test all possible configurations and only tested exporting an iOS app.

# How to use

Sadly, my schedule is full and I am currently unable to complete this Readme, in the mean time here a rather limited explanation.

Currently, if you want to learn on how to use my scripts, have a look at my [example Gitlab file](exampleGitlabCIForXCode.yml).

If your're interested on a more detailed look, look inside the files yourself and try to run them, they will tell you the most important arguments the scripts needs.
