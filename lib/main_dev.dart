import 'package:hotel_list_app/core/flavor/base_flavor.dart';
import 'main.dart' as app;

void main() {
  BaseFlavor.initialize(FlavorType.dev);
  app.main();
}
