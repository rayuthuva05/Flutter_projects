import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sliderview/models/image_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderView extends StatefulWidget {
  const SliderView({super.key});

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  final controller = CarouselSliderController();
  int activeIndex = 0;
  final images = [
    ImageModel(imagePath: 'assets/images/image1.jpg', title: 'Image 1'),
    ImageModel(imagePath: 'assets/images/image2.jpg', title: 'Image 2'),
    ImageModel(imagePath: 'assets/images/image3.jpg', title: 'Image 3'),
    ImageModel(imagePath: 'assets/images/image4.jpg', title: 'Image 4'),
    ImageModel(imagePath: 'assets/images/image5.png', title: 'Image 5'),
  ];

  late bool _isloading;

  @override
  void initState() {
    _isloading = true;
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Carousel Slider'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: _isloading
              ? LoaderSceen()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider.builder(
                      carouselController: controller,
                      options: CarouselOptions(
                        height: 400,
                        autoPlay: true,
                        //viewportFraction: 1,
                        enlargeCenterPage: true,
                        initialPage: 0,
                        //reverse: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index),
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index, realIndex) {
                        final slideImage = images[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slideImage.title,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            buildImage(slideImage.imagePath, index),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    buildIndicator(),
                    const SizedBox(height: 32),
                    buildButtons(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildImage(String img, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.grey,
      child: Image.asset(img, fit: BoxFit.cover),
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: images.length,
      // effect: SlideEffect(
      //   dotWidth: 20,
      //   dotHeight: 20
      // ),
      effect: WormEffect(activeDotColor: Colors.blueAccent),
      onDotClicked: animateToSlide,
    );
  }

  Widget buildButtons({bool stretch = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: previous,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: Icon(Icons.arrow_back, size: 32),
        ),
        stretch ? Spacer() : SizedBox(width: 32),
        ElevatedButton(
          onPressed: next,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: Icon(Icons.arrow_forward, size: 32),
        ),
      ],
    );
  }

  void previous() {
    controller.previousPage(duration: Duration(milliseconds: 500));
  }

  void next() {
    controller.nextPage(duration: Duration(milliseconds: 500));
  }

  void animateToSlide(int index) {
    controller.animateToPage(index);
  }
}

class LoaderSceen extends StatefulWidget {
  const LoaderSceen({super.key});

  @override
  State<LoaderSceen> createState() => _LoaderSceenState();
}

class _LoaderSceenState extends State<LoaderSceen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _shimmerGradient = LinearGradient(
    colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = _controller.value * 2 - 1;

        return ShaderMask(
          shaderCallback: (bounds) {
            return _shimmerGradient.createShader(
              Rect.fromLTWH(dx * bounds.width, 0, bounds.width, bounds.height),
            );
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: _buildContent(),
    );
  }

  Widget loaderContainer() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _shimmerGradient,
      ),
    );
  }

  Widget loadButton() {
    return Container(
      width: 120,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: _shimmerGradient,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 130),
        Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(gradient: _shimmerGradient),
          child: Text(''),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 10,
              height: 140,
              decoration: BoxDecoration(gradient: _shimmerGradient),
              child: Text(''),
            ),
            Container(
              width: 270,
              height: 170,
              decoration: BoxDecoration(gradient: _shimmerGradient),
              child: Text(''),
            ),
            Container(
              width: 10,
              height: 140,
              decoration: BoxDecoration(gradient: _shimmerGradient),
              child: Text(''),
            ),
          ],
        ),
        SizedBox(height: 100),
        Container(
          padding: EdgeInsets.all(5),
          width: 160,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loaderContainer(),
              loaderContainer(),
              loaderContainer(),
              loaderContainer(),
              loaderContainer(),
            ],
          ),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [loadButton(), SizedBox(width: 30), loadButton()],
        ),
      ],
    );
  }
}
