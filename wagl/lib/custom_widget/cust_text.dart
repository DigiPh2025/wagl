import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import '../util/SizeConfig.dart';

// ignore: must_be_immutable

String toProperGrammar(String text) {
  if (text == null || text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
class CustText extends StatelessWidget {
  var name, size, colors, textAlign, fontWeightName, maxLine,isCapital;

  String toProperGrammar(String text) {
    if (text == null || text.isEmpty|| isCapital==true) return text;
    return text
        .split('. ') // Split by full stops followed by a space
        .map((sentence) => sentence.isNotEmpty
        ? sentence[0].toUpperCase() + sentence.substring(1).toLowerCase()
        : '') // Capitalize first letter of each sentence
        .join('. '); // Join the sentences back with '. '
  }
  CustText({
    @required this.name,
    @required this.size,
    @required this.colors,
    @required this.textAlign,
    @required this.isCapital,
    @required this.fontWeightName,
    @required this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Text(
      toProperGrammar(name),
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: "Gilroy",
        color: colors,
        fontWeight: fontWeightName,
        fontSize: size * SizeConfig.textMultiplier/scaleFactor,
      ),
    );
  }
}
class CustTextBold extends StatelessWidget {
  var name, size, colors, textAlign, fontWeightName, maxLine,borderColors;

  CustTextBold({
    @required this.name,
    @required this.size,
    @required this.colors,
    @required this.textAlign,
    @required this.fontWeightName,
    @required this.maxLine,
    @required this.borderColors,
  });

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Text(
      toProperGrammar(name),
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: "Gilroy-Bold",
        color: colors,
        fontWeight: fontWeightName,
        fontSize: size * SizeConfig.textMultiplier/scaleFactor,
        shadows: [
          Shadow(
            blurRadius:5.0,  // shadow blur
            color: borderColors??colorBlack, // shadow color
            offset: Offset(0.0,2.0), // how much shadow will be shown
          ),
        ],
      ),
    );
  }
}