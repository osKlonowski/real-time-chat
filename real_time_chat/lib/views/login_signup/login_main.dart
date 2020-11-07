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
                  //Toggle
                  _toggle(),
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
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(
            Icons.mail,
            color: Colors.white,
          )),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (val) => val.trim(),
    );
  }

  Widget _passwordInput() {
    return TextFormField(
      maxLines: 1,
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.white,
          )),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (val) => val.trim(),
    );
  }

  Widget _toggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _authMode =
              _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
        });
      },
      child: Container(
        child: Center(
          heightFactor: 1.5,
          widthFactor: 2,
          child: Text(
            _authMode == AuthMode.Login
                ? 'Create an Account'
                : "Already have an account?",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget _continue() {
    return GestureDetector(
      onTap: () {
        //Validate Form
        _submitForm();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Center(
          heightFactor: 1.5,
          widthFactor: 2,
          child: Text(
            _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
