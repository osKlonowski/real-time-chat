import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/services/database.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String nameOfUser;
  ChatPage({Key key, this.chatId, this.nameOfUser}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference chatReference;
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  @override
  void initState() {
    chatReference = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');
    super.initState();
    _textController.addListener(() {
      print('Text Controller Listener Triggered');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameOfUser),
        centerTitle: true,
        backgroundColor: primaryBlue,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream:
                    chatReference.orderBy('time', descending: true).snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView(
                            reverse: true,
                            children: _generateMessages(snapshot),
                          ),
                        );
                      } else {
                        return _buildWaitingWidget(errorMessage: 'No Chats');
                      }
                      break;
                    case ConnectionState.waiting:
                      return _buildWaitingWidget();
                      break;
                    case ConnectionState.done:
                    case ConnectionState.none:
                    default:
                      return _buildWaitingWidget(
                          errorMessage: 'Connection Was Broken');
                      break;
                  }
                },
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: _buildTextComposer(),
              ),
              // Builder(
              //   builder: (context) {
              //     return Container(height: 0, width: 0);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: Icon(
        Icons.send,
        color: primaryBlue,
      ),
      onPressed: () async {
        //TODO: Implement _isWriting
        //Send Message
        await DatabaseService()
            .sendText(widget.chatId, _textController.text.trim())
            .timeout(Duration(seconds: 3), onTimeout: () {
          EasyLoading.showToast('Message Timeout - Please Try Again',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        });
        _textController.clear();
      },
    );
  }

  Widget _buildTextComposer() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  print('On changed');
                },
                onEditingComplete: () {
                  print('Edit Complete');
                },
                onTap: () {
                  print('Tap');
                },
                onSubmitted: (value) async {
                  print('Submitted');
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Type a message...'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: getDefaultSendButton(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 12.0, top: 1.5),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(2.0),
                ),
              ),
              child: Text(
                documentSnapshot.data()['text'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 12.0, top: 1.5),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(2.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Text(
                documentSnapshot.data()['text'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  _generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: doc.data()['sender_uid'] != DatabaseService().getUid()
                    ? _generateReceiverLayout(doc)
                    : _generateSenderLayout(doc),
              ),
            ))
        .toList();
  }

  Widget _buildWaitingWidget({String errorMessage}) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Center(
              child: errorMessage != null
                  ? Text(errorMessage)
                  : CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
