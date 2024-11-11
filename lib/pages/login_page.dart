import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/components/my_button.dart';
import 'package:inclusive_hue_app/components/my_textformfield.dart';
import 'package:inclusive_hue_app/services/auth/auth_service.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //login function
  void login(BuildContext context) async{
    //auth service
    final authService  = AuthService();
    //validate form
    if(!formKey.currentState!.validate()){
      return;
    }
    //try to sign in
    try{
      await authService.signInWithEmailAndPassword(
          emailController.text,
          passwordController.text
      );
    }
    //catch error
    catch(e){
      //show error
      showDialog(
          context: context,
          builder: (context)=> AlertDialog(
            title: Text(e.toString()),
          )
      );
    }
  }

  //email validator
  String? emailValidator(String? email){
    if(email == null || email.isEmpty){
      return 'Por favor ingrese un email';
    }
    else if(!email.contains('@')){
      return 'Por favor ingrese un email valido';
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
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image logo
                  Image.asset(
                    'lib/images/logotype/logo.png',
                    width: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bienvenido a Inclusive Hue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Ingresa a tu cuenta para  acceder a nuestras herramientas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextformfield(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.email,
                    obscureText: false,
                    validator: emailValidator,
                  ),
                  SizedBox(height: 20),
                  MyTextformfield(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: passwordValidator,
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    onTap: ()=>login(context),
                    text: 'LOGIN',
                  ),
                  //no tienes cuenta? Registrate
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          ' Registrate',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}