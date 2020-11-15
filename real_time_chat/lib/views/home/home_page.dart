import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/models/dialogs/add_new_contact_dialog.dart';
import 'package:real_time_chat/services/database.dart';
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
  FancyDrawerController _controller;
  bool isOpen = false;

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
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return FancyDrawerWrapper(
      backgroundColor: Colors.white,
      controller: _controller,
      drawerItems: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Text(
          'Contacts',
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: 40,
        ),
        GestureDetector(
          onTap: widget.logoutCallback,
          child: Text(
            'Logout',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              if (isOpen) {
                _controller.close();
                setState(() {
                  isOpen = false;
                });
              } else {
                _controller.open();
                setState(() {
                  isOpen = true;
                });
              }
            },
            child: Icon(Icons.menu, color: Colors.white),
          ),
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
                String email = await showAddNewContactDialog(context);
                print(email);
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
        body: HomeContent(),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
