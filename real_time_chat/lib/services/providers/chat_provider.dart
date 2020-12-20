import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';
import 'package:real_time_chat/models/classes/message_class.dart';

class ChatProvider extends ChangeNotifier {
  //INSTACES
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController textFieldController = TextEditingController();

  //Constructor
  ChatProvider(Contact contact, String chatId) {
    _contact = contact;
    _chatId = chatId;
    chatReference =
        _firestore.collection('chats').doc(chatId).collection('messages');
    textFieldController.addListener(() {
      //TODO: Implement all handlers for text field
      print("${textFieldController.value.text}");
      print(_isWriting.toString());
      if (textFieldController.text.isEmpty && !_isWriting && !_justSent) {
        createMessageRef();
        _justSent = false;
      } else if (textFieldController.text.isNotEmpty || _isWriting) {
        updateMessage(textFieldController.text.trim());
      }
    });
  }

  //Variables
  Contact _contact;
  String _chatId = '';
  String _messageRef = '';
  bool _justSent = false;
  bool _isWriting = false;
  CollectionReference chatReference;

  //Getters
  String get getMessageRef => _messageRef;

  String get getChatId => _chatId;

  bool get justSent => _justSent;

  String get name => _contact.name;

  FirebaseAuth get auth => _auth;

  //Setters
  set messageRef(String newRef) {
    _messageRef = newRef;
  }

  //Functions
  void clearMessage() {
    if (_messageRef != '' || _isWriting) {
      _isWriting = false;
      _firestore
          .collection('chats')
          .doc(_chatId)
          .collection('messages')
          .doc(_messageRef)
          .delete();
      textFieldController.clear();
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

  Future<void> createMessageRef() async {
    try {
      if (!_justSent && !_isWriting) {
        _isWriting = true;
        _justSent = false;
        DocumentReference msgRef = await _firestore
            .collection('chats')
            .doc(_chatId)
            .collection('messages')
            .add({
          'text': '.&.&.',
          'sender_uid': _auth.currentUser.uid,
          'sender_name': _auth.currentUser.displayName,
          'time': FieldValue.serverTimestamp(),
          'isSent': false,
        });
        _messageRef = msgRef.id;
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> sendText() async {
    _isWriting = false;
    try {
      if (textFieldController.text.isNotEmpty) {
        await _firestore
            .collection('chats')
            .doc(_chatId)
            .collection('messages')
            .doc(_messageRef)
            .update({
          'time': FieldValue.serverTimestamp(),
          'text': textFieldController.text.trim(),
          'isSent': true,
        });
        _messageRef = '';
        this.textFieldController.clear();
        _justSent = true;
        await createMessageRef();
      } else {
        clearMessage();
      }
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<Message>> streamChatMessages() {
    var msgStream = _firestore
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .orderBy('time', descending: true);
    return msgStream.snapshots().map(
        (list) => list.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }
}
