import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (!themeProvider.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        return MaterialApp(
          title: 'FinLearn',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/signin': (context) => const SignInScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const MainScreen(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        print(
          'AuthWrapper: ConnectionState = ${snapshot.connectionState}, HasData = ${snapshot.hasData}, User = ${snapshot.data?.email}',
        );

        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text('Loading...'),
                ],
              ),
            ),
          );
        }

        // Navigate based on auth state
        if (snapshot.hasData) {
          print('AuthWrapper: User authenticated, navigating to MainScreen');
          return const MainScreen();
        } else {
          print('AuthWrapper: No user, showing OnboardingScreen');
          return const OnboardingScreen();
        }
      },
    );
  }
}
