import 'package:flutter/material.dart';

import '../util/SizeConfig.dart';
import 'colorsC.dart';

class IndicatorWidget extends StatelessWidget {
  int index;
  int count;
  var context;

  IndicatorWidget({required this.index, required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (15 + 3 / 4) * SizeConfig.widthMultiplier,
      decoration: const BoxDecoration(
        color: borderColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.5 * SizeConfig.widthMultiplier),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width:
                            (12.7) * SizeConfig.widthMultiplier,
                        height: 1 * SizeConfig.heightMultiplier,
                        child: Container(

                          child: ListView.builder(
                            itemCount: count,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.widthMultiplier * 1.75),
                                  child: /*Container(
                                    width: 3 * SizeConfig.widthMultiplier,
                                    height: 1 * SizeConfig.heightMultiplier,
                                    decoration: const BoxDecoration(

                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                          topLeft: Radius.circular(50)),
                                      color: colorGrey,
                                    ),
                                  ),*/
                                      Container(
                                    width: 2.8 * SizeConfig.widthMultiplier,
                                    height: 1 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                  ));
                            },
                          ),
                        ),
                      ),
                      /*   Container(
                        width: 2 * SizeConfig.widthMultiplier,
                        height: 1 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              topLeft: Radius.circular(50)),
                          color: colorGrey,
                        ),
                      ),
                      SizedBox(width: 1*SizeConfig.widthMultiplier,),
                      Container(
                        width: 2 * SizeConfig.widthMultiplier,
                        height: 1 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              topLeft: Radius.circular(50)),
                          color: colorGrey,
                        ),
                      ),*/
                    ],
                  ),
                ),
                Container(
                  width: (index * (index == 1 ? 2.3 : 4)) *
                      SizeConfig.widthMultiplier,
                  height: 1 * SizeConfig.heightMultiplier,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: colorPrimary,
                      shape: BoxShape.rectangle),
                ),
              ],
            ),
            // Container(
            //   width: 2*SizeConfig.widthMultiplier,
            //   height:  1*SizeConfig.heightMultiplier,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.zero,
            //     color: colorPrimary,
            //   ),
            // ),
            // Container(
            //   width: 2*SizeConfig.widthMultiplier,
            //   height:  1*SizeConfig.heightMultiplier,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         topRight: Radius.circular(50),
            //         bottomRight: Radius.circular(50)),
            //     color: colorPrimary,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
