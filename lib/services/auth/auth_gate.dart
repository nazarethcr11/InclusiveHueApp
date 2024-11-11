import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/pages/home_page.dart';
import 'package:inclusive_hue_app/services/auth/login_or_register.dart';
import 'package:provider/provider.dart';
import '../../provider/authProvider.dart';



class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      return const LoginOrRegister();
    } else {
      return HomePage();
    }
  }
}
