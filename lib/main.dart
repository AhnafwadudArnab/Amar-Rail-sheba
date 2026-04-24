import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amarRailSheba/OnBoards/FrontPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppLoader());
}

/// Shows a splash screen while Firebase initializes, then launches the app.
/// Displays an error screen if initialization fails.
class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late final Future<void> _init;

  @override
  void initState() {
    super.initState();
    _init = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amar Rail Sheba',
      home: FutureBuilder<void>(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _SplashScreen();
          }
          if (snapshot.hasError) {
            return _ErrorScreen(error: snapshot.error.toString());
          }
          return const Onboard();
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A3A6B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.train, size: 72, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Amar Rail Sheba',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bangladesh Railway',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(color: Color(0xFFE8A838)),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A6B),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Failed to start app',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection and try again.\n\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
