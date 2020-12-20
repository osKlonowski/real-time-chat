import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';
import 'package:real_time_chat/models/classes/message_class.dart';
import 'package:real_time_chat/services/providers/chat_provider.dart';
import 'package:real_time_chat/services/providers/preview_chat_provider.dart';
import 'package:real_time_chat/views/chat/chat_page.dart';

class ChatPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreviewChatProvider previewChatProvider =
        Provider.of<PreviewChatProvider>(context, listen: true);
    return ConditionalBuilder(
      condition: previewChatProvider.hasLoaded,
      builder: (_) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 90),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => ChatProvider(
                      previewChatProvider.contact,
                      previewChatProvider.contact.chatId,
                    ),
                    child: ChatPage(),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 2.0,
                bottom: 2.0,
                right: 8.0,
              ),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: ClipOval(
                        child: Image.network(
                          previewChatProvider.profilePictureUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(7.0, 0.0, 5.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  previewChatProvider.contactName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: StreamProvider(
                                  create: (_) =>
                                      previewChatProvider.streamChatMessages(),
                                  child: Consumer<List<Message>>(
                                    builder: (_, messages, child) {
                                      if (messages != null &&
                                          messages.length > 0) {
                                        return Text(
                                          '${messages[0].time.toDate().hour}:${messages[0].time.toDate().minute}',
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          StreamProvider(
                            create: (_) =>
                                previewChatProvider.streamChatMessages(),
                            child: Consumer<List<Message>>(
                              builder: (_, messages, child) {
                                if (messages != null && messages.length > 0) {
                                  return Text(
                                    messages[0].text,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                } else {
                                  return Text(
                                    'No messages',
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      fallback: (_) {
        return LoadingChatPreview();
      },
    );
  }
}

class LoadingChatPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 90),
      child: Container(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 2.0,
          bottom: 2.0,
          right: 8.0,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(7.0, 0.0, 5.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Loading...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: LinearProgressIndicator(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    LinearProgressIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
