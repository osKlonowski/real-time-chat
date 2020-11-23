import 'package:flutter/material.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';
import 'package:real_time_chat/services/database.dart';
import 'package:real_time_chat/widgets/chat_widgets/chat_preview.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: DatabaseService().getListOfChats(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data.length > 0) {
                List<Contact> chats = snapshot.data;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return ChatPreview(contact: chats[index]);
                  },
                );
              } else {
                return Container(
                  child: Center(
                    child: Text('No Contacts'),
                  ),
                );
              }
              break;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.none:
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
          }
        },
      ),
    );
  }
}
