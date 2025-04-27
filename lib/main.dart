import 'package:flutter/material.dart';
import 'package:hotel_list_app/core/flavor/base_flavor.dart';
import 'package:hotel_list_app/core/injection/dependency_injection.dart';
import 'package:hotel_list_app/core/routes/app_router.dart';
import 'package:hotel_list_app/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hotel List App [${BaseFlavor.name.toUpperCase()}]',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,

      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      highContrastTheme: AppTheme.highContrastLightTheme(),
      highContrastDarkTheme: AppTheme.highContrastDarkTheme(),

      shortcuts: {...WidgetsApp.defaultShortcuts},

      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final textScaleFactor = mediaQuery.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5);

        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: textScaleFactor, navigationMode: NavigationMode.directional),
          child: child!,
        );
      },
    );
  }
}
