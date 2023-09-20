import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskanglara/DB/dbhelper.dart';
import 'package:taskanglara/Summary/cartSummary.dart';
import 'package:taskanglara/service/apiScreenhelper.dart';
import '../ResponseModel/Cart.dart';
import '../ResponseModel/categoryResponse.dart';
import '../widgets/CustomWidgets.dart';


class ListDetailScreen extends StatefulWidget {
   ListDetailScreen({Key? key,required this.details}) : super(key: key);
  final ListResponse details;
  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  List cartList=[];
  int count=0;
double totPrice=0.0;
var toast=ApiScreenHelper();
var dbhelper=DbHelper();
  @override
  void initState() {
    super.initState();
    retrieveData();
  }
  void retrieveData() async {
    int id=widget.details.id;
    cartList =
    await dbhelper.RawQuery("Select quantity,price from Cart1 where id=$id");
    if(cartList.isNotEmpty) {
      setState((){
        count=int.parse(cartList[0]["quantity"]);
        totPrice=double.parse(cartList[0]["price"]);
      });}

    else{
      setState((){
        count=0;
        totPrice=0;
      });
    }}

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      bottom: false,
        child:  Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  centerTitle: true,
                   title:  const Text(
                    "Product Details",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  ),
                  iconTheme: const IconThemeData(color: Colors.black),
                  backgroundColor: Colors.pink.shade300,
                ),
                body:
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             const Padding(padding: EdgeInsets.all(10)),
                      Expanded(child:  Image.network(widget.details.image,
                                width: 250,height: 250,),),
                              Container(
                                margin: const EdgeInsets.all(10),
                                height:40,width: 200,decoration: BoxDecoration(
                                  color: Colors.pink.shade300,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                       const Text("Add to Cart:   ",style: TextStyle(color: Colors.black),),
                               InkWell(
                                   onTap:(){
                                     setState((){
                                       if(count>=1) {
                                         count--;
                                         totPrice=(count.toDouble()*widget.details.price);
                                       }
                                     });
                                   } ,
                                   child:const Icon(Icons.remove,color:Colors.black)
                               ),  Text("   $count   ",style: const TextStyle(color: Colors.white),
                               ),
                               InkWell(
                                   onTap:(){
                                     setState((){
                                       count++;
                                       totPrice=(count.toDouble()*widget.details.price);
                                     });
                                   } ,
                                   child:const Icon(Icons.add,color:Colors.black)
                               ),
                             ],),),
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(40),
                                  height: MediaQuery.of(context).size.height*0.5,
                              width: double.infinity,
                              decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                              ),
                                color: Colors.pink.shade100,
                              ),child:SingleChildScrollView(child:Column(children: [
                                Text(widget.details.title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                  const SizedBox(height: 10,),
                                  Text("Rs.${widget.details.price}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                const SizedBox(height: 10,),
                                Text(widget.details.description),
                                const SizedBox(height: 20,),
                                Text("Total Price:  $totPrice",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 26),),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    height: 50,

                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.pink.shade300, // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      child: const Text('Proceed'),
                                      onPressed: () {
                                        if(count==0){
                                          toast.toast("Add Quantity to Proceed");
                                        }else {
                                          addCart();
                                          }},)
                                ),
                              ],)
                              ) )])));
  }

  void addCart() async{
    var id=widget.details.id.toString();
 String   username=FirebaseAuth.instance.currentUser!.uid!;
    Cart cartItems=Cart(
        widget.details.id.toString(),
        widget.details.title,
        count,
        totPrice,username,""
    );

    cartList=await dbhelper.RawQuery("Select * from Cart1");
    List existQuant=await dbhelper.RawQuery("Select quantity from Cart1 where id=$id");
print("cartList"+cartList.toString());
print("existQuant"+existQuant.toString());
    if(cartList.isEmpty||existQuant.isEmpty){
        await dbhelper.saveData(cartItems);
        cartList=await dbhelper.RawQuery("Select * from Cart1");
        print("cartList"+cartList.toString());
    }
    else{
     await dbhelper.RawQuery("UPDATE Cart1 SET quantity = $count WHERE id = $id");
     await dbhelper.RawQuery("UPDATE Cart1 SET price = $totPrice WHERE id = $id");
     cartList=await dbhelper.RawQuery("Select * from Cart1");
    }
Navigator.of(context).push(
    MaterialPageRoute(
        builder: (BuildContext context) =>
            CartSummary()));
  }}

/*Container(height:85,width: 100,decoration: BoxDecoration(
color: Colors.pink.shade300,
borderRadius: BorderRadius.circular(10)
),),
Padding(padding: const EdgeInsets.all(5)),
Expanded(    child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
InkWell(
onTap:(){
setState((){
if(count>=1) {
count--;
}
});
} ,
child:const Icon(Icons.remove,color:Colors.pink)
),  Text(count.toString(),style: TextStyle(color: Colors.white),
),
InkWell(
onTap:(){
setState((){
count++;
});
} ,
child:const Icon(Icons.add,color:Colors.white)
)
],
)),*/