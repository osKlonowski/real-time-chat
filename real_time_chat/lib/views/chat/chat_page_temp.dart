// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:real_time_chat/global.dart';

// class ChatPage extends StatefulWidget {
//   ChatPage({Key key}) : super(key: key);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   TextEditingController _messageController = TextEditingController();
//   bool _isComposingMessage = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Name',
//           style: Theme.of(context).textTheme.headline5.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Raleway',
//               ),
//         ),
//         backgroundColor: primaryBlue,
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Flexible(
//               child: FirebaseAnimatedList(
//                 query: //Reference to Messages of that chat,
//                 padding: const EdgeInsets.all(8.0),
//                 reverse: true,
//                 sort: (a, b) => b.key.compareTo(a.key),
//                 itemBuilder: (_, DataSnapshot messageSnapshot, Animation<double> animation) {
//                   return ChatMessageListItem(
//                     messageSnapshot: messageSnapshot,
//                     animation: animation,
//                   ),
//                 },
//                 Divider(height: 1.0),
//                 Container(
//                   decoration: BoxDecoration(),
//                   child: _buildTextComposer(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//    Widget _buildTextComposer() {
//     return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: <Widget>[
//               Flexible(
//                 child: TextField(
//                   controller: _messageController,
//                   onChanged: (String messageText) {
//                     setState(() {
//                       _isComposingMessage = messageText.length > 0;
//                     });
//                   },
//                   onSubmitted: (msg) {},
//                   decoration:
//                       InputDecoration.collapsed(hintText: "Send a message"),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: CupertinoButton(
//       child: Text("Send"),
//       onPressed: _isComposingMessage
//           ? () {}
//           : null,
//     ),
//               ),
//             ],
//           ),
//         );
//   }
// }
