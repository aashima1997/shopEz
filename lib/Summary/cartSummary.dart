import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskanglara/DB/dbhelper.dart';
import '../ResponseModel/Cart.dart';
import '../ResponseModel/categoryResponse.dart';
import '../Screens/homepage.dart';
import '../widgets/CustomWidgets.dart';


class CartSummary extends StatefulWidget {
  const CartSummary({Key? key}) : super(key: key);
  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  List cartList = [];
  int count = 0;
  double totPrice = 0.0;
  var dbhelper = DbHelper();

  @override
  void initState() {
    super.initState();
    EasyLoading.init();
    setState(() {
      retrieveData();
    });
  }

  @override
  void retrieveData() async {
    cartList = await dbhelper.RawQuery("Select * from Cart1");
    print(cartList.toString());
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Product Summary Details',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700)),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.pink.shade300,
          brightness: Brightness.light,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: ListView(
                padding: EdgeInsets.all(10.0),
                children:
                getListings(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];
    double sum=0;
    listings.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.pink.shade300, // background
        onPrimary: Colors.white, // foreground
      ),
      child: const Text('Get Summary'),
      onPressed: () {
        setState((){
        });
        },));
    if(cartList.isNotEmpty){
    for (int i = 0; i < cartList.length; i++) {
      print("kkk");
      setState(() {
        listings.add(Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.pink.shade100,
            ),
            child: SingleChildScrollView(child: Column(children: [
              Icon(Icons.check, color: Colors.pink.shade200, size: 50,),
              AutoSizeText(
                cartList[i]["title"],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              AutoSizeText(
                  "Quantity: " + cartList[i]["quantity"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              AutoSizeText(
                  "Price: " + cartList[i]["price"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            ],))));
        sum = sum + double.parse(cartList[i]["price"]);
      });  }}

    listings.add( Text(
        "cash to Paid: $sum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
    listings.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.pink.shade300, // background
        onPrimary: Colors.white, // foreground
      ),
      child: const Text('Submit and Pay'),
      onPressed: () {
          toast("Order Placed Successfully");
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HomePage(title: "ShopEz",)));

      },));

    return listings;
  }
  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 12.0);
  }
}
