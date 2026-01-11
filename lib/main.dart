import 'package:apd/presentation/app_shell.dart';
import 'package:apd/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/state/providers.dart';
import 'presentation/screens/language/language_selection_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: DictionaryApp(),
    ),
  );
}

/// ---------------------------------------------------------------------------
/// ROOT APP
/// ---------------------------------------------------------------------------
///
/// This widget owns **app start routing logic**.
/// As the app grows, more checks can be added here:
/// - Authentication
/// - Onboarding
/// - Migrations
/// - Feature flags
///
class DictionaryApp extends StatelessWidget {
  const DictionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: AppStartScreen(),
    );
  }
}

/// ---------------------------------------------------------------------------
/// APP START SCREEN
/// ---------------------------------------------------------------------------
///
/// Decides which screen the user should see on app launch.
/// This screen should be VERY small and VERY boring.
///
class AppStartScreen extends ConsumerWidget {
  const AppStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLanguageAsync = ref.watch(activeLanguageProvider);

    return activeLanguageAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, error) => Scaffold(
        body: Center(child: Text('$error')),
      ),

        data: (language) {
        // If language is already selected, skip language selection
        if (language != null) {
          return const AppShell();
        }

        // Otherwise, force user to select a language
        return LanguageSelectionScreen();
      },
    );
  }
}
