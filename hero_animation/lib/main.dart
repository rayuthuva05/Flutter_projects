import 'package:flutter/material.dart';
import 'screen_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class Item {
  final String urlImage;
  final String title;

  const Item({
    required this.title,
    required this.urlImage
  });
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final items = <Item>[
    Item(
      title: 'Item 1',
      urlImage : 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee'
    ),
    Item(
      title: 'Item 2',
      urlImage : 'https://images.unsplash.com/photo-1501785888041-af3ef285b470'
    ),
    Item(
      title: 'Item 3',
      urlImage : 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee'
    ),
    Item(
      title: 'Item 4',
      urlImage : 'https://images.unsplash.com/photo-1501785888041-af3ef285b470'
    ),
    Item(
      title: 'Item 1',
      urlImage : 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee'
    ),
    Item(
      title: 'Item 2',
      urlImage : 'https://images.unsplash.com/photo-1501785888041-af3ef285b470'
    ),
    Item(
      title: 'Item 3',
      urlImage : 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee'
    ),
    Item(
      title: 'Item 4',
      urlImage : 'https://images.unsplash.com/photo-1501785888041-af3ef285b470'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hero Animation Page"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item= items[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context)=> Screen2(
                    item: item
                  )
                )
              );
            },
            child: Row(
              children: [
                Hero(tag: item,child: buildImage(item.urlImage)),
                const SizedBox(width: 16,),
                Text(
                  item.title,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          );
      })
    );
  }

  Widget buildImage(String urlImage) {
    return Image.network(
      urlImage,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
    );
  }
}