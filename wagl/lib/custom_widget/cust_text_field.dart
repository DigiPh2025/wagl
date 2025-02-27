import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/SizeConfig.dart';
import 'colorsC.dart';
import 'cust_text.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double widthSize;
  final TextEditingController textEditingController;
  bool isObscureText = false;
  final inputFormatter;

  final Widget? suffixIcon;
  final Function(String) onChange;
  // final Function()? onSelected;

  TextFieldWidget({super.key,
    required this.labelText,
    required this.hintText,
    required this.textEditingController,
    required this.widthSize,
    required this.isObscureText,
    this.inputFormatter,

    this.suffixIcon,
    // this.onSelected,
    required this.onChange,
    InputDecoration? decoration,
  });

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        labelText==""?Container():SizedBox(
            width: widthSize * SizeConfig.widthMultiplier,
            child: CustText(
              name: labelText,
              size: 1.6,
              colors: colorWhite,
              fontWeightName: FontWeight.w600,
              textAlign: TextAlign.start,
            )),
        labelText==""?Container():SizedBox(height: 1 * SizeConfig.heightMultiplier),
        Container(
          height: 5.5 * SizeConfig.heightMultiplier,
          width: widthSize * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: Center(
            child: TextField(
              keyboardType: inputFormatter,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "Gilroy",
                color: colorWhite,
                fontWeight: FontWeight.w500,
                fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
              ),
              controller: textEditingController,
              cursorColor: colorWhite,
              obscureText: isObscureText,

              onTapOutside: (Value) {

                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: (value) {
                if(value.length!=0)
                  {
                    onChange(value);
                  }
              },
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.only(
                  top: -0.5 * SizeConfig.widthMultiplier,
                  left: 2 * SizeConfig.widthMultiplier,
                  right: 2 * SizeConfig.widthMultiplier,
                ),
                constraints: BoxConstraints.tightFor(
                    height: 5.5 * SizeConfig.heightMultiplier),
                fillColor: colorPrimary,
                /*contentPadding: new EdgeInsets.symmetric(
                                              vertical:
                                              2 * SizeConfig.widthMultiplier,
                                              horizontal:
                                              2 * SizeConfig.widthMultiplier),*/
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                  borderSide: const BorderSide(
                    color: colorPrimary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                  borderSide: const BorderSide(
                    color: borderColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(2 * SizeConfig.widthMultiplier),
                  borderSide: const BorderSide(
                    color: colorPrimary,
                    // width: 2.0,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: suffixIcon,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: "Gilroy",
                  color: colorGrey,
                  fontSize: 1.6 * SizeConfig.textMultiplier/scaleFactor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus();
  }
}
