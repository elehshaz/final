import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/cart.dart';
import '../models/user.dart';
import 'paymentPage.dart';

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  List<Cart> cartList = <Cart>[];
  String titlecenter = "Load Cart...";
  late double screenHeight, screenWidth, resWidth;
  double totalpayable = 0.0;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cartList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
                  ))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Subjects Added",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 0.8),
                        children: List.generate(cartList.length, (index) {
                          return Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/mobile/assets/courses/" +
                                      cartList[index].subid.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(cartList[index].subsession.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 19)),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "RM " +
                                                    double.parse(cartList[index]
                                                            .pricetotal
                                                            .toString())
                                                        .toStringAsFixed(2),
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    deleteItem(index);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
                                            ]),
                                      ],
                                    ),
                                  )),
                            ],
                          ));
                        }))),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Total Payable: RM " +
                              totalpayable.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: PayDialog,
                            child: const Text("Pay Now"))
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void loadCart() {
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_cart.php"),
      body: {
        'email': widget.user.email,
      }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
        return http.Response(
          'Error', 408);
   },
  ).timeout(
    const Duration(seconds: 5),
    onTimeout: () {
      titlecenter = "Timeout Please try again later";
      return http.Response(
        'Error', 408);
    },
  ).then((response){
    var jsondata = jsonDecode(response.body);
    if(response.statusCode == 200 && jsondata['status'] == 'success'){
      var extractdata = jsondata['data'];
      if(extractdata['cart'] != null){
        cartList = <Cart>[];
        extractdata['cart'].forEach((v){
          cartList.add(Cart.fromJson(v));
        });
        int qty = 0;
        totalpayable = 0.00;
        for(var element in cartList){
          qty = qty + int.parse(element.cartquantity.toString());
          totalpayable =
            totalpayable + double.parse(element.pricetotal.toString());

        }
        titlecenter = qty.toString() + "Subjects added";
        setState(() {});
      }
    }else{
      titlecenter = "Your cart is empty.";
      cartList.clear();
      setState(() {});
      }
    });   
  }

  void PayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "PAY NOW",
            style: TextStyle(),
          ),
          content: const Text("Proceed with payment ?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => PaymentPage(
                            user: widget.user, totalpayable: totalpayable)));
                loadCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/delete_cart.php"),
        body: {
          'email': widget.user.email,
          'cartid': cartList[index].cartid
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}