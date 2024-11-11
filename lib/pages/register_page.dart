import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/components/my_textformfield.dart';
import 'package:inclusive_hue_app/services/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasssSswordController = TextEditingController();
  //form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final void Function()? onTap;

  //email validator
  String? emailValidator(String? email){
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isValid = emailRegExp.hasMatch(email??'');
    if (email == null || email.isEmpty){
      return 'Por favor ingrese un email';
    }
    else if(!isValid){
      return 'Por favor ingrese un email válido';
    }
    else{
      return null;
    }
  }
  //password validator
  String? passwordValidator(String? password){
    if(password == null || password.isEmpty){
      return 'Por favor ingrese una contraseña';
    }
    else if(password!.length<6){
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    // if password is simple
    else if(password.contains(RegExp(r'[A-Z]'))==false){
      return 'Debe contener al menos una letra mayúscula';
    }
    else if(password.contains(RegExp(r'[a-z]'))==false){
      return 'Debe contener al menos una letra minúscula';
    }
    else if(password.contains(RegExp(r'[0-9]'))==false){
      return 'Debe contener al menos un número';
    }
    else{
      return null;
    }
  }
  //confirm password validator
  String? confirmPasswordValidator(String? confirmPassword){
    if(confirmPassword == null || confirmPassword.isEmpty){
      return 'Por favor confirme su contraseña';
    }
    else if(confirmPassword != passwordController.text){
      return 'Las contraseñas no coinciden';
    }
    else{
      return null;
    }
  }
  RegisterPage({super.key, required this.onTap});
  //register function
  void register(BuildContext context) async {
    // Auth service
    final _auth = AuthService();
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    //create account
      try {
        // register
        await _auth.registerWithEmailAndPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        // show error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          ),
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //image logo
                Image.asset(
                  'lib/images/logotype/logo.png',
                  width: 120,
                ),
                const SizedBox(height: 4),
                Text(
                  'Inclusive Hue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Regístrate para acceder a nuestras herramientas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                //email textfield
                MyTextformfield(
                    controller: emailController,
                    hintText: 'Correo electrónico',
                    obscureText: false,
                    icon: Icons.email,
                    validator: emailValidator
                ),
                const SizedBox(height: 17),
                //password textfield
                MyTextformfield(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    icon: Icons.lock,
                    validator: passwordValidator
                ),
                const SizedBox(height: 17),
                //confirm password textfield
                MyTextformfield(
                    controller: confirmPasssSswordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    icon: Icons.lock,
                    validator: confirmPasswordValidator
                ),
                const SizedBox(height: 20),
                //register button
                MyButton(
                    onTap:  ()=>register(context),
                    text: 'Registrarse'
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes una cuenta?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        ' Inicia sesión',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
