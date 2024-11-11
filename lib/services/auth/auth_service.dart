import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  //instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  Future<DocumentSnapshot> getCurrentUserData() async {
    User? user = getCurrentUser();
    if (user != null) {
      return await _firestore.collection('Users').doc(user.uid).get();
    } else {
      throw Exception('No user logged in');
    }
  }

  // Actualizar los datos del usuario
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('Users').doc(uid).update(data);
  }

  // Actualizar el email del usuario
  Future<void> updateUserEmail(String newEmail) async {
    User? user = getCurrentUser();
    if (user != null) {
      await user.updateEmail(newEmail);
    } else {
      throw Exception('No user logged in');
    }
  }

  // Actualizar la contraseña del usuario
  Future<void> updateUserPassword(String newPassword) async {
    User? user = getCurrentUser();
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('No user logged in');
    }
  }

//sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  //register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //save user if it doesn't exist
       await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'password': password,
        'username' : "Usuario"
      });
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  //sign out
  Future<void> signOut() async{
    await _auth.signOut();
  }

// Enviar correo de verificación
  Future<void> sendEmailVerification() async {
    User? user = getCurrentUser();
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw Exception('No user logged in or email already verified');
    }
  }

}
