import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'features/auth/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
