import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor2/models/user.dart';
import '../constants.dart';
import '../models/subject.dart';
import 'cartpage.dart';

class SubjectPage extends StatefulWidget {
  final User user;
  const SubjectPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject>? subjectList = <Subject>[];
  String titlecenter = "Load Subjects...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;
  TextEditingController searchController = TextEditingController();
  String search = "";
  
  @override
  void initState() {
    super.initState();
    loadSubjects(1, search);
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
        centerTitle: true,
        title: const Text('MyTutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              /*if (widget.user.email == "guest@shahida.com") {
                loadOptions();
              } else {*/
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CartPage(
                            user: widget.user,
                          )));
              loadSubjects(1, search);
              loadMyCart();
            },
            //},//
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: subjectList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Subjects Available",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 1),
                        children: List.generate(subjectList!.length, (index) {
                          return Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/mobile/assets/courses/" +
                                      subjectList![index].subjectId.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                  flex: 5,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            subjectList![index]
                                                .subjectName
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                subjectList![index]
                                                        .subjectSessions
                                                        .toString() +
                                                    " Sessions",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black)),
                                            Expanded(
                                                child: IconButton(
                                                    onPressed: () {
                                                      addcartDialog(index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.shopping_cart,
                                                        size: 15))),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                "Rating: " +
                                                    double.parse(
                                                            subjectList![index]
                                                                .subjectRating
                                                                .toString())
                                                        .toStringAsFixed(2) +
                                                    "/5",
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.orange)),
                                            Text(
                                                "RM " +
                                                    double.parse(
                                                            subjectList![index]
                                                                .subjectPrice
                                                                .toString())
                                                        .toStringAsFixed(2),
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ));
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.blue;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {loadSubjects(index + 1, search)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList!.add(Subject.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Subject Available";
          setState(() {});
        }
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Search ",
            ),
            content: SizedBox(
              height: screenHeight / 5,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        labelText: 'Enter Subject',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void addcartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.black)),
          title: const Text(
            "ADD TO CART",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure ?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                addtoCart(index);
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

  void loadMyCart() {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_mycart.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['cart_total'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['cart_total'].toString();
        });
      }
    });
  }

  void addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subid": subjectList![index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['cart_total'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['cart_total'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Preference Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }
}
