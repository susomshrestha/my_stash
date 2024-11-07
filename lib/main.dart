import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_stash/firebase_options.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/providers/passwords_provider.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/theme/light_theme.dart';
import 'package:my_stash/theme/dark_theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => PasswordsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ToastService.navigatorKey,
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
