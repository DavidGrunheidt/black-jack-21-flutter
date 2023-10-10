SHELL := /bin/bash
.PHONY: ci-tests

gen-code:
	dart run build_runner build --delete-conflicting-outputs
	dart format . -l 120

ci-tests:
	dart format --set-exit-if-changed . -l 120
	dart analyze
	flutter test -r expanded --coverage
	dart run covadge ./coverage/lcov.info ./

show-test-coverage:
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

cache-repair:
	flutter pub cache repair
	make clean

clean:
	flutter clean
	flutter pub get

adb-restart:
	adb kill-server
	adb start-server

########################################
########## LESS USED COMMANDS ##########
########################################

ANDROID_IOS_APP_ID=com.dvo.blackjack21
FIREBASE_PREFIX=blackjack21
FIREBASE_OPTIONS_PATH=lib/core/firebase_options/firebase_options

# Generate firebase configurations for each environment
gen-firebase-configs:
	flutterfire config -y -p ${FIREBASE_PREFIX}-stg -o ${FIREBASE_OPTIONS_PATH}_stg.dart -i ${ANDROID_IOS_APP_ID}.stg -a ${ANDROID_IOS_APP_ID}.stg
	mv ios/firebase_app_id_file.json .firebase/stg && mv android/app/google-services.json .firebase/stg
	flutterfire config -y -p ${FIREBASE_PREFIX}-prod -o ${FIREBASE_OPTIONS_PATH}_prod.dart -i ${ANDROID_IOS_APP_ID} -a ${ANDROID_IOS_APP_ID}
	mv ios/firebase_app_id_file.json .firebase/prod && mv android/app/google-services.json .firebase/prod

# Generate flavorizr native configurations.
# This will override app.dart, flavors.dart and all main_X.dart.
# Only run if you know what you are doing.
# After running, the cited files need to be reset to their previous state.
gen-flavors:
	dart run flutter_flavorizr

# Generate native splash screens for each flavor
gen-native-splash:
	flutter pub run flutter_native_splash:create --flavor stg
	flutter pub run flutter_native_splash:create --flavor prod

# Generate launcher icons
gen-launcher-icons:
	dart run flutter_launcher_icons

apply-lint:
	dart fix --dry-run
	dart fix --apply

