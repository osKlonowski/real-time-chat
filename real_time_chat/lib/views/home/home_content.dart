import 'package:flutter/material.dart';
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
              if (snapshot.hasData && snapshot.data.docs.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    dynamic data = snapshot.data.docs[index].data();
                    return ChatPreview();
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
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.none:
            case ConnectionState.waiting:
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
