import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';

class ChatProvider extends ChangeNotifier {
  //INSTACES
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Constructor
  ChatProvider(Contact contact) {
    _contact = contact;
    _chatId = contact.chatId;
    chatReference =
        _firestore.collection('chats').doc(contact.chatId).collection('messages');
  }

  //Variables
  Contact _contact;
  String _chatId = '';
  String _messageRef = '';
  bool _justSent = false;
  bool _isWriting = false;
  CollectionReference chatReference;

  //Getters
  String get getMessageRef {
    return _messageRef;
  }

  String get getChatId {
    return _chatId;
  }

  bool get justSent {
    return _justSent;
  }

  String get name {
    return _contact.name;
  }

  //Setters
  set messageRef(String newRef) {
    _messageRef = newRef;
  }

  set setSentStatus(bool stat) {
    _justSent = false;
  }

  //Functions
  void clearMessage() {
    if(_messageRef != '') {
      _isWriting = false;
      _firestore.collection('chats').doc(_chatId).collection('messages').doc(_messageRef).delete();
    }
  }

  void updateMessage(String text) {
    try {
      if (_messageRef != '' && _isWriting) {
        _firestore
            .collection('chats')
            .doc(_chatId)
            .collection('messages')
            .doc(_messageRef)
            .update({
          'text': text,
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> createMessageRef() async {
    try {
      if (!_justSent && !_isWriting) {
        _isWriting = true;
        DocumentReference msgRef = await _firestore
            .collection('chats')
            .doc(_chatId)
            .collection('messages')
            .add({
          'text': '.&.&.',
          'sender_uid': _auth.currentUser.uid,
          'sender_name': _auth.currentUser.displayName,
          'time': FieldValue.serverTimestamp()
        });
        _messageRef = msgRef.id;
        return _messageRef != '';
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> sendText(String text) async {
    _justSent = true;
    _isWriting = false;
    try {
      await _firestore
          .collection('chats')
          .doc(_chatId)
          .collection('messages')
          .doc(_messageRef)
          .update({'time': FieldValue.serverTimestamp()});
      _messageRef = '';
      await createMessageRef();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> chatMessages() {
    return _firestore
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .snapshots();
  }
}
