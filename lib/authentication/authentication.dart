import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mypresence/authentication/base_auth.dart';

class Authentication implements BaseAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await _googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    FirebaseUser userDetails =
        (await firebaseAuth.signInWithCredential(credential)).user;
    return userDetails;
  }

  Future<FirebaseUser> currentUser() async {
    return await firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    firebaseAuth.signOut();
    if (_googleSignIn != null) _googleSignIn.signOut();
  }
}
