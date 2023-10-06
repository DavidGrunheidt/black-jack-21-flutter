// ignore_for_file: constant_identifier_names
enum Flavor { STG, PROD }

// ignore: avoid_classes_with_only_static_members
late final Flavor appFlavor;

String get name => appFlavor.name;

String get appTitle {
  switch (appFlavor) {
    case Flavor.STG:
      return '[STG]Blackjack 21';
    case Flavor.PROD:
      return 'Blackjack 21';
    default:
      return 'Blackjack 21';
  }
}
