import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DatabaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<QuerySnapshot> getListOfChats() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('contacts')
        .where('activeChat', isEqualTo: true)
        .get();
  }

  Future<bool> createNewChat(String uid) async {
    try {
      DocumentReference chatRef = await _firestore.collection('chats').add({
        'member1': _auth.currentUser.uid,
        'member2': uid,
      });
      await _firestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .collection('contacts')
          .doc(uid)
          .update({
        'activeChat': true,
        'chatId': chatRef.id,
      });
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('contacts')
          .doc(_auth.currentUser.uid)
          .update({
        'activeChat': true,
        'chatId': chatRef.id,
      });
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<QuerySnapshot> getListOfContacts() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('contacts')
        .get();
  }

  Future<bool> addNewContact(String email) async {
    try {
      //Get New Contact Info
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      Map<String, dynamic> data = query.docs.first.data();
      //Add Contact To User
      await _firestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .collection('contacts')
          .doc(data['uid'])
          .set({
        'uid': data['uid'],
        'name': data['name'],
        'email': data['email'],
        'createdAt': Timestamp.now(),
        'activeChat': false,
        'chatId': '',
      });
      //Add User to Contact
      await _firestore
          .collection('users')
          .doc(data['uid'])
          .collection('contacts')
          .doc(_auth.currentUser.uid)
          .set({
        'uid': _auth.currentUser.uid,
        'name': _auth.currentUser.displayName,
        'email': _auth.currentUser.email,
        'createdAt': Timestamp.now(),
        'activeChat': false,
        'chatId': '',
      });
      EasyLoading.showToast('Added New Contact',
          toastPosition: EasyLoadingToastPosition.bottom);
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> uploadProfilePicture(File image) async {
    try {
      Reference ref =
          _storage.ref().child('profilePicture/${_auth.currentUser.uid}');
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
      DocumentSnapshot docRef = await _firestore
          .collection('users')
          .doc(uid ?? _auth.currentUser.uid)
          .get();
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
    } catch (e) {
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
