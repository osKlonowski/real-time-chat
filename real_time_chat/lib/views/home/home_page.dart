import 'package:flutter/material.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/models/dialogs/add_new_contact_dialog.dart';
import 'package:real_time_chat/services/database.dart';
import 'package:real_time_chat/views/contacts/contacts_page.dart';
import 'package:real_time_chat/views/home/home_content.dart';
import 'package:real_time_chat/views/profile/profile_page.dart';
import 'package:real_time_chat/widgets/welcome/new_user_welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logoutCallback;
  const HomePage({Key key, this.logoutCallback}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  void _showFirstTimeWelcome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isNewUser = (prefs.getBool('isNewUser') ?? false);
    if (isNewUser) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NewUserWelcome()));
      await prefs.setBool('isNewUser', false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _showFirstTimeWelcome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chats',
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
      drawer: Drawer(
        elevation: 0,
        child: Container(
          color: primaryBlue,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: _drawerText('Profile'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ContactsPage(),
                        ),
                      );
                    },
                    child: _drawerText('Contacts'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: widget.logoutCallback,
                    child: _drawerLogout(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: HomeContent(),
    );
  }

  Widget _drawerText(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _drawerLogout() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        'Logout',
        style: Theme.of(context).textTheme.subtitle1.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DatabaseService().setOnlineStatus(true);
    } else {
      DatabaseService().setOnlineStatus(false);
    }
  }
}
