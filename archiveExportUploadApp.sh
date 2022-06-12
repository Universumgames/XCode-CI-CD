
exportDir="$1"
sdk="$2"
appID="$3"
disableUploadArg="$4"

debugMode=0
disableUpload=0

source colors.sh

# 0. check validity on all variables
# 1. archive
# 2. export archive to ipa
# 3. upload ipa to appstore

echo ""

if [[ $debugMode ]]; then
    echo "${CYAN}Running in testmode, no commands will be executed${WHITE}"
    echo ""
fi

if [[ -n "$disableUploadArg" ]]; then
    disableUpload=1
    echo "Upload disabled, one argument too much provided"
fi

# check variables are set
if [[ ! (-n "$exportDir" && -n "$sdk" && -n "$appID")]]
then
    echo "${RED}one or more og the following parameters are missing"
    echo "\t§1 Directory to export to"
    echo "\t§2 SDK to use "
    echo "\t§3 APP ID"
    exit 1
fi

# get data from project file
source extractXCodeData.sh
extractBuildSettings 2> /dev/null

bundleVersion="$buildVersion" # Specify the CFBundleVersion of the app to be uploaded with --upload-package.
bundleShortVersionString="$marketingVersion" # Specify the CFBundleShortVersionString of the app to be uploaded with --upload-package.

containsElement () {
  echo "$1"
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# check sdk is valid for archive
validArchiveSDKs=(driverkit iphoneos iphoneosimulator macosx appletvos appletvsimulator watchos watchsimulator)
if [[ ! $(containsElement "$sdk" "${validArchiveSDKs[@]}") ]]; then
    echo "${RED}$sdk is not a valid sdk for archiving${WHITE}"
    exit 1
fi

# check sdk is valid for export
validExportSDKs=(driverkit iphoneos macosx appletvos watchos)
if [[ ! $(containsElement "$sdk" "${validExportSDKs[@]}") ]]; then
    echo "${RED}$sdk is not a valid sdk for exporting${WHITE}"
    exit 1
fi

# convert sdk to platform
platform=""
if [[ "$sdk" == "iphoneos" ]]; then
    platform="ios"
fi
if [[ "$sdk" == "macosx" ]]; then
    platform="macos"
fi

if [[ ! (-n "$platform") ]]; then
    echo "${RED}Could not map sdk to valid platform${WHITE}"
    exit 1
fi

# check exportDir exists, else create it
if [[ ! (-d "$exportDir") ]]; then
    mkdir -p "$exportDir"
fi

checkSuccess(){
    if [[ ($code == 0) ]]; then
        echo "\t${GREEN}Success${WHITE}"
    else
        echo "\033${RED}An error occurred${WHITE}"
        exit 1
    fi
}

# archive
archiveFile="$exportDir/$scheme.xcarchive"
code=0
echo "Archiving scheme $scheme for $sdk into $archiveFile"
if [[ $debugMode == 0 ]]; then
    archiveApp.sh "$scheme" "$sdk" "$archiveFile"
    code=$?
else
    echo "${GRAY}Calling archiveApp.sh $scheme $sdk $archiveFile${WHITE}"
fi

checkSuccess

# export archive
ipaExportPath="$exportDir/$scheme"
echo "Exporting Archive ($archiveFile) to ipa ($ipaExportPath)"
if [[ $debugMode == 0 ]]; then
    exportArchive.sh "$archiveFile" "$ipaExportPath"
    code=$?
else
    echo "${GRAY}Calling exportArchive.sh $archiveFile $ipaExportPath${WHITE}"
fi

checkSuccess

ipaFile="$ipaExportPath/$scheme.ipa"

# upload ipa
if [[ $disableUpload == 1 ]]; then
    echo "Skipping Upload"
    checkSuccess

    echo ""
    echo "${GREEN}Successfully archived App"
    exit 0
fi

echo "Uploading ipa to appstore"
if [[ $debugMode == 0 ]]; then
    uploadApp.sh "$platform" "$ipaFile" "$bundleVersion" "$bundleShortVersionString" "$bundleID" "$appID"
    code=$?
else
    echo "${GRAY}Calling uploadApp.sh $platform $ipaFile $bundleVersion $bundleShortVersionString $bundleID $appID ${WHITE}"
fi

checkSuccess

echo ""
echo "${GREEN}Successfully uploaded App to AppStore"

exit $code
