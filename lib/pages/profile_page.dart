import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/pages/edit_profile_page.dart';
import 'package:inclusive_hue_app/pages/theme_page.dart';
import '../../components/my_list_tile.dart';
import '../services/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;
  final AuthService _authService = AuthService();
  String name ="";
  String email="";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  void _loadUserData() async {
    try {
      DocumentSnapshot userData = await _authService.getCurrentUserData();
      setState(() {
        name = userData['username'] ?? '';
        email = userData['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false; // Datos cargados con error
      });
    }
  }

  void signOut(BuildContext context) async{
    _isLoggingOut=true;
    //auth service
    final authService  = AuthService();
    //try to sign out
    try{
      await authService.signOut();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  //shadow
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: _isLoading?
                Center(
                  child: CircularProgressIndicator(),
                ):Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      radius: 50,
                      backgroundImage: AssetImage('lib/images/default/profile.webp'), // Reemplaza con la ruta de tu imagen
                    ),
                    SizedBox(height: 15),
                    Text(
                      name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 5,)
                    ],
                  ),
              ),
              ),
            SizedBox(height: 20),
            MyListTile(
                icon_leading: Icons.edit,
                title: 'Editar Perfil',
                onTap: (){
                 Navigator.push(context,MaterialPageRoute(builder:(context)=> EditProfilePage(),));
                },
                iconColor: Theme.of(context).colorScheme.primary,
            ),
            MyListTile(
                icon_leading: Icons.palette,
                title: 'Temas',
                onTap: ()=> Navigator.push(context,MaterialPageRoute(builder:(context)=> ThemePage(),)),
                iconColor: Theme.of(context).colorScheme.primary,
            ),
            _isLoggingOut
                ? CircularProgressIndicator()
            :MyListTile(
                icon_leading: Icons.logout,
                title: 'Cerrar Sesión',
                onTap: ()=>signOut(context),
                iconColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}