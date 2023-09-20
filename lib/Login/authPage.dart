import 'package:flutter/material.dart';
import 'package:taskanglara/Login/LoginPage.dart';
import 'package:taskanglara/Login/SignUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(onClickedSignUp: toggle)
      : SignUp(onClickedSignIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}
