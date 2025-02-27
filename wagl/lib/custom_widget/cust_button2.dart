  import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';
import 'colorsC.dart';


class CustButton1 extends StatelessWidget {

  var name,size;
  final Function(bool) onSelected;

  CustButton1({
    @required this.name,
    @required this.size,
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GestureDetector(
      onTap:() {
        onSelected(true);
      },
      child: Container(
        width: size * SizeConfig.widthMultiplier,
        height: 4.5 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c_blue1,c_blue1,c_purple],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.all(Radius.circular(
            5 * SizeConfig.imageSizeMultiplier,
          )),
          shape: BoxShape.rectangle,
        ),
        child: Center(
            child: Text(name,
                style: TextStyle(
                    fontFamily: "Gilroy",
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize:
                    1.8 * SizeConfig.textMultiplier/scaleFactor))),
      ),
    );
  }
}
