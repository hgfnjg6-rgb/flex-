import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/notification_service.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/log_symptoms_screen.dart';
import 'screens/profile_setup.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'config.dart';
import 'app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MonaCareApp(initialRoute: '/splash'),
    ),
  );
}

class MonaCareApp extends StatelessWidget {
  final String initialRoute;
  const MonaCareApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          themeMode: appState.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFFFF6B9A), // Accent
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6B9A),
            ),
            textTheme: GoogleFonts.cairoTextTheme(),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFFFF6B9A),
            textTheme: GoogleFonts.cairoTextTheme(),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar'), Locale('en')],
          locale: const Locale('ar'), // default to Arabic (RTL)
          initialRoute: initialRoute,
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/profile_setup': (context) => const ProfileSetupScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/auth': (context) => const AuthScreen(),
            '/home': (context) => const HomeScreen(),
            '/main': (context) => const MainShell(),
            '/calendar': (context) => const CalendarScreen(),
            '/log': (context) => const LogSymptomsScreen(),
          },
        );
      },
    );
  }
}
