import 'package:flutter/material.dart';
import '../../util/SizeConfig.dart';
import '../../custom_widget/cust_button1.dart';
import '../../custom_widget/cust_text.dart';
import 'colorsC.dart';
import 'cust_button.dart';

class locationPermissionDialog extends StatelessWidget {

  final Function(bool) onSelected;

  locationPermissionDialog({
    required this.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5 * SizeConfig.widthMultiplier)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/icons/popup_bg.png'))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 4 * SizeConfig.heightMultiplier),
          Center(
              child: Padding(
                padding:  EdgeInsets.all(1.5 * SizeConfig.widthMultiplier),
                child:  CustText(name: "Your Device GPS Service\n is not enabled. \nTurn on device gps location to get accurate location", size: 2, colors: Colors.white,
                    textAlign:TextAlign.center,fontWeightName:FontWeight.w500),
              )//
          ),
          SizedBox(height: 3 * SizeConfig.heightMultiplier),
          Row(mainAxisAlignment:MainAxisAlignment.center,
            children: [
            CustButton(name: "Enable Location", size: 45,
              width: 20*SizeConfig.widthMultiplier, height: 7*SizeConfig.heightMultiplier, btnColor: borderColor, fontColor: c_white,  onSelected:  () async {
                onSelected(true);
                Navigator.pop(context);
              }, ),
          ],),
          SizedBox(height: 4* SizeConfig.heightMultiplier),
        ],
      )
    );
  }
}