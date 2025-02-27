import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import '../create_wagl/create_wagl_controller.dart';
import '../util/SizeConfig.dart';
import 'color_loader.dart';
import 'cust_text.dart';

class ProgressBarPopup extends StatelessWidget {
  ProgressBarPopup();
  var createController=Get.put(CreateWaglController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 3.5 * SizeConfig.widthMultiplier,
          right: 2 * SizeConfig.widthMultiplier),
      color: backgroundDialogLoader,
      child: GetBuilder<CreateWaglController>(
        init: CreateWaglController(),
        builder: (controller) => Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                    child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 2 * SizeConfig.widthMultiplier,
                    ),
                    ColorLoader(),
                    // CustomRefreshIndicator(),
                    // SizedBox(width: 1  * SizeConfig.widthMultiplier,),
                    CustText(
                        name: "Publishing... ${createController.uploadProgress.toStringAsFixed(0)}%",
                        size: 1.8,
                        colors: Colors.white,
                        textAlign: TextAlign.center,
                        fontWeightName: FontWeight.w800),
                  ],
                ) //
                    ),
                SizedBox(height: 4 * SizeConfig.widthMultiplier),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
