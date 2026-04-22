import 'package:flutter/material.dart';

class CardBackView extends StatelessWidget {
  const CardBackView({super.key});
  final pi = 3.14;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi * 1),
      origin: Offset(MediaQuery.of(context).size.width / 2, 0),
      child: SizedBox(
        width: 500,
        height: 300,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: Colors.black54,
          color: Colors.white,
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                color: Colors.black87,
                margin: EdgeInsets.only(top: 32, bottom: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 30,
                          width: 200,
                          color: Colors.grey,
                          margin: EdgeInsets.only(right: 12),
                        ),
                        Text(
                          '755',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Container(height: 16, color: Colors.black12),
                    Container(height: 16, color: Colors.black12),
                    Container(height: 16, color: Colors.black12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
