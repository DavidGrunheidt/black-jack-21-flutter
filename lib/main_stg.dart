import 'boot.dart';
import 'flavors.dart';

Future<void> main() async {
  appFlavor = Flavor.STG;
  return boot();
}
