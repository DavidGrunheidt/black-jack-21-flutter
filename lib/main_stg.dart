import 'core/boot.dart';
import 'core/flavors/flavors.dart';

Future<void> main() async {
  appFlavor = Flavor.STG;
  return boot();
}
