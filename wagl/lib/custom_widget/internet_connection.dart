import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import '../util/SizeConfig.dart';
import 'cust_button.dart';
import 'cust_text.dart';

class internetConnection extends StatelessWidget{

  final Function(bool) onSelected;

  internetConnection({
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/icons/Disconnected.png',
          height: 50 * SizeConfig.imageSizeMultiplier,
          width: 70 * SizeConfig.imageSizeMultiplier,),
        SizedBox(height: 2 * SizeConfig.heightMultiplier),
        CustText(name: "Oops, your connection\nseems off...", size: 2.5, colors: Colors.white,
            textAlign:TextAlign.center,fontWeightName:FontWeight.w700),
        SizedBox(height: 5 * SizeConfig.heightMultiplier),
        Padding(
          padding:  EdgeInsets.only(left: 5 * SizeConfig.heightMultiplier,right: 5 * SizeConfig.heightMultiplier),
          child: CustText(name: "Keep calm and press the refresh button to try again", size: 1.8, colors: Colors.white,
              textAlign:TextAlign.center,fontWeightName:FontWeight.w500),
        ),
        SizedBox(height: 3 * SizeConfig.heightMultiplier),
        CustButton(name: "Refresh", size: 35,
            width: 95,
            height: 6,
            onSelected:  () async {
              onSelected(true);
            }, btnColor: colorPrimary, fontColor: colorWhite,),
      ],
    );
  }
}

