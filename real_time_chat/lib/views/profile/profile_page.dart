import 'package:flutter/material.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/services/database.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: 'Raleway',
              ),
        ),
        backgroundColor: primaryBlue,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //Profile Picture
            _profilePicture(),
            //Name
            _profileName(),
            //Other
          ],
        ),
      ),
    );
  }

  Widget _profileName() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        DatabaseService().getProfileName(),
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Raleway',
          fontSize: 24.0,
        ),
      ),
    );
  }

  Widget _profilePicture() {
    double size = MediaQuery.of(context).size.width * 0.40;
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: FutureBuilder(
          future: DatabaseService().getPictureUrl(),
          initialData:
              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                width: size,
                height: size,
                child: ClipOval(
                  child: Image.network(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: size,
                height: size,
                child: ClipOval(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
