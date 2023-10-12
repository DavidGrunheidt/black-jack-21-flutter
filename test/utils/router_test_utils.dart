import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpRouterApp(
  WidgetTester tester,
  RootStackRouter router, {
  String? initialLink,
  NavigatorObserversBuilder observers = AutoRouterDelegate.defaultNavigatorObserversBuilder,
}) {
  final widget = MaterialApp.router(
    routeInformationParser: router.defaultRouteParser(),
    routerDelegate: router.delegate(
      deepLinkBuilder: (link) => initialLink == null ? link : DeepLink.path(initialLink),
      navigatorObservers: observers,
    ),
  );

  return tester.pumpWidget(widget).then((_) => tester.pumpAndSettle());
}
