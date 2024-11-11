import 'package:flutter/material.dart';
import '../../components/my_notification.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOTIFICACIONES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
        ),
        centerTitle: true,
      ),

      backgroundColor: Theme
          .of(context)
          .colorScheme
          .secondary,
      body: Builder(
        builder: (context) =>
            ListView(
              children: const[
                MyNotification(
                  message: 'Usted realizó un cambio en el tipo de daltonismo: “Deuteranopia”',
                  imagePath: 'lib/images/logotype/logo.png',
                ),
                MyNotification(
                  message: 'Usted realizó un cambio en el tipo de daltonismo: “Deuteranopia”',
                  imagePath: 'lib/images/logotype/logo.png', // Ruta de la imagen
                ),
                MyNotification(
                  message: 'Usted realizó un cambio en el tipo de daltonismo: “Deuteranopia”',
                  imagePath: 'lib/images/logotype/logo.png', // Ruta de la imagen
                ),
                // Agrega más mensajes según sea necesario
              ],
            ),
      ),
    );
  }
}


