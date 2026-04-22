import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadialMenuApp extends StatelessWidget {
  const RadialMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(child: RadialMenu()),
      appBar: AppBar(
        title: Text(
          'Radial Menu',
          style: TextStyle(
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 3,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        foregroundColor: const Color.fromARGB(255, 6, 38, 65),
      ),
    );
  }
}

class RadialMenu extends StatefulWidget {
  const RadialMenu({super.key});

  @override
  State<RadialMenu> createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({Key? key, required this.controller})
    : scale = Tween<double>(
        begin: 1.5,
        end: 0.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut)),

      transition = Tween<double>(
        begin: 0.0,
        end: 140.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutBack)),
      super(key: key);

  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> transition;

  final List<double> angles = [180, 210, 240, 270];
  final List<FaIconData> icons = [
    FontAwesomeIcons.houseMedical,
    FontAwesomeIcons.brandsFontAwesome,
    FontAwesomeIcons.trafficLight,
    FontAwesomeIcons.batteryFull,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, builder) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ...List.generate(angles.length, (index) {
                return _buildButton(
                  angles[index],
                  color: Colors.grey.shade300,
                  icon: icons[index],
                );
              }),
              Transform.scale(
                scale: scale.value - 1,
                child: FloatingActionButton(
                  heroTag: "closeBtn",
                  onPressed: _close,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: FaIcon(FontAwesomeIcons.circleXmark),
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: FloatingActionButton(
                  heroTag: "openBtn",
                  onPressed: _open,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: FaIcon(FontAwesomeIcons.circleDot),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _open() {
    controller.forward();
  }

  void _close() {
    controller.reverse();
  }

  _buildButton(double angle, {Color? color, FaIconData? icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          (transition.value) * cos(rad),
          (transition.value) * sin(rad),
        ),
      child: FloatingActionButton(
        heroTag: angle.toString(),
        onPressed: _close,
        backgroundColor: color,
        child: FaIcon(icon),
      ),
    );
  }
}
