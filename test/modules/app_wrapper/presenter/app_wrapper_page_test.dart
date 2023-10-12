import 'package:auto_route/auto_route.dart';
import 'package:black_jack_21_flutter/core/dependencies/dependency_injector.dart';
import 'package:black_jack_21_flutter/core/permission/external/drivers/permission_driver_impl.dart';
import 'package:black_jack_21_flutter/core/permission/infra/services/permission_service_impl.dart';
import 'package:black_jack_21_flutter/core/router/app_router.dart';
import 'package:black_jack_21_flutter/flavors.dart';
import 'package:black_jack_21_flutter/modules/app_wrapper/domain/usecases/tracking_permission_request.dart';
import 'package:black_jack_21_flutter/modules/app_wrapper/presenter/app_wrapper_controller.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/cards_values_sum.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/draw_card_to_player_hand.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/start_new_game.dart';
import 'package:black_jack_21_flutter/modules/main_game/presenter/main_game_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:platform/platform.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../utils/router_test_utils.dart';
import 'app_wrapper_page_test.mocks.dart';

@GenerateMocks(
  [
    StartNewGame,
    DrawCardToPlayerHand,
    StackRouter,
  ],
  customMocks: [
    // ignore: deprecated_member_use
    MockSpec<PermissionHandlerPlatform>(mixingIn: [MockPlatformInterfaceMixin])
  ],
)
void main() {
  return group('AppWrapperPage', () {
    final mockPermissionHandlerPlatform = MockPermissionHandlerPlatform();
    final mockStartNewGame = MockStartNewGame();
    final mockDrawCardToPlayerHand = MockDrawCardToPlayerHand();
    final mockStackRouter = MockStackRouter();

    final cardsValueSum = CardsValuesSumImpl();

    final mainGameController = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);

    PermissionHandlerPlatform.instance = mockPermissionHandlerPlatform;
    appFlavor = Flavor.PROD;

    const trackingPermission = Permission.appTrackingTransparency;
    Future<Map<Permission, PermissionStatus>> requestAppTrackingTransparencyPermission() {
      return mockPermissionHandlerPlatform.requestPermissions([trackingPermission]);
    }

    final fakeAndroidPlatform = FakePlatform(operatingSystem: Platform.android);
    final fakeIOSPlatform = FakePlatform(operatingSystem: Platform.iOS);

    setUp(() {
      getIt.registerSingleton(mainGameController);
    });

    tearDown(() {
      reset(mockPermissionHandlerPlatform);
      reset(mockStartNewGame);
      reset(mockDrawCardToPlayerHand);
      reset(mockStackRouter);

      getIt.reset();
    });

    testWidgets('page loads and does not asks for permission when android', (tester) async {
      final permissionDriver = PermissionDriverImpl();
      final permissionService = PermissionServiceImpl(permissionDriver);
      final trackingPermissionRequest =
          TrackingPermissionRequestImpl.withPlatform(permissionService, fakeAndroidPlatform);
      final controller = AppWrapperController(trackingPermissionRequest);

      getIt.registerSingleton<AppWrapperController>(controller);

      await pumpRouterApp(tester, AppRouter());
      await tester.pump(const Duration(seconds: 2));

      verifyZeroInteractions(mockPermissionHandlerPlatform);
    });

    testWidgets('page loads and does not ask for permission before 2 seconds', (tester) async {
      final permissionDriver = PermissionDriverImpl();
      final permissionService = PermissionServiceImpl(permissionDriver);
      final trackingPermissionRequest = TrackingPermissionRequestImpl.withPlatform(permissionService, fakeIOSPlatform);
      final controller = AppWrapperController(trackingPermissionRequest);

      getIt.registerSingleton<AppWrapperController>(controller);

      when(requestAppTrackingTransparencyPermission()).thenAnswer((_) async {
        return {trackingPermission: PermissionStatus.granted};
      });

      await pumpRouterApp(tester, AppRouter());
      await tester.pump(const Duration(seconds: 1));

      verifyZeroInteractions(mockPermissionHandlerPlatform);

      await tester.pump(const Duration(seconds: 1));

      verify(requestAppTrackingTransparencyPermission());
      verifyNoMoreInteractions(mockPermissionHandlerPlatform);
    });

    testWidgets('page loads and asks for permission when iOS', (tester) async {
      final permissionDriver = PermissionDriverImpl();
      final permissionService = PermissionServiceImpl(permissionDriver);
      final trackingPermissionRequest = TrackingPermissionRequestImpl.withPlatform(permissionService, fakeIOSPlatform);
      final controller = AppWrapperController(trackingPermissionRequest);

      getIt.registerSingleton<AppWrapperController>(controller);

      when(requestAppTrackingTransparencyPermission()).thenAnswer((_) async {
        return {trackingPermission: PermissionStatus.granted};
      });

      await pumpRouterApp(tester, AppRouter());
      await tester.pump(const Duration(seconds: 2));

      verify(requestAppTrackingTransparencyPermission());
      verifyNoMoreInteractions(mockPermissionHandlerPlatform);
    });
  });
}
