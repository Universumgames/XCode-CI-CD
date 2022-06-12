
schemeName="$1"
sdk="$2"
archiveDest="$3"

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

if [[ -n "$schemeName" && -n "$sdk" && -n "$archiveDest" ]]; then

    validSDKs=(driverkit iphoneos iphoneosimulator macosx appletvos appletvsimulator watchos watchsimulator)
    if containsElement "$sdk" "${validSDKs[@]}"; then
    
        xcodebuild archive -scheme "$schemeName" -sdk "$sdk" -allowProvisioningUpdates -archivePath "$archiveDest" > /dev/null
        exit $?
    else
        echo "SDK $sdk is not valid, valid options are:"
        printf '%s\n' "${validSDKs[@]}"
        exit 1
    fi
else
    echo "§1 scheme"
    echo "§2 sdk"
    echo "§3 archive Destination"
    exit 1
fi

