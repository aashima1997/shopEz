import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskanglara/Summary/cartSummary.dart';
import 'package:taskanglara/main.dart';
import 'package:taskanglara/widgets/CustomWidgets.dart';

import '../DB/dbhelper.dart';
import 'productList.dart';

class HomePage extends StatelessWidget {
  final String title;
  final FirebaseAuth? auth = FirebaseAuth.instance;
 // final  User currentUser = FirebaseAuth.instance.currentUser!;
var dbhelper=DbHelper();
   HomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.pink,
      ),
      body:Column(children:[
      Container(margin: EdgeInsets.all(25),
        child:Text(
            'Dont be Slow, '
                'Our Prices are Low!.',
            style: TextStyle(fontSize:50.0,color: Colors.pink.shade300),
          )),
        Container(margin:EdgeInsets.all(5),child:Image(
          image: AssetImage('images/pinkiss-shop.gif'),
          width: 300,
        ),),
        Container(margin: EdgeInsets.all(25),
            child:Text(
              'Grab it Soon.',
              style: TextStyle(fontSize:50.0,color: Colors.pink.shade300),
            )),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.pink.shade300, // background
            onPrimary: Colors.white, // foreground
          ),
          child: const Text('View Products for Sale'),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ProductListPage()));

          },)]),
      drawer:Drawer(
        child: ListView(
          padding:  const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration:  const BoxDecoration(
                color: Colors.pinkAccent,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.pinkAccent),
                accountName: Text(
                  FirebaseAuth.instance.currentUser!.uid!,
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: Text(FirebaseAuth.instance.currentUser!.email!),
                currentAccountPictureSize: const Size.square(50),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child:Icon(Icons.person,color: Colors.pink,) //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              title: const Text(' Home ',style:TextStyle(color: Colors.black)),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProductListPage()),
                );            },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Summary '),
              onTap: () async {
                List cartList=await dbhelper.RawQuery("Select * from Cart1");
                if(cartList.isEmpty){
                  toast("Please add Products");
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CartSummary()),
                  );   }           },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                logout(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ), //Drawer
    );
  }
  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 15.0);
  }
}

