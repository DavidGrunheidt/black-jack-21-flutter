![Coverage](./coverage_badge.svg)

# Blackjack 21 simplified

### Architecture

This app follows Clean Dart architecture [proposed by Flutterando](https://github.com/Flutterando/Clean-Dart/blob/master/README.md).

Folder structure was higly inspired by [Clean Dart Login with Firebase, MobX and Modular](https://github.com/Flutterando/Clean-Dart/blob/master/README.md#:~:text=Clean%20Dart%20Login%20with%20Firebase%2C%20MobX%20and%20Modular) project.

<img src="https://github.com/Flutterando/Clean-Dart/raw/master/imgs/img1.png" width="600">

## CI/CD

- Pull request to develop triggers "pr-checks" pipeline, which will run a static code analysis and run all tests
- Push to develop triggers "stg-build" pipeline, which will run a static code analysis, run all tests, deploy the android app on Firebase app Distribution and deploy the web app on Firebase Hosting, using Firebase staging project.
- Push to main triggers "prod-release" pipeline, which will run a static code analysis, run all tests, deploy the android app on Firebase app Distribution and deploy the web app on Firebase Hosting, using Firebase prod project. The pipeline will also generate a new GitHub release with all needed assets.

# Testing on each environment

- Web App staging: https://blackjack21-stg.web.app
- Web App production: https://blackjack21-prod.web.app

## boot.dart

- Initialization and startup logic should be done here.
- Initalize locators, SDKs, etc.
- Called by all Flavors.

## main_<flavor>.dart

- Entry point for each Flavor of the app
- There is one Flavor per environment (stg, prod)
