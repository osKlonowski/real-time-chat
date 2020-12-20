import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';
import 'package:real_time_chat/models/classes/message_class.dart';

class PreviewChatProvider with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Contact contact;
  String profilePictureUrl = '';
  bool _loaded = false;

  bool get hasLoaded => this._loaded;
  String get contactName => this.contact.name;

  PreviewChatProvider(this.contact) {
    initChatPreview();
  }

  Future<void> initChatPreview() async {
    //Get User Profile Picture
    await getUserProfilePicture();
    //set to finished
    _loaded = true;
    notifyListeners();
  }

  Future<void> getUserProfilePicture() async {
    try {
      DocumentSnapshot ref =
          await _firestore.collection('users').doc(this.contact.contactUid).get();
      if(ref.data()['profilePictureUrl'] != null) {
        profilePictureUrl = ref.data()['profilePictureUrl'];
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Message>> streamChatMessages() {
    var msgStream = _firestore
        .collection('chats')
        .doc(this.contact.chatId)
        .collection('messages').orderBy('time', descending: true);
    return msgStream.snapshots().map((list) => list.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }
}
