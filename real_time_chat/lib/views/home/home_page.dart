import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback logoutCallback;
  const HomePage({Key key, this.logoutCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Hello World'),
              FlatButton(
                onPressed: logoutCallback,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
