import 'package:flutter/material.dart';
import '../util/SizeConfig.dart';

class CustomDialog extends StatelessWidget {
  String msg = "";
  CustomDialog(msg){
    this.msg = msg;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 3.5 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFF6F93F1),Color(0xFF6F93F1)],
                  tileMode: TileMode.repeated,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 5.2 * SizeConfig.widthMultiplier,
                ),
                Center(
                    child: Padding(
                      padding:  EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
                      child: new Text(msg, style:TextStyle(fontSize: 1.8 * SizeConfig.textMultiplier,color: Colors.white)),
                    )//
                ),
                SizedBox(height: 6 * SizeConfig.widthMultiplier),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 4 * SizeConfig.widthMultiplier,bottom: 4 * SizeConfig.widthMultiplier),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4 * SizeConfig.widthMultiplier),
                          bottomRight: Radius.circular(4 * SizeConfig.widthMultiplier)),
                    ),
                    child:  Text(
                      "OK",
                      style: TextStyle(color: Colors.blue,fontSize: 2 * SizeConfig.textMultiplier),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap:(){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 3.0,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 3.5 * SizeConfig.widthMultiplier,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}