import 'dart:ui';

import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';
import 'hexa_outline_widget.dart';
class HexagonBorder extends StatelessWidget {
  var iconPath;

  HexagonBorder({ super.key,@required this.iconPath,});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: HexagonClipperProduct(),
          child: Container(
            width: 7 * SizeConfig.widthMultiplier,
            height: 3.8 * SizeConfig.heightMultiplier,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Image.asset(
                  "assets/icons/hexagon_border.png",
                  width: 10 * SizeConfig.widthMultiplier,
                  height: 5.5 * SizeConfig.heightMultiplier,
                  fit: BoxFit.fill,),
              ),
            ),
          ),
        ),

        Center(
          child: Image.asset(
            "assets/icons/right_arrow_icon.png",
            width: 2 * SizeConfig.widthMultiplier,
            height: 1.5* SizeConfig.heightMultiplier,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
