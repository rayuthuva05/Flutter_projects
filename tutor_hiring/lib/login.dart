import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "e-Teacher.lk",
                    style:
                        TextStyle(color: const Color.fromARGB(255, 99, 98, 95)),
                  )),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                child: register(),
              )
            ]),
          ]),
          backgroundColor: const Color.fromARGB(255, 25, 8, 214),
        ),
        body: Column(
          children: [
            Container(
              child: Center(
                child: Text(
                  'SignIn',
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 25, 8, 214)),
                ),
              ),
              margin: EdgeInsets.all(20),
            ),
            Container(
              alignment: Alignment(0, 0),
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Enter username',
                            style: TextStyle(color: Colors.black38)),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Enter Password',
                            style: TextStyle(color: Colors.black38)),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 5),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {}, child: Text('forgot password?')),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: const Color.fromARGB(255, 25, 8, 240),
                      //hoverColor: const Color.fromARGB(255, 231, 234, 231),
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {},
                        child: Text('Don\'t have an account? signup')),
                  )
                ],
              ),
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(134, 233, 231, 231),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget register() {
    return Container(
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          "SignUp",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightGreen,
      ),
    );
  }
}
