class User {
  String? id;
  String? name;
  String? email;
  String? phoneno;
  String? address;
  String? cart;

  User({this.id, this.name, this.email, this.phoneno, this.address,this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    address = json['address'];
    cart = json['cart'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneno'] = phoneno;
    data['address'] = address;
    data['cart'] = cart.toString();
    return data;
  }
}
