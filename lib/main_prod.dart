import 'core/boot.dart';
import 'core/flavors/flavors.dart';

Future<void> main() async {
  appFlavor = Flavor.PROD;
  return boot();
}
