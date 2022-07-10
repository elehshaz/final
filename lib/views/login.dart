import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor2/models/user.dart';
import 'package:mytutor2/views/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'registerpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double screenHeight, screenWidth, ctrwidth;
  bool remember = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth;
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 160, 195, 255),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: screenHeight / 2.5,
                        width: screenWidth,
                        child: Image.asset('assets/images/learning.png')),
                    const Text(
                      "Admin Login",
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter valid email";
                            }
                            return null;
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: remember,
                          onChanged: (bool? value) {
                            _onRememberMeChanged(value!);
                          },
                        ),
                        const Text("Remember Me"),
                        GestureDetector(
                            child: const Text("Sign Up Here",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RegisterPage()))
                                }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text("Login"),
                        onPressed: _loginUser,
                      ),
                    ),
                  ]),
            ),
          ]),
        )));
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String email = emailController.text;
      String password = passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        emailController.text = "";
        passwordController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMeChanged(bool value) {
    setState(() {
      remember = value;
    });

    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    String email = emailController.text;
    String password = passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        //print(response.body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          var extractdata = data['data'];
          User user = User.fromJson(extractdata);
          print(user.email);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainPage(user: user)));
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
}
