import 'package:flutter/material.dart';

import '../util/SizeConfig.dart';
import 'colorsC.dart';
import 'cust_text.dart';

class CustModalBottomSheet extends StatelessWidget {
  var height,child;
  String title;
   CustModalBottomSheet({super.key,required this.height,required this.title,required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
      height * SizeConfig.heightMultiplier,
      width:
      100 * SizeConfig.widthMultiplier,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              child: Image.asset(
                "assets/background/dailog_bg.png",
                width: 100 *
                    SizeConfig
                        .widthMultiplier,
                height: 10 *
                    SizeConfig
                        .heightMultiplier,
                fit: BoxFit.fill,
              )),
          Positioned(
            top: 3 *
                SizeConfig.heightMultiplier,
            child: Column(
              children: [
                Container(
                  decoration:
                  const BoxDecoration(
                    shape:
                    BoxShape.rectangle,
                    color: colorBlack2Light,
                    borderRadius:
                    BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  height: 0.7 *
                      SizeConfig
                          .heightMultiplier,
                  width: 12.5 *
                      SizeConfig
                          .widthMultiplier,
                ),
                SizedBox(
                  height: 6 *
                      SizeConfig
                          .widthMultiplier,
                ),
                CustText(
                  name: title,
                  size: 2.0,
                  colors: colorWhite,
                  fontWeightName:
                  FontWeight.w800,
                ),
                SizedBox(
                  height: 4 *
                      SizeConfig
                          .widthMultiplier,
                ),
                SizedBox(
                  height: 5 *
                      SizeConfig
                          .heightMultiplier,
                  width: 100 *
                      SizeConfig
                          .widthMultiplier,
                  child: Divider(
                    color: borderColor,
                    indent: 3 *
                        SizeConfig
                            .widthMultiplier,
                    endIndent: 3 *
                        SizeConfig
                            .widthMultiplier,
                    thickness: 1,
                  ),
                ),
                SizedBox(height: 10*SizeConfig.heightMultiplier,),
               child,
              ],
            ),
          )
        ],
      ),
    );
  }
}
