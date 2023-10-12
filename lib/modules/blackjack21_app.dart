import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/design_system/theme/theme_data.dart';
import '../core/router/app_router.dart';
import '../flavors.dart';

class Blackjack21App extends StatelessWidget {
  Blackjack21App({
    super.key,
  });

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: appTitle,
      theme: themeData,
      darkTheme: darkThemeData,
      routerDelegate: AutoRouterDelegate(_router),
      routeInformationProvider: _router.routeInfoProvider(),
      routeInformationParser: _router.defaultRouteParser(),
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}
