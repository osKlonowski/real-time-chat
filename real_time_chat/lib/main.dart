import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_time_chat/enums/auth_enum.dart';
import 'package:real_time_chat/views/home/home_page.dart';
import 'package:real_time_chat/views/login_signup/login_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Time Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Raleway',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserEntrance(),
    );
  }
}

class UserEntrance extends StatefulWidget {
  UserEntrance({Key key}) : super(key: key);

  @override
  _UserEntranceState createState() => _UserEntranceState();
}

class _UserEntranceState extends State<UserEntrance> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);
      setState(() {
        _authStatus = AuthStatus.LOGGED_IN;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    }
    super.initState();
  }

  //Pass this to Login Page to Change Auth State once logged in
  void loginCallback() {
    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);
      setState(() {
        _authStatus = AuthStatus.LOGGED_IN;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage();
        break;
      case AuthStatus.LOGGED_IN:
        return HomePage();
        break;
      default:
        return buildWaitingScreen();
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Center(
          child: Text(
            "Real Time Chat",
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
