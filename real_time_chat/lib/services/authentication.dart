import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        EasyLoading.showInfo('User Not Found');
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError('Wrong Password');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password is too weak.');
        EasyLoading.showInfo('Password Too Weak');
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showError('Email Already in Use');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
