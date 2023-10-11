import 'boot.dart';
import 'flavors.dart';

Future<void> main() async {
  appFlavor = Flavor.PROD;
  return boot();
}
