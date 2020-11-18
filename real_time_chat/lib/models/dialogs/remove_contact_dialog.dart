import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:real_time_chat/services/database.dart';

Future<void> removeContactDialog(BuildContext context, String uid) async {
  if (Platform.isIOS) {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Remove Contact"),
        content: Container(
          child: Text('Are you sure you want to remove this contact?'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              try {
                EasyLoading.show(status: 'Removing Contact');
                await DatabaseService().removeContact(uid);
                EasyLoading.dismiss();
              } catch (e) {
                print(e);
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
          child: Text('Are you sure you want to remove this contact?'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              try {
                EasyLoading.show(status: 'Removing Contact');
                await DatabaseService().removeContact(uid);
                EasyLoading.dismiss();
              } catch (e) {
                print(e);
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
