import 'package:flutter/material.dart';

import '../util/SizeConfig.dart';
import 'colorsC.dart';
import 'cust_text.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final textColor;
  final int trimLines;

  ReadMoreText({required this.text, this.trimLines = 4, this.textColor});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _readMore = true;

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    final text = widget.text;
    final trimLines = widget.trimLines;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Create a TextSpan with the full text
        final textSpan = TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: "Gilroy",
            color: widget.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
          ),
        );

        // Use a TextPainter to determine the number of lines
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: trimLines,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(
            minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);

        // Check if the text exceeds the specified number of lines
        final exceeded = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_readMore && exceeded)
              Text.rich(
                textSpan,
                maxLines: trimLines,
                overflow: TextOverflow.ellipsis,
              )
            else
              CustText(
                name: text,
                size: 1.6,
                colors: widget.textColor,
                fontWeightName: FontWeight.w500,
              ),
            if (exceeded)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _readMore = !_readMore;
                  });
                },
                child: _readMore
                    ? readMoreIcon()
                    : readMoreIcon()
              ),
          ],
        );
      },
    );
  }

}
class readMoreIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
          color: colorWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 0.4*SizeConfig.heightMultiplier),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 1 * SizeConfig.widthMultiplier),
            Container(
              width: 1 * SizeConfig.widthMultiplier,
              height: 1 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: colorBlack),
            ),
            Container(
              width: 1 * SizeConfig.widthMultiplier,
              height: 1 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: colorBlack),
            ),
            Container(
              width: 1 * SizeConfig.widthMultiplier,
              height: 1 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: colorBlack),
            ),
            SizedBox(width: 1 * SizeConfig.widthMultiplier),
          ],
        ),
      ),
    );
  }

}