import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/services/database.dart';

Future<void> showAddNewContactDialog(BuildContext context) async {
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
            },
          ),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              if(_emailAddress.text.trim() != null) {
                try {
                  DatabaseService().addNewContact(_emailAddress.text.trim());
                } catch (e) {
                  print(e);
                }
              }
              Navigator.of(context).pop();
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
              if(_emailAddress.text.trim() != null) {
                try {
                  DatabaseService().addNewContact(_emailAddress.text.trim());
                } catch (e) {
                  print(e);
                }
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
