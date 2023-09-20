import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Constants.dart';
import '../ResponseModel/categoryResponse.dart';
import 'package:http/http.dart' as http;
class ApiScreenHelper {
  static Future<List<ListResponse>> getProd(BuildContext context) async {
    var listRes = http.Client();
    var data;
    try {
      var url = Uri.parse(prodUrl);

      var response = await listRes.get(url);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        print("KnowledgerevNo $data");
      }
    } catch (e) {
      print(e);
    }

    return data.map<ListResponse>((e) => ListResponse.fromJson(e)).toList();
  }

  static Future<List<String>> getcatog(BuildContext context) async {
    var data;
    try {
      var res = await http.get(Uri.parse(catogUrl));
       data = jsonDecode(res.body);
    } catch (e) {
      print(e);
    }
    return data.map<String>((e) => e.toString()).toList();

  }
  static Future<List<ListResponse>> getProdbyCateg(BuildContext context,String catName) async {
    var listRes = http.Client();
    var data;
    try {
      var url = Uri.parse(prodbycateg+"/$catName");

      var response = await listRes.get(url);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        print("KnowledgerevNo1 $data");
      }
    } catch (e) {
      print(e);
    }
    return data.map<ListResponse>((e) => ListResponse.fromJson(e)).toList();
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