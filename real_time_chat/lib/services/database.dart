import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadProfilePicture(File image) async {
    try {
      Reference ref = _storage.ref().child('profilePicture/${_auth.currentUser.uid}');
      await ref.putFile(image);
      ref.getDownloadURL().then((url) {
        _firestore.collection('users').doc(_auth.currentUser.uid).update({
          'profilePictureUrl': url,
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<String> getPictureUrl({uid}) async {
    try {
      DocumentSnapshot docRef = await _firestore.collection('users').doc(uid ?? _auth.currentUser.uid).get();
      return docRef.data()['profilePictureUrl'];
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return null;
  }

  String getProfileName() {
    return _auth.currentUser.displayName;
  }

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

//   void addUserToDB(String id, String email, String name) async {
//   final userRef = Firestore.instance.collection("users").document(id);
//   Firestore.instance.runTransaction((Transaction tx) async {
//     DocumentSnapshot userSnapshot = await tx.get(userRef);
//     if (userSnapshot.exists) {
//       await tx.update(userRef, {
//         'userId': id,
//         'email': email,
//         'name': name,
//         'bio': '',
//         'university': '',
//         'job': '',
//         'ageRange': {
//           'top': 55,
//           'bottom': 18,
//         },
//         'age': 20, //TODO: Calculate from User Birthday
//         'gender': '', //TODO: Get from FB
//         'preference': '',
//         'height': '',
//         'isVerified': false,
//         'isActive': true,
//         'dataset_id': '',
//         'dataset_name': '',
//         'model_id': '',
//         'totalMatchesCount': 0,
//         'swipeCount': 0,
//         'livingIn': '',
//         'profilePictureUrl': '',
//       });
//     }
//   });
//   saveDeviceToken();
// }
}
