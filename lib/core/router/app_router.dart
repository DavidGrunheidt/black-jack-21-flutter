import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../modules/app_wrapper/presenter/app_wrapper_controller.dart';
import '../../modules/app_wrapper/presenter/app_wrapper_page.dart';
import '../../modules/main_game/main_game_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: AppWrapperRoute.page,
          children: [
            AutoRoute(path: 'main-game', page: MainGameRoute.page, initial: true),
          ],
        ),
      ];
}
