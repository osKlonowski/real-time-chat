import 'package:flutter/material.dart';
import 'package:real_time_chat/enums/auth_enum.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/services/authentication.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;
  LoginPage(this.loginCallback);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  Auth _authentication = Auth();

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    switch (_authMode) {
      case AuthMode.Login:
        bool res = await _authentication.signIn(
            _emailController.text.trim(), _passwordController.text.trim());
        if (res) widget.loginCallback();
        break;
      case AuthMode.Signup:
        bool res = await _authentication.signUp(
            _emailController.text.trim(), _passwordController.text.trim());
        if (res) widget.loginCallback();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _showForm(),
      ),
    );
  }

  Widget _showForm() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Header
            Expanded(
              flex: 3,
              child: _header(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Email Input
                  _emailInput(),
                  //Password Input
                  _passwordInput(),
                  //Buttons
                  _continue(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: _toggle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Center(
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
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 14, 4),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.mail,
              color: Colors.grey[700],
            ),
            labelText: 'Email',
            labelStyle: Theme.of(context).textTheme.subtitle1,
          ),
          controller: _emailController,
          maxLines: 1,
          onSaved: (val) => val.trim(),
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val.length == 0) {
              return "email cannot be empty";
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 14, 4),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.lock,
              color: Colors.grey[700],
            ),
            labelText: 'Password',
            labelStyle: Theme.of(context).textTheme.subtitle1,
          ),
          obscureText: true,
          controller: _passwordController,
          maxLines: 1,
          onSaved: (val) => val.trim(),
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val.length == 0) {
              return "password cannot be empty";
            } else {
              return null;
            }
          },
        ),
      ),
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
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
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
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Center(
          heightFactor: 1.8,
          widthFactor: 3,
          child: Text(
            _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
            style:
                Theme.of(context).textTheme.headline5.copyWith(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
