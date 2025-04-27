import 'package:hotel_list_app/core/flavor/base_flavor.dart';
import 'package:hotel_list_app/core/flavor/base_flavor_config.dart';
import 'main.dart' as app;

void main() {
  BaseFlavor.initialize(FlavorType.prod);
  app.main();
}
