import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/core/flavor/base_flavor.dart';
import 'package:hotel_list_app/core/injection/dependency_injection.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/pages/venue_screen.dart';
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
    return BlocProvider(
      create: (context) => VenuesBloc(),
      child: MaterialApp(
        title: 'Hotel List App [${BaseFlavor.name.toUpperCase()}]',
        debugShowCheckedModeBanner: false,

        shortcuts: {...WidgetsApp.defaultShortcuts},
        highContrastTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2D3C4E),
            brightness: Brightness.light,
            primary: const Color(0xFF1A2941),
            onPrimary: Colors.white,
            secondary: const Color(0xFF1A2941),
            onSecondary: Colors.white,
            error: Colors.red.shade800,
            onError: Colors.white,
          ),
          textTheme: Typography.englishLike2021.apply(fontSizeFactor: 1.1),
          useMaterial3: true,
        ),
        highContrastDarkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2D3C4E),
            brightness: Brightness.dark,
            primary: const Color(0xFF4D6F97),
            onPrimary: Colors.black,
            secondary: const Color(0xFF4D6F97),
            onSecondary: Colors.black,
            error: Colors.red.shade300,
            onError: Colors.black,
          ),
          textTheme: Typography.englishLike2021.apply(fontSizeFactor: 1.1),
          useMaterial3: true,
        ),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          final textScaleFactor = mediaQuery.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5);

          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: textScaleFactor, navigationMode: NavigationMode.directional),
            child: child!,
          );
        },
        home: const VenueScreen(),
      ),
    );
  }
}
