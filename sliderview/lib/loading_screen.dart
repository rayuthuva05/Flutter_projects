import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 221, 221),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [SizedBox(height: 50), AnimatedImage()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'pay-outs');
          },
          child: Icon(Icons.arrow_right_alt_outlined),
        ),
      ),
    );
  }
}

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({super.key});

  @override
  State<AnimatedImage> createState() => _AnimatedImage();
}

class _AnimatedImage extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1500),
  )..repeat(reverse: true);
  late final Animation<Offset> _animation = Tween(
    begin: Offset(0, 0),
    end: Offset(0.15, 0.15),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: _animation,
          child: Image.asset('assets/images/run_person.png'),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'slide');
              },
              child: Text('Move to next'),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  sheetAnimationStyle: AnimationStyle(
                    duration: Duration(seconds: 2),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 400,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Back'),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('Get Bottom sheet'),
            ),
          ],
        ),
      ],
    );
  }
}
