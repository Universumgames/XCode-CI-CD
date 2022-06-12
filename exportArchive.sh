
archive="$1"
ipaDest="$2"


if [[ -n "$archive" && -n "$ipaDest" ]]; then

    xcodebuild -exportArchive -archivePath "$archive" -exportPath "$ipaDest" -allowProvisioningUpdates -exportOptionsPlist <path-to-export-plist> > /dev/null
    exit $?
else
    echo "§1 archive path"
    echo "§2 destination ipa parent folder"
    exit 1
fi

