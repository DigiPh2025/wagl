import 'dart:ui';

import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';
class HexagonClipperProduct extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    final double sideLength = width / 2;

    path.moveTo(width / 2, 0); // Top center
    path.lineTo(width, height * 0.25); // Top right
    path.lineTo(width, height * 0.75); // Bottom right
    path.lineTo(width / 2, height); // Bottom center
    path.lineTo(0, height * 0.75); // Bottom left
    path.lineTo(0, height * 0.25); // Top left
    path.close(); // Complete the hexagon

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // Since the shape won't change
  }
}
class HezaOutline extends StatelessWidget {
  var  assest,iconPath;

  HezaOutline({ super.key,@required this.iconPath,});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: HexagonClipperProduct(),
          child: Container(
            width: 10 * SizeConfig.widthMultiplier,
            height: 5.5 * SizeConfig.heightMultiplier,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Image.asset(
                  "assets/icons/heza_blur_icon.png",
                  width: 10 * SizeConfig.widthMultiplier,
                  height: 5.5 * SizeConfig.heightMultiplier,
                  fit: BoxFit.fill,),
              ),
            ),
          ),
        ),
        Image.asset(
          iconPath,
          width: 6 * SizeConfig.widthMultiplier,
          height: 1.8* SizeConfig.heightMultiplier,
        ),
      ],
    );
  }
}
