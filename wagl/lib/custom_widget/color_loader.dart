import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'dart:math' as math;

import '../util/SizeConfig.dart';



class ColorLoader extends StatefulWidget {
  final double radius;
  final double dotRadius;

  const ColorLoader({this.radius = 40.0, this.dotRadius = 5.0});

  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<ColorLoader>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation_rotation;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    print(dotRadius);

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );




    controller.addListener(() {
      setState(() {
        // if (controller.value >= 0.75 && controller.value <= 1.0)
        //   radius = widget.radius * animation_radius_in.value;
        // else if (controller.value >= 0.0 && controller.value <= 0.25)
        //   radius = widget.radius * animation_radius_out.value;
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width:  30 * SizeConfig.widthMultiplier,
      height: 15 * SizeConfig.heightMultiplier,
      //color: Colors.black,
      child: Stack(children: [
        Center(
          child:IconButton(
            icon:  Image.asset("assets/icons/wagl_loading_icon.png",
                height: 28 * SizeConfig.heightMultiplier,
                width: 13 * SizeConfig.widthMultiplier,

                fit: BoxFit.contain), onPressed: () {  },
          ),),
        Center(
          child: new RotationTransition(
            turns: animation_rotation,
            child: new Container(
              //color: Colors.limeAccent,
              child: new Center(
                child: Stack(
                  children: <Widget>[
                    CustomRefreshIndicator()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],

      ),
    );
  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
}

class CustomRefreshIndicator extends StatefulWidget {
  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
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
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * math.pi,
          child: CustomPaint(
            painter: CirclePainter(progress: _controller.value),
            child: SizedBox(
              width: 60.0,
              height: 60.0,
            ),
          ),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = colorBlack_2
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = colorPrimary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw foreground arc
    final startAngle = -math.pi / 2; // 12 o'clock position
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}