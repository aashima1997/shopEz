import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:taskanglara/ResponseModel/categoryResponse.dart';

import '../Screens/productList.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../main.dart';

errordialog(dialogContext, String title, String description) {
  var alertStyle = const AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle:
    TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: dialogContext,
      style: alertStyle,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            },
          color: Colors.pinkAccent,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ]).show();
}
Future logout(BuildContext context) async {
  final FirebaseAuth? auth = FirebaseAuth.instance;
  showDialog(context: context,
      barrierDismissible: false,
      builder: (context)=> const Center(child: CircularProgressIndicator()));
  await auth!.signOut();
  navigatorkey.currentState!.popUntil((route) => route.isFirst);
}

class prodWidget extends StatelessWidget {
  const prodWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ListResponse product;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child:Card(
            color: Colors.white,
            elevation: 0,
            shadowColor: Colors.pink.shade200,
            child:Padding(
                padding: const EdgeInsets.all(5),
                child:  Column(
                   // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[Image.network(product.image,
                      width: 100,height: 80,),
                     const SizedBox(height:5),
                      AutoSizeText(product.title,maxLines: 3),
                      Text("Rs.${product.price.toString()}",maxLines: 2,style: const TextStyle(fontWeight: FontWeight.bold),),
                       ]))));
  }
}
class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key? key, this.onPressed}) : super(key: key);
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Lottie.asset("images/tryagain.json", width: 400,height: 300),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: onPressed,
                child: const Text("Try Again")),
          ],
        ));
  }
}
Future<bool> onBackPressed(BuildContext context, ) async {
  return (await Alert(
    context: context,
    type: AlertType.warning,
    title:"Cancel",
    desc:
    "Are you sure want to cancel?",
    buttons: [
      DialogButton(
        onPressed:() {
         Navigator.pop(context);
        },
        width: 120,
        child: const Text(
          "Yes",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      DialogButton(
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
        child: const Text(
          "No",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show()) ??
      false;
}
