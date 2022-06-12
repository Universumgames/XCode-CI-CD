packageType="$1" # type of application {ios, macos, appletvos}
ipaPath="$2" # ipaPath path
bundleVersion="$3" # Specify the CFBundleVersion of the app to be uploaded with --upload-package.
bundleShortVersionString="$4" # Specify the CFBundleShortVersionString of the app to be uploaded with --upload-package.
bundleID="$5" # Specify the CFBundleIdentifier of the app to be uploaded with --upload-package.
appID="$6"

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

if [[ -n "$packageType" && -n "$ipaPath" && -n "$bundleVersion" && -n "$bundleShortVersionString" && -n "$bundleID" ]]
then
    # ipaPath file exists
    if [[ -f "$ipaPath" || -d "$ipaPath" ]]
    then
        # platform is valid
        allowedPlatforms=( ios macos appletvos )
        if containsElement "$packageType" "${allowedPlatforms[@]}"; then
            # upload
            # xcrun altool --upload-package file_path --type {macos | ios | appletvos} --asc-public-id id --apple-id id --bundle-version version --bundle-short-version-string string --bundle-id id {-u username [-p password] | --apiKey api_key --apiIssuer issuer_id}
            
            # xcrun altool --list-providers # list available providers
            source appleOTP.sh
            
            xcrun altool --upload-package "$ipaPath" --type "$packageType" --username "$appleID" --password "$appleOTP" --apple-id "$appID" --bundle-version "$bundleVersion" --bundle-short-version-string "$bundleShortVersionString" --bundle-id "$bundleID"
            
            exit $?
        else
            echo "Platform $packageType is not valid, valid options are:"
            printf '%s\n' "${allowedPlatforms[@]}"
            exit 1
        fi
    else
        echo "File/Directory $ipaFile not found"
        exit 1
    fi
else
    echo """
    ipaPath=§2 # ipaPath path
    packageType=§1 # type of application {ios, macos, appletvos}
    bundleVersion=§3 # Specify the CFBundleVersion of the app to be uploaded with --upload-package.
    bundleShortVersionString=§4 # Specify the CFBundleShortVersionString of the app to be uploaded with --upload-package.
    bundleID=§5 # Specify the CFBundleIdentifier of the app to be uploaded with --upload-package.
    appID=§6
    """
    exit 1
fi

# xcodebuild archive -scheme ConfMan -sdk iphoneos -allowProvisioningUpdates -archivePath ~/tmp/confman.xcarchive
# xcodebuild -exportArchive -archivePath "~/tmp/confman.xcarchive" -exportPath "~/tmp/confman.ipa" -allowProvisioningUpdates -exportOptionsPlist ~/customBin/exportPlist.plist
#
