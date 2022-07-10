import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/tutor.dart';
import '../models/user.dart';

class TutorPage extends StatefulWidget {
  final User user;
  const TutorPage({Key? key, required this.user,}) : super(key: key);

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  List<Tutor>? tutorList = <Tutor>[];
  String titlecenter = "Load Tutors...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
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
        title: const Text('My Tutor'),
        centerTitle: true,
      ),
      body: tutorList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Tutors Available",
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
                        children: List.generate(tutorList!.length, (index) {
                          return InkWell(
                            splashColor: Colors.amber,
                            onTap: () => {_loadTutorDetails(index)},
                            child: Card(
                                child: Column(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                        "/mytutor/mobile/assets/tutors/" +
                                        tutorList![index].tutorId.toString() +
                                        '.jpg',
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
                                              tutorList![index]
                                                  .tutorName
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                          Text(
                                            tutorList![index]
                                                .tutorEmail
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            )),
                          );
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
                            onPressed: () => {_loadTutors(index + 1)},
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

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList!.add(Tutor.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Tutor Available";
          setState(() {});
        }
      }
    });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor/mobile/assets/tutors/" +
                      tutorList![index].tutorId.toString() +
                      '.jpg',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 15),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Name:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14)),
                  Text(tutorList![index].tutorName.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Email:", style: TextStyle(fontSize: 14)),
                  Text(tutorList![index].tutorEmail.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Phone:", style: TextStyle(fontSize: 14)),
                  Text(tutorList![index].tutorPhone.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("About:", style: TextStyle(fontSize: 14)),
                  Text(tutorList![index].tutorDesc.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Subject:", style: TextStyle(fontSize: 14)),
                  Text(tutorList![index].subjectName.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                ])
              ],
            )),
            actions: [
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
}
