import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/flavors/flavors.dart';
import '../core/router/app_router.dart';

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
      routerConfig: _router.config(),
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}
