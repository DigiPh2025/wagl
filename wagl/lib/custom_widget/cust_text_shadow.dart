import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import '../util/SizeConfig.dart';

// ignore: must_be_immutable
class CustTextShadow extends StatelessWidget {
  var name, size, colors, textAlign, fontWeightName, maxLine;

  CustTextShadow({
    @required this.name,
    @required this.size,
    @required this.colors,
    @required this.textAlign,

    @required this.fontWeightName,
    @required this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Text(
      name,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: "Gilroy",
        color: colors??colorWhite,
        fontWeight: fontWeightName,
        fontSize: size * SizeConfig.textMultiplier/scaleFactor,
        shadows: <Shadow>[
          Shadow(
            offset:
            Offset(0.5, 0.5),
            blurRadius: 2.0,
            color: Color.fromARGB(
                255, 0, 0, 0),
          ),
          /*  Shadow(
                                                        offset: Offset(10.0, 10.0),
                                                        blurRadius: 8.0,
                                                        color: Color.fromARGB(125, 0, 0, 255),
                                                      ),*/
        ],
      ),
    );
  }
}
