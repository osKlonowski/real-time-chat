import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/models/classes/contact_class.dart';
import 'package:real_time_chat/models/dialogs/add_new_contact_dialog.dart';
import 'package:real_time_chat/models/dialogs/remove_contact_dialog.dart';
import 'package:real_time_chat/services/database.dart';
import 'package:real_time_chat/services/providers/chat_provider.dart';
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
        child: StreamBuilder(
          stream: DatabaseService().getListOfContacts(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    Contact contact =
                        Contact.fromFirestore(snapshot.data.docs[index]);
                    return _contactTile(contact);
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

  Widget _contactTile(Contact contact) {
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
            contact.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "created: ${contact.createdAt.toDate().day}-${contact.createdAt.toDate().month}-${contact.createdAt.toDate().year}",
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
        if (contact.activeChat && contact.chatId != '') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => ChatProvider(contact),
                child: ChatPage(),
              ),
            ),
          );
        } else {
          await DatabaseService()
              .createNewChat(contact.contactUid)
              .then((value) {
            if (value != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => ChatProvider(contact),
                    child: ChatPage(),
                  ),
                ),
              );
            } else {
              EasyLoading.showError('Unable To Create Chat');
            }
          });
        }
        EasyLoading.dismiss();
      },
      onLongPress: () async {
        await removeContactDialog(context, contact.contactUid);
      },
    );
  }
}
