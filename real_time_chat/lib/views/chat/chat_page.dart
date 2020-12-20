import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/models/classes/message_class.dart';
import 'package:real_time_chat/services/providers/chat_provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatProvider chatProvider;
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    if (chatProvider != null) {
      setState(() {
        _loaded = true;
      });
    }
    return ConditionalBuilder(
      condition: _loaded,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                chatProvider.clearMessage();
                Navigator.of(context).pop();
              },
            ),
            title: Text(chatProvider.name),
            centerTitle: true,
            backgroundColor: primaryBlue,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                chatProvider.clearMessage();
                currentFocus.unfocus();
              }
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<Message>>(
                    stream: chatProvider.streamChatMessages(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView(
                                reverse: true,
                                children: _generateMessages(snapshot.data),
                              ),
                            );
                          } else {
                            return _buildWaitingWidget(
                              errorMessage: 'No Chats',
                            );
                          }
                          break;
                        case ConnectionState.waiting:
                          return _buildWaitingWidget();
                          break;
                        case ConnectionState.done:
                        case ConnectionState.none:
                        default:
                          return _buildWaitingWidget(
                            errorMessage: 'Connection Was Broken',
                          );
                          break;
                      }
                    },
                  ),
                  Divider(height: 1.0),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    child: _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      fallback: (_) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: Icon(
        Icons.send,
        color: primaryBlue,
      ),
      onPressed: () async {
        await chatProvider.sendText().timeout(Duration(seconds: 4),
            onTimeout: () {
          EasyLoading.showToast(
            'Message Timeout - Please Try Again',
            toastPosition: EasyLoadingToastPosition.bottom,
          );
          return false;
        });
        //FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildTextComposer() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14.0),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: TextField(
                  controller: chatProvider.textFieldController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                  //maxLength: 240,
                  //TODO: This might be neccessary if you wanna enforce half-height max box size.
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type a message...',
                  ),
                ),
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

  List<Widget> _generateSenderLayout(Message message) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 12.0, top: 1.5),
              padding: const EdgeInsets.all(10.0),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minWidth: MediaQuery.of(context).size.width * 0.1,
              ),
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
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
            _messageFooter(false, message.time.toDate(), message.isSent),
          ],
        ),
      ),
    ];
  }

  List<Widget> _generateReceiverLayout(Message message) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 12.0, top: 1.5),
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minWidth: MediaQuery.of(context).size.width * 0.1,
              ),
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
                message.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
            _messageFooter(true, message.time.toDate(), message.isSent),
          ],
        ),
      ),
    ];
  }

  _generateMessages(List<Message> messagesList) {
    return messagesList.map<Widget>((msg) {
      if (msg.text != '.&.&.') {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: msg.senderUid != chatProvider.auth.currentUser.uid
                ? _generateReceiverLayout(msg)
                : _generateSenderLayout(msg),
          ),
        );
      } else {
        return SizedBox(
          height: 0,
          width: 0,
        );
      }
    }).toList();
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

  Widget _messageFooter(bool isLeft, DateTime time, bool sent) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isLeft ? 12.0 : 0.0, //Left
        5.0, //Top
        isLeft ? 0.0 : 12.0, //Right
        0, //Bottom
      ),
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          sent ? Icon(
            Icons.check,
            color: primaryBlue,
            size: 13.0,
          ) : SizedBox(),
          SizedBox(
            width: 2.0,
            height: 0,
          ),
          Text(
            sent ? 'Sent' : 'In Progress...',
            style: TextStyle(
              color: primaryBlue,
              fontSize: 10.0,
            ),
          ),
          SizedBox(
            width: 5.0,
            height: 0,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${time.hour}:${time.minute}",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black45,
                  ),
                  children: [
                    TextSpan(
                      text: ".${time.second}",
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
