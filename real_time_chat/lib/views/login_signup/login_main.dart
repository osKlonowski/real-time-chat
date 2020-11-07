import 'package:flutter/material.dart';
import 'package:real_time_chat/enums/auth_enum.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (_authMode == AuthMode.Login) {
      //Login
    } else {
      //Sign In
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Header
                  _header(),
                  //Email Input
                  _emailInput(),
                  //Password Input
                  _passwordInput(),
                  //Buttons
                  _continue(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      child: Text(
        'Welcome to Real Chatting',
        style: Theme.of(context).textTheme.headline3.copyWith(
              color: Colors.white,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      validator: (String value) {
        return null;
      },
    );
  }

  Widget _passwordInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password"),
      obscureText: true,
      validator: (String value) {
        return null;
      },
    );
  }

  Widget _toggle() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Center(
          heightFactor: 1.5,
          widthFactor: 2,
          child: Text(
            'Sign Up',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget _continue() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Center(
          heightFactor: 1.5,
          widthFactor: 2,
          child: Text(
            'Login',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
