if [ "$CONFIGURATION" == "Debug-stg" ] || [ "$CONFIGURATION" == "Release-stg" ]; then
  cp Runner/stg/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-prod" ] || [ "$CONFIGURATION" == "Release-prod" ]; then
  cp Runner/prod/GoogleService-Info.plist Runner/GoogleService-Info.plist
fi

