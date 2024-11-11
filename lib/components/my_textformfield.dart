import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData icon;
  final String? Function(String?)? validator;

  const MyTextformfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
          prefixIcon: Icon(icon , color: Theme.of(context).colorScheme.primary,),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:  Theme.of(context).colorScheme.tertiary,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.0,
              color:  Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder( // Borde cuando hay error
            borderSide: BorderSide(
              width: 2.0,
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedErrorBorder: OutlineInputBorder( // Borde cuando está enfocado y hay error
            borderSide: BorderSide(
              width: 2.0,
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
