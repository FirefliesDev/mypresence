import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password);
  Future<FirebaseUser> signInWithGoogle();
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}