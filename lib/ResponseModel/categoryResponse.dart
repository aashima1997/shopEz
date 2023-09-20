import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';

//List<ListResponse> postFromJson(String str) => List<ListResponse>.from(json.decode(str).map((x) => ListResponse.fromJson(x)));

//String postToJson(List<ListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListResponse {
  final int id;
 final String title;
 final String description;
 final String image;
 final  dynamic price;
  final Rating rating;

  ListResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.rating
  });
  factory ListResponse.fromJson(Map<String, dynamic> json) => ListResponse(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
      price: json["price"].toDouble(),
      rating: Rating(
        rate: json['rating']['rate'],
        count: json['rating']['count'],
      )

  );
  Map<String, dynamic> toJson() => {
    "description": description,
    "id": id,
    "title": title,
    "image":image,

  };
}
  class Rating{
  dynamic rate;
  int count;

  Rating({required this.rate, required this.count});



}
