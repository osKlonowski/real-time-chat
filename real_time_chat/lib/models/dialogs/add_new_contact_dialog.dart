import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> showAddNewContactDialog(BuildContext context) async {
  TextEditingController _emailAddress = TextEditingController();
  if (Platform.isIOS) {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Add New Contact"),
        content: Container(
          child: TextField(
            maxLines: 1,
            controller: _emailAddress,
            decoration: InputDecoration(
              hintText: 'Input Email Address',
              labelText: 'Email',
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              return '';
            },
          ),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop();
              return _emailAddress.text.trim();
            },
          )
        ],
      ),
    );
  } else {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Contact"),
        content: Container(
          child: TextField(
            maxLines: 1,
            controller: _emailAddress,
            decoration: InputDecoration(
              hintText: 'Input Email Address',
              labelText: 'Email',
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              return '';
            },
          ),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop();
              return _emailAddress.text.trim();
            },
          )
        ],
      ),
    );
  }
}
