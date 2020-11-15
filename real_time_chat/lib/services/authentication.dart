import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createUserRef(
      String uid, String email, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
      });
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _setNewUserVal(false);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showInfo('User Not Found');
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError('Wrong Password');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await creds.user.updateProfile(displayName: name);
      await _createUserRef(creds.user.uid, email, name);
      await _setNewUserVal(true);
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

  Future<void> _setNewUserVal(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNewUser', status);
  }
}
