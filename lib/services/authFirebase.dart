import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_1c/domain/AuthUser.dart';
class AuthService{
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  Future<AuthUser?> signInWithEmailPassword(String email, String pwd) async {
    try{
      UserCredential result = await _fAuth.signInWithEmailAndPassword(email: email, password: pwd); // AuthResult
      User? user = result.user; //FirebaseUser
      return AuthUser.fromFirebase(user!);
    }catch(e){
      return null;
    }
  }
  Future<AuthUser?> signUpWithEmailPassword(String email, String pwd) async {
    try{
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(email: email, password: pwd); // AuthResult
      User? user = result.user; //FirebaseUser
      return AuthUser.fromFirebase(user);
    }catch(e){
      return null;
    }
  }

  Future logOut() async{
    await _fAuth.signOut();
  }

Stream <AuthUser?> get currentUser{
  return _fAuth.authStateChanges().map((User ?user) => user != null ? AuthUser.fromFirebase(user) : null);
}
}