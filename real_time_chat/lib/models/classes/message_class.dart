import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderName;
  final String senderUid;
  final String text;
  final Timestamp time;
  final bool isSent;

  Message({this.senderName, this.senderUid, this.text, this.time, this.isSent});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();

    return Message(
      senderName: data['sender_name'] ?? 'Unknown',
      senderUid: data['sender_uid'] ?? '',
      text: data['text'] ?? '',
      time: data['time'] ?? Timestamp.now(),
      isSent: data['isSent'] ?? true,
    );
  }

}