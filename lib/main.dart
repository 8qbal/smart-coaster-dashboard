import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'config/firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/sensor_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (not supported on Linux desktop)
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.linux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Load saved theme preference
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          themeProvider.isDarkMode ? const Color(0xFF0F1419) : const Color(0xFFF0F4F8),
    ),
  );

  // Prefer portrait orientation on mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
      ],
      child: const SmartCoasterApp(),
    ),
  );
}

/// Root application widget.
class SmartCoasterApp extends StatelessWidget {
  const SmartCoasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        // Update system UI when theme changes
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: themeProvider.isDarkMode
                ? const Color(0xFF0F1419)
                : const Color(0xFFF0F4F8),
          ),
        );

        return MaterialApp(
          title: 'Smart Coaster Dashboard',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const DashboardScreen(),
        );
      },
    );
  }
}
