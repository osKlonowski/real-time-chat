import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String contactUid;
  final String name;
  final String chatId;
  final bool activeChat;
  final Timestamp createdAt;
  final String email;

  Contact({this.contactUid, this.name, this.chatId, this.createdAt, this.email, this.activeChat});

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();

    return Contact(
      contactUid: data['uid'],
      name: data['name'],
      chatId: data['chatId'] ?? '',
      activeChat: data['activeChat'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      email: data['email'],
    );
  }

}