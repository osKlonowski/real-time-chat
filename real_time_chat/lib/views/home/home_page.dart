import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/global.dart';

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
        FlatButton(
          onPressed: widget.logoutCallback,
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
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Hello World'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
