import 'dart:convert';
import 'login.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  bool _isnotvalidate = false;
  bool _isnotvalidate2 = false;
  bool _isnotvalidate3 = false;
  void registerUser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        cpasswordController.text.isNotEmpty) {
      if (passwordController.text == cpasswordController.text) {
        var regBody = {
          "email": emailController.text,
          "password": passwordController.text,
          "confirmpassword": cpasswordController.text
        };

        var response = await http.post(Uri.parse(registration),
            headers: {"Context-Type": 'application/json'},
            body: jsonEncode(regBody));

        var jsonResponse = jsonDecode(response.body);

        print(jsonResponse['status']);

        if (jsonResponse['status']) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignupPage()));
        } else {
          print("Something went wrong");
        }
      } else {
        print("Password are not match");
      }
    } else {
      setState(() {
        if (emailController.text.isEmpty) _isnotvalidate = true;

        if (passwordController.text.isEmpty) _isnotvalidate2 = true;

        if (cpasswordController.text.isEmpty) _isnotvalidate3 = true;
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
                'Register',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Register Card
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Name TextField
                      /*TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          errorStyle: TextStyle(color: Colors.white),
                          errorText:
                              _isnotvalidate ? "Enter Proper Info" : null,
                        ),
                      ),
                      SizedBox(height: 20),*/
                      // Email TextField
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Email',
                          errorStyle: const TextStyle(color: Colors.red),
                          errorText: _isnotvalidate ? "*Required" : null,
                          hintText: "Email",
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Phone TextField
                      /*TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',
                          errorStyle: TextStyle(color: Colors.white),
                          errorText:
                              _isnotvalidate ? "Enter Proper Info" : null,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Address TextField
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Address',
                          errorStyle: TextStyle(color: Colors.white),
                          errorText:
                              _isnotvalidate ? "Enter Proper Info" : null,
                        ),
                      ),
                      SizedBox(height: 20),
                      // District Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Select District',
                          errorStyle: TextStyle(color: Colors.white),
                          errorText:
                              _isnotvalidate ? "Enter Proper Info" : null,
                        ),
                        items: ['District 1', 'District 2', 'District 3']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      SizedBox(height: 20),
                      // User Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Select a User Type',
                          errorStyle: TextStyle(color: Colors.white),
                          errorText:
                              _isnotvalidate ? "Enter Proper Info" : null,
                        ),
                        items: ['User Type 1', 'User Type 2', 'User Type 3']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      SizedBox(height: 20),*/
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
                      // Confirm Password TextField
                      TextField(
                        controller: cpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          errorStyle: const TextStyle(color: Colors.red),
                          errorText: _isnotvalidate3 ? "*Required" : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Register Button
                      ElevatedButton(
                        onPressed: () => {registerUser()},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Already Registered? Login Here
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Already Registered? Login Here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
