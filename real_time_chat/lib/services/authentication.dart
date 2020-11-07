import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    UserCredential result = await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError((err) {
      print(err.toString());
      return false;
    });

    User user = result.user;
    return true;
  }

  Future<bool> signUp(String email, String password, String name) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError((err) {
      print(err.toString());
      return false;
    });

    User user = result.user;
    return true;
  }

}
