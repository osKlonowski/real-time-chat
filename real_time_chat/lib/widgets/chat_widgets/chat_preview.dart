import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/services/database.dart';
import 'package:real_time_chat/views/chat/chat_page.dart';

class ChatPreview extends StatelessWidget {
  final dynamic contactInfo;
  const ChatPreview({Key key, this.contactInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 90),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                chatId: contactInfo['chatId'],
                nameOfUser: contactInfo['name'],
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
                child: FutureBuilder(
                  future: DatabaseService()
                      .getUserProfilePicture(contactInfo['uid']),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        if (snapshot.hasData && snapshot.data != null) {
                          return Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(snapshot.data),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[400],
                            ),
                            child: Center(
                              child: Text(
                                'Unavailable',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          );
                        }
                        break;
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey,
                          ),
                          child: Center(
                              child: Text(
                                'Loading..',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                        );
                        break;
                      case ConnectionState.none:
                      default:
                        return Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        break;
                    }
                  },
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
                              contactInfo['name'],
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
                            child: FutureBuilder(
                              future: DatabaseService()
                                  .getMostRecentMessage(contactInfo['chatId']),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      Timestamp time = snapshot.data['time'];

                                      return Text(
                                          '${time.toDate().hour}:${time.toDate().minute}');
                                    } else {
                                      return Text(
                                          'Unable to retrieve last message');
                                    }
                                    break;
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return LinearProgressIndicator();
                                    break;
                                  case ConnectionState.none:
                                  default:
                                    return Text('Error Occured');
                                    break;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FutureBuilder(
                        future: DatabaseService()
                            .getMostRecentMessage(contactInfo['chatId']),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              if (snapshot.hasData && snapshot.data != null) {
                                return Text(snapshot.data['text']);
                              } else {
                                return Text('Unable to retrieve last message');
                              }
                              break;
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return LinearProgressIndicator();
                              break;
                            case ConnectionState.none:
                            default:
                              return Text('Error Occured');
                              break;
                          }
                        },
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
  }
}
