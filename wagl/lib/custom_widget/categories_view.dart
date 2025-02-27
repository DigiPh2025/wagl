import 'package:flutter/material.dart';

import '../util/SizeConfig.dart';
import 'colorsC.dart';
import 'cust_text.dart';

class CategoriesTagView extends StatelessWidget {
  int index;
  var categoriesList;
  CategoriesTagView({required this.index,@required this.categoriesList,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 2 *
              SizeConfig.widthMultiplier),
      decoration: BoxDecoration(
        border: Border.all(

            width: 0.25 *
                SizeConfig
                    .widthMultiplier),
        borderRadius: BorderRadius.all(
            Radius.circular(
              5.5 *
                  SizeConfig
                      .imageSizeMultiplier,
            )),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              categoriesList[
              index],
              width: 5 *
                  SizeConfig
                      .widthMultiplier,
              height: 3 *
                  SizeConfig
                      .heightMultiplier,
            ),
            SizedBox(
              width: 2 *
                  SizeConfig
                      .widthMultiplier,
            ),
            Center(
              child: CustText(
                name: categoriesList[
                index].name,
                size: 1.4,
                colors: colorWhite,
                fontWeightName:
                FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 2 *
                  SizeConfig
                      .widthMultiplier,
            ),
          ],
        ),
      ),
    );
  }
}
