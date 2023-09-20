class Cart {
  String? id;
  String? title;
    int? quantity;
   double? price;
   String? email;
   String? password;
  Cart(
      this.id,
      this.title,
      this.quantity,
      this.price,
      this.email,
      this.password
      );
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'quantity': quantity,
      'price':price,
      'email':email,
      'password':password,
    };
    return map;
  }

  Cart.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    quantity = map['quantity'];
    price = map['price'];
    email = map['email'];
    password = map['password'];

  }
}
