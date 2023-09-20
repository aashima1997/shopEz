import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:taskanglara/service/apiScreenhelper.dart';

import '../Constants.dart';
import '../DB/dbhelper.dart';
import '../ResponseModel/categoryResponse.dart';
import '../widgets/CustomWidgets.dart';
import 'prodListDetail.dart';

class ProductListPage extends StatefulWidget {
   const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}
class _ProductListPageState extends State<ProductListPage> {

  late Future<List<ListResponse>> prodDownload;
late Future<List<String>> catogDownload;
var dbhelper=DbHelper();
  @override
  void initState() {
    prodDownload=ApiScreenHelper.getProd(context);
    catogDownload=ApiScreenHelper.getcatog(context);
    dbhelper.initDb();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: //WillPopScope(
         //   onWillPop: () => onBackPressed(context),
             Scaffold(
               backgroundColor: Colors.pink.shade100,
               // resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  surfaceTintColor: Colors.pink.shade200,
                  centerTitle: true,
                  title:  const Text(
                    "Home",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.pink.shade300,
                ),
                body: FutureBuilder<List>(
                future: Future.wait([prodDownload,catogDownload]),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
        child: Lottie.asset(
      "images/load.json",
        ));
                  }
                  else if (snapshot.data == null) {
                    return TryAgainButton(
                      onPressed: () {
                        setState(() {});
                        },
                    );
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return Column(
                        children: const [
                          Text(
                            "No Data Found",
                            style: TextStyle(
                                fontSize: 17, fontStyle: FontStyle.italic),
                          )
                        ],
                      );
                    } else {
                      return Column(children:[
                        const Padding(padding: EdgeInsets.all(10)),
                      Row(
                       children: [
                       Expanded(child: TextField(decoration: InputDecoration(
                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)
                           ),filled: true,
                         hintText: "Search Categories",
                         fillColor: Colors.white,
                         hintStyle: const TextStyle(
                           color:Colors.black
                         ),
                         prefixIcon: const Icon(Icons.filter_list,color: Colors.black,)
                       ),
                         onTap: (){
                           bottomSheetShow(context,snapshot.data[1]);
                           },
                         readOnly: true,
                       )
                       ),
                         const SizedBox(width: 10,),

                       ],
                      ),
                      Expanded(child:GridView.builder(
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            ),
                        padding: const EdgeInsets.all(5),
                         // shrinkWrap: true,
                        //  physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data![0].length ,
                          itemBuilder: (BuildContext ctx, int index) {
                            final product = snapshot.data![0][index];
                            return GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ListDetailScreen(
                                                details: product))),
                              child:prodWidget(product: product));
                            },
                      ))]);
                    }
                  }
                }))
    );}
void bottomSheetShow(BuildContext ctx,List<String> categ) {
  showModalBottomSheet(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.pink.shade200,
      context: ctx,
      builder: (ctx) => Container(
        color: Colors.white54,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: categ.length,
            itemBuilder: (context,index){
            String catogname=categ[index];
            return ListTile(
              onTap: () async{
                prodDownload= ApiScreenHelper.getProdbyCateg(context,catogname);
                setState(() {});
                Navigator.pop(context);
                },
              leading: const Icon(Icons.shopping_bag_outlined),
              title:Text(categ[index]) ,
            );
            }
        ),
      ));
}


}


