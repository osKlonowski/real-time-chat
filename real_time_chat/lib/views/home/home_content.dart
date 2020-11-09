import 'package:flutter/material.dart';
import 'package:real_time_chat/widgets/chat_preview.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return ChatPreview();
        },
      ),
    );
  }
}