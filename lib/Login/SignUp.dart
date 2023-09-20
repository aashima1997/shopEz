import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskanglara/service/apiScreenhelper.dart';

import '../main.dart';

class SignUp extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUp({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  var toast=ApiScreenHelper();
  String alhacc='Already have an account?';
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
        title: const Text("Welcome"),
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
                child: const Text(
                  'Sign Up to Start the Service!',
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email Id',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: signUpPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent)),
                  child: const Text('SignUp'),
                  onPressed: () {
                    signUp();
                  },
                )),
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    text: alhacc,
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Login',
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

  Future signUp() async {
    if (emailIdController.text.isEmpty) {
      toast.toast("Please Enter EmailId");
    } else if (signUpPasswordController.text.isEmpty) {
      toast.toast("Please Enter Password");
    } else if (confirmPasswordController.text.isEmpty) {
      toast.toast("Please Enter Confirm Password");
    } else if (signUpPasswordController.text != confirmPasswordController.text) {
      toast.toast("Password Missmatched");
    } else {
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context)=> const Center(child: CircularProgressIndicator()));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailIdController.text.trim(),
            password: confirmPasswordController.text.trim());
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print(e);
          toast.toast(e.message.toString());
        }
      }
      navigatorkey.currentState!.popUntil((route) => route.isFirst);
    }
  }


}
