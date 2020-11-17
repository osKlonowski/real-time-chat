import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/models/dialogs/add_new_contact_dialog.dart';
import 'package:real_time_chat/services/database.dart';
import 'package:real_time_chat/views/chat/chat_page.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: 'Raleway',
              ),
        ),
        backgroundColor: primaryBlue,
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              await showAddNewContactDialog(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: DatabaseService().getListOfContacts(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.done:
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    dynamic data = snapshot.data.docs[index].data();
                    return _contactTile(data);
                  },
                );
                break;
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _contactTile(dynamic data) {
    Timestamp time = data['createdAt'];
    return ListTile(
      leading: Icon(
        Icons.person,
        size: 24.0,
        color: Colors.black,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data['name'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "created: ${time.toDate().day}-${time.toDate().month}-${time.toDate().year}",
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14.0,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.chat_bubble,
        size: 24.0,
        color: Colors.blue,
      ),
      onTap: () async {
        EasyLoading.show(status: 'Loading...');
        if(data['activeChat']) {
          //TODO: Open Chat -> Pass Chat Id
          // print(data['chatId']);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatPage()));
        } else {
          bool createdChat = await DatabaseService().createNewChat(data['uid']);
          if(createdChat) {
            Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatPage()));
          } else {
            EasyLoading.showError('Unable To Create Chat');
          }
        }
        EasyLoading.dismiss();
      },
      onLongPress: () {
        //TODO: Delete Contact Modal Dialog
      },
    );
  }
}
