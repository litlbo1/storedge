import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storedge/firebase_options.dart';
import 'package:storedge/pages/registr_screen.dart';
import 'package:storedge/providers/AuthProvider.dart';
import 'package:storedge/providers/CheckUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/start',
      routes: {
        '/start':(context) => AuthCheck(),
        '/registr':(context) => const Registr_Screen(),
      },
    );
  }
}
