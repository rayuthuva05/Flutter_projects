import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "e-Teacher.lk",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Home(),
              ),
              Container(
                child: logout(),
              )
            ]),
          ]),
          backgroundColor: const Color.fromARGB(255, 25, 8, 214),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
                child: Text(
                  "Hi, [user] Please choose your payment option",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                margin:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20)),
            Text(
              "Select a preferred payment option to continue your purchase. All transactions are secure and encrypted.",
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Card(
                child: Text(
                  "- Start your 7-day free trial today and activate your tutor profile. Reach students and explore opportunities — no payment required.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                margin:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 8)),
            Card(
                child: Text(
                  "- Choose a payment method to activate your tutor profile for just LKR 1,000/month. Reach more students and start receiving job offers today. Secure and fast checkout.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                margin:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 8)),
            Card(
                child: Text(
                  "- Choose the LKR 10,000/year plan to activate your tutor profile. Save more with yearly billing and get continuous access to student job offers.",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                margin:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 8)),
            Card(
              margin: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        Text(
                          "7 days trial",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Cancel anytime",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        MaterialButton(
                          onPressed: () {
                            ShowDialogBox(context, '1 student');
                          },
                          child: Text("Choose"),
                          color: Colors.green,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                    Container(
                      height: 80,
                      width: 1,
                      color: Colors.green,
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        Text(
                          "Monthly",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "LKR.1000",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {
                            ShowDialogBox(context, "5 students");
                          },
                          child: Text("Choose"),
                          color: Colors.green,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                    Container(
                      height: 80,
                      width: 1,
                      color: Colors.green,
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        Text(
                          "Annually",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "LKR.10000",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   "Access Limit 100 students",
                        //   style: TextStyle(
                        //       fontSize: 11,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.grey),
                        // ),
                        MaterialButton(
                          onPressed: () {
                            ShowDialogBox(context, "100 students");
                          },
                          child: Text("Choose"),
                          color: Colors.green,
                          textColor: Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Home() {
    return Container(
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightGreen,
      ),
    );
  }

  Widget logout() {
    return Container(
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightGreen,
      ),
    );
  }

  void ShowDialogBox(BuildContext context, String limitation) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                ),
                MaterialButton(
                  onPressed: () {},
                  child:
                      Text("Continue", style: TextStyle(color: Colors.white)),
                  color: Colors.blueAccent,
                )
              ],
              title: Text('Confirm Payment'),
              content: Text(
                "You can access ${limitation}. Are you sure you want to activate your tutor profile with the selected plan?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.all(20),
            ));
  }
}
