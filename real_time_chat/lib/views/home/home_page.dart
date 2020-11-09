import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/views/home/home_content.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logoutCallback;
  const HomePage({Key key, this.logoutCallback}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  FancyDrawerController _controller;

  @override
  void initState() {
    super.initState();
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
        Text(
          'Profile',
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
        appBar: AppBar(
          leading: GestureDetector(
            onTap: _controller.open,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: HomeContent(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
