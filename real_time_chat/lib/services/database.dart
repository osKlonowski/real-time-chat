import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setOnlineStatus(bool status) {
    try {
      _firestore.collection('users').doc(_auth.currentUser.uid).update({
        'isOnline': status,
      });
    } on FirebaseException catch (e) {
      print(e);
    } 
    catch (e) {
      print(e);
    }
  }
}
