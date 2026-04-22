import 'package:flutter/material.dart';
import 'package:hero_animation/main.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 2'),
        centerTitle: true,
      ),
      body: Center(
        child: Hero(
          tag: item,
          child: buildImage(),
        ),
      ),
    );
  }

  Widget buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.network(
        item.urlImage,
        width: 240,
        height: 240,
        fit: BoxFit.cover,
      ),
    );
  }
}