import 'package:flutter/material.dart';

class MyNotification extends StatelessWidget {
  final String message;
  final String imagePath;

  const MyNotification({
    Key? key,
    required this.message,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 40.0, // Ancho de la imagen
            height: 40.0, // Alto de la imagen
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
