import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double screenHeight, screenWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  bool _isChecked = false;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController password2EditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      //upperhalf
      SizedBox(
          height: screenHeight / 2.5,
          width: screenWidth,
          child: Image.asset('assets/images/study.jpg')),

      //lowerhalf
      Container(
        height: 600,
        margin: EdgeInsets.only(top: screenHeight / 5),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                child: Column(children: <Widget>[
                  const Text(
                    //REGISTER FORM
                    "Register New Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      controller: nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                    controller: emailEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        )),

                    /*validator: (value){
                            if( value == null || value.isEmpty){
                              return 'Please enter valid email';
                            }
                          bool emailValid = RegExp()
                            .hasMatch(value);
                          
                          if(!emailValid){
                            return 'Please enter a valid email';
                          }
                            return null;
                            },*/
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                    controller: passwordEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(),
                      icon: Icon(Icons.key),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),

                      /*suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            })*/
                    ),
                    obscureText: true,

                    /*validator: (value) => validatePassword(val.toString()),
                    String? validatePassword(String value){
                      String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*?[0-9]).{6,}$';
                      RegExp regex = RegExp(pattern);
                      if(value.isEmpty){
                        return 'Please enter password';
                      }else{
                        if(!regex.hasMatch(value)){
                          return 'Enter valid password';
                        }else{
                          return null;
                        }
                      }
                    }*/

                    /*{
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (passwordEditingController.text !=
                          password2EditingController) {
                        return "Your password does not match";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 8 characters length";
                      }
                      return null;
                    },*/
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                    controller: password2EditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Re-Enter Password',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.key),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        )),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: null,
                            child: const Text('Agree with terms',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        SizedBox(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            minWidth: 115,
                            height: 50,
                            child: const Text('Register'),
                            elevation: 10,
                            onPressed: _registerAccount,
                          ),
                        ),
                      ]),
                ]),
              ),
              //Already register link here
              //Back Home link here
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already Register ?",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    )),
                GestureDetector(
                  onTap: null,
                  child: const Text(
                    " Login Here",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    ]);
  }

  void _registerAccount() {
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String password = passwordEditingController.text;

    http.post(
        Uri.parse(CONSTANTS.server + "/sedapdough/mobile/php/register.php"),
        body: {
          "name": name,
          "email": email,
          "password": password,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginPage()));
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}

  

/*void _registerAccount() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Register New Account",
          style: TextStyle(),
        ),
        content: const Text(
          "Are You Sure ?",
          style: TextStyle(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              "No",
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}*/
