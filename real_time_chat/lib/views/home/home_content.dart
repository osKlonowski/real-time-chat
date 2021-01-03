import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';
import 'package:real_time_chat/services/database.dart';
import 'package:real_time_chat/services/providers/preview_chat_provider.dart';
import 'package:real_time_chat/widgets/chat_widgets/chat_preview.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Contact>>(
      create: (_) => DatabaseService().getStreamOfChats(),
      builder: (BuildContext context, child) {
        return Consumer<List<Contact>>(
          builder: (context, List<Contact> contacts, _) {
            return ConditionalBuilder(
              condition: contacts != null,
              builder: (context) {
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<PreviewChatProvider>(
                      create: (_) => PreviewChatProvider(contacts[index]),
                      child: ChatPreview(),
                    );
                  },
                );
              },
              fallback: (context) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return LoadingChatPreview();
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
