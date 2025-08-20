import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'home.dart'; // Import the home.dart file
import 'signup.dart'; // Import the signup.dart file
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isnotvalidate = false;
  bool _isnotvalidate2 = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Context-Type": 'application/json'},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        print("Something went wrong");
      }
    } else {
      setState(() {
        if (emailController.text.isEmpty) _isnotvalidate = true;
        if (passwordController.text.isEmpty) _isnotvalidate2 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Title
              const Text(
                'SAHA HOLDINGS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'FIND YOUR RIGHT FIT',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              // Login Card
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Email TextField
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Email',
                          errorStyle: const TextStyle(color: Colors.red),
                          errorText: _isnotvalidate ? "*Required" : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password TextField
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          errorStyle: const TextStyle(color: Colors.red),
                          errorText: _isnotvalidate2 ? "*Required" : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Create Account
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: const Text('Create an Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
