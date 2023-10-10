![Coverage](./coverage_badge.svg)

# Blackjack 21 simplified

## Overview

### Architecture

## Tests

## boot.dart

- Initialization and startup logic should be done here.
- Initalize locators, SDKs, etc.
- Called by all Flavors.

## main_<flavor>.dart

- Entry point for each Flavor of the app
- There is one Flavor per environment (stg, prod)
- Use `flavors.dart` to define Flavor specific values that are not secret (baseURL, etc).
