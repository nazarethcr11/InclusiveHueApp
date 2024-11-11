import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/services/auth/auth_service.dart';
import '../../components/my_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar datos del usuario
  void _loadUserData() async {
    try {
      DocumentSnapshot userData = await _authService.getCurrentUserData();
      setState(() {
        _nameController.text = userData['username'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Guardar los cambios del usuario
  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        String newName = _nameController.text.trim();

        User? currentUser = _authService.getCurrentUser();
        if (currentUser != null) {
          // Actualizar nombre de usuario en Firestore
          if (newName != currentUser.displayName) {
            await _authService.updateUserData(currentUser.uid, {'username': newName});
          }

          // Notificar al usuario que los cambios se han guardado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cambios guardados con éxito.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No hay ningún usuario conectado.')),
          );
        }

        // Volver a la vista anterior después de 1 segundo
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
      } catch (e) {
        print('Error saving changes: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios.')),
        );
      }
    }
  }

  // Verificar correo electrónico
  void _checkEmailVerification() async {
    try {
      User? user = _authService.getCurrentUser();
      if (user != null) {
        await user.reload(); // Recargar los datos del usuario
        if (user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Correo verificado.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Correo aún no verificado.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay ningún usuario conectado.')),
        );
      }
    } catch (e) {
      print('Error checking email verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al verificar el correo electrónico.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading // Mostrar CircularProgressIndicator si está cargando
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey, // Asignar la llave al formulario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MyButton(
                  onTap: _saveChanges, // Llamar al método para guardar cambios
                  text: 'Guardar Cambios',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
