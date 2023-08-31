



import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      log("i am going to logIn");
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      log("user=${credential.user}");
      return credential.user;
    } catch (e) {
      log("error2=$e");
      log("Some error occurred");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      log(e.toString());
      log("Some error occurred");
    }
    return null;
  }




}