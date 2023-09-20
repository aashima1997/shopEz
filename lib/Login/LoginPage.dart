import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskanglara/main.dart';
import 'package:taskanglara/service/apiScreenhelper.dart';

class LoginPage extends StatefulWidget {
  final Function() onClickedSignUp;

  const LoginPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String welcome="ShopEz Welcomes You!";
  String hpegrt="Hope you are doing Great!";
  String dhacc="Don't have an account?";
  String signUp='Sign Up';
  String loginbtn="Login";
  String email='Email Id';
  var toast=ApiScreenHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ShopEz"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:  Text(
                  welcome,
                  style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                )),

            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:  Text(
                  hpegrt,
                  style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration:  InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:email ,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent)),
                  child:  Text(loginbtn),
                  onPressed: () {
                    login();
                  },
                )),
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    text: dhacc,
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: signUp,
                      style: const TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.pinkAccent))
                ]))
          ],
        ),
      ),
    );
  }


  Future login() async {
    if (nameController.text.isEmpty) {
      toast.toast("Please Enter User ID");
    } else if (passwordController.text.isEmpty) {
      toast.toast("Please Enter Password");
    } else {
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context)=> const Center(child: CircularProgressIndicator()));
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: nameController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print(e);
          toast.toast(e.code.toString());
        }
      }
      navigatorkey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
