import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/firebase_options.dart';
import 'package:inclusive_hue_app/provider/ColorFilterProvider.dart';
import 'package:inclusive_hue_app/provider/authProvider.dart';
import 'package:inclusive_hue_app/services/auth/auth_gate.dart';
import 'package:inclusive_hue_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(
      MultiProvider(
          providers: [
          ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
          create: (context)=> ColorFilterProvider()
          ),
          ChangeNotifierProvider(
          create: (context) => AuthProvider()
          ),
        ],
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorFilterProvider = Provider.of<ColorFilterProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<ColorFilterProvider>(
        builder: (context, colorFilterProvider, child) {
          return ColorFiltered(
            colorFilter: colorFilterProvider.colorFilter,
            child: AuthGate(),
          );
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}