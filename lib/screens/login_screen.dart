import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:basic_auth/screens/main_screen.dart';
import 'package:basic_auth/screens/signup_screen.dart';
import 'package:basic_auth/util/email_validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                controller: _emailController,
                validator: (value) =>
                    !validateEmail(value) ? "Email is Invalid" : null,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: _passwordController,
                validator: (value) =>
                    value.isEmpty ? "Password is invalid" : null,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text("LOG IN"),
                onPressed: () => _handleLoginButtonOnPressed(context),
                color: Theme.of(context).primaryColor,
              ),
              RaisedButton(
                child: Text("LOG Out"),
                onPressed: () => _handleLogoutButtonOnPressed(context),
                color: Theme.of(context).primaryColor,
              ),
              OutlineButton(
                child: Text("Create New Account"),
                onPressed: () => _gotoSignUpScreen(context),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLoginButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        final signInResponse =
            await Amplify.Auth.signIn(username: email, password: password);
        if (signInResponse.isSignedIn) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MainScreen()));
        }
      } on AuthException catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _handleLogoutButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      try {
        await Amplify.Auth.signOut();
      } on AuthException catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  void _gotoSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpScreen(),
      ),
    );
  }
}
