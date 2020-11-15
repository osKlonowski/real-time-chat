import 'package:flutter/material.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/widgets/chat_widgets/chat_input_widget.dart';
import 'package:real_time_chat/widgets/chat_widgets/chat_message_item.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'Name of User',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: 'Raleway',
              ),
        ),
        backgroundColor: primaryBlue,
        elevation: 2,
      ), // Custom app bar for chat screen
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ChatListWidget(), //Chat list
                InputWidget() // The input widget
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListWidget extends StatelessWidget {
  final ScrollController listScrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) => ChatItemWidget(index),
      itemCount: 20,
      reverse: true,
      controller: listScrollController,
    ));
  }
}


