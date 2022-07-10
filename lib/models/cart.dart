class Cart {
  String? cartid;
  String? subname;
  String? subsession;
  String? subprice;
  String? cartquantity;
  String? subid;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.subname,
      this.subsession,
      this.subprice,
      this.cartquantity,
      this.subid,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cart_id'];
    subname = json['subject_name'];
    subsession = json['subject_sessions'];
    subprice = json['subject_price'];
    cartquantity = json['cart_quantity'];
    subid = json['subject_id'];
    pricetotal = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartid;
    data['subject_name'] = subname;
    data['subject_sessions'] = subsession;
    data['subject_price'] = subprice;
    data['cart_quantity'] = cartquantity;
    data['subject_id'] = subid;
    data['price_total'] = pricetotal;
    return data;
  }
}
