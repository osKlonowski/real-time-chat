import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      print(err.toString());
      return false;
    });
    return true;
  }

  Future<bool> signUp(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      print(err.toString());
      return false;
    });
    return true;
  }
}
