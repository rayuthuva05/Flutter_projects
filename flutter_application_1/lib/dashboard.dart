import 'package:flutter/material.dart';
//import 'package:flutter_application_1/about.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, super.key});

  @override
  State<Dashboard> createState() => _DashBoardState();
}

class _DashBoardState extends State<Dashboard> {
  late String email;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column (
       mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text('Saha Holdings')
        ],
      )
    )
    );
  }
}
