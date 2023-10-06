import 'package:firebase_core/firebase_core.dart';

import '../flavors/flavors.dart';
import 'firebase_options_prod.dart' as firebase_options_prod;
import 'firebase_options_stg.dart' as firebase_options_stg;

FirebaseOptions get currentPlatform {
  switch (appFlavor) {
    case Flavor.STG:
      return firebase_options_stg.DefaultFirebaseOptions.currentPlatform;
    case Flavor.PROD:
      return firebase_options_prod.DefaultFirebaseOptions.currentPlatform;
  }
}
