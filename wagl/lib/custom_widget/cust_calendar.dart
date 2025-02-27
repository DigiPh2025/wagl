import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/register/additional_details_controller.dart';
import 'package:wagl/util/SizeConfig.dart';

import 'colorsC.dart';
/*

class DayPicker<T extends GetxController> extends StatelessWidget {
  final T controller;

  DayPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdditionalDetailsController>(
      builder: (controller) {
        return Container(
          width: 30 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBlack_3,
            border: Border.all(
                color: borderColor, width: 0.25 * SizeConfig.widthMultiplier),
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: DropdownButton<int>(
            value: controller.selectedDay,
            menuMaxHeight: 40 * SizeConfig.heightMultiplier,
            underline: Container(),
            icon: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 1.0 * SizeConfig.widthMultiplier),
              child: Icon(Icons.keyboard_arrow_down),
            ),
            items: List.generate(controller.daysInMonth, (index) => index + 1)
                .map((day) => DropdownMenuItem(
                      alignment: Alignment.center,
                      value: day,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.widthMultiplier),
                        child: CustText(
                            name: day.toString(),
                            size: 1.4,
                            fontWeightName: FontWeight.w500,
                            colors: colorWhite,
                            maxLine: 1),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              controller.setDay(value!);
            },
          ),
        );
      },
    );
  }
}

class MonthPicker extends StatelessWidget {
  var dateController;

  MonthPicker({required this.dateController});

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdditionalDetailsController>(
      builder: (controller) {
        return Container(
          width: 30 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBlack_3,
            border: Border.all(
                color: borderColor, width: 0.25 * SizeConfig.widthMultiplier),
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: DropdownButton<int>(
            underline: Container(),
            icon: Icon(Icons.keyboard_arrow_down),
            value: controller.selectedMonth,
            items: List.generate(months.length, (index) => index + 1)
                .map((month) => DropdownMenuItem(
                      value: month,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.widthMultiplier),
                        child: CustText(
                            name: months[month - 1],
                            size: 1.4,
                            fontWeightName: FontWeight.w500,
                            colors: colorWhite,
                            maxLine: 1),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              controller.setMonth(value!);
            },
          ),
        );
      },
    );
  }
}

class YearsPicker extends StatelessWidget {
  var dateController;

  YearsPicker({required this.dateController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdditionalDetailsController>(
      builder: (controller) {
        return Container(
          width: 30 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBlack_3,
            border: Border.all(
                color: borderColor, width: 0.25 * SizeConfig.widthMultiplier),
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: DropdownButton<int>(
            underline: Container(),
            icon: Icon(Icons.keyboard_arrow_down),
            value: controller.selectedYear,
            items: List.generate(101, (index) => 1924 + index)
                .map((year) => DropdownMenuItem(
                      value: year,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier),
                        child: CustText(
                            name: year.toString(),
                            size: 1.4,
                            fontWeightName: FontWeight.w500,
                            colors: colorWhite,
                            maxLine: 1),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              controller.setYear(value!);
            },
          ),
        );
      },
    );
  }
}
*/
class DayPicker<T extends GetxController> extends StatelessWidget {
  final T controller;

  DayPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (controller) {
        var selectedDay = (controller as dynamic).selectedDay;
        var daysInMonth = (controller as dynamic).daysInMonth;

        return Container(
          width: 30 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBlack_3,
            border: Border.all(
                color: borderColor, width: 0.25 * SizeConfig.widthMultiplier),
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: DropdownButton(
            value: /*(controller as dynamic).dayValue=="DD"?(controller as dynamic).dayValue:*/selectedDay,
            menuMaxHeight: 30 * SizeConfig.heightMultiplier,alignment: AlignmentDirectional.center ,
            hint: Padding(
              padding:  EdgeInsets.only(left: 18.0),
              child: CustText(name: "DD", size: 1.6, fontWeightName: FontWeight.w500,  isCapital: true,),
            ),
            underline: Container(),
            icon: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 1.0 * SizeConfig.widthMultiplier),
              child: Padding(
                padding:  EdgeInsets.only(left: 10*SizeConfig.widthMultiplier),
                child: Icon(Icons.keyboard_arrow_down),
              ),
            ),
            items: List.generate(daysInMonth, (index) => index + 1)
                .map((day) => DropdownMenuItem(
              alignment: Alignment.center,
              value: day,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.widthMultiplier),
                child: CustText(
                    name: day.toString(),
                    size: 1.4,
                    fontWeightName: FontWeight.w500,
                    colors: colorWhite,
                    maxLine: 1),
              ),
            ))
                .toList(),
            onChanged: (value) {
              (controller as dynamic).setDay(value!);
            },
          ),
        );
      },
    );
  }
}

class MonthPicker<T extends GetxController> extends StatelessWidget {
  final T controller;

  MonthPicker({required this.controller});

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (controller) {
        var selectedMonth = (controller as dynamic).selectedMonth;

        return Container(
          width: 30 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBlack_3,
            border: Border.all(
                color: borderColor, width: 0.25 * SizeConfig.widthMultiplier),
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: DropdownButton(
            menuMaxHeight: 30 * SizeConfig.heightMultiplier,
            underline: Container(),
            icon: Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: Icon(Icons.keyboard_arrow_down),
            ),
            alignment: AlignmentDirectional.center ,
            value: selectedMonth,
            hint: CustText(name: "MM", size: 1.6, fontWeightName: FontWeight.w500,isCapital: true,),
            items: List.generate(months.length, (index) => index + 1)
                .map((month) => DropdownMenuItem(
              value: month,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.widthMultiplier),
                child: CustText(
                    name: months[month - 1],
                    size: 1.4,
                    fontWeightName: FontWeight.w500,
                    colors: colorWhite,),
              ),
            ))
                .toList(),
            onChanged: (value) {
              (controller as dynamic).setMonth(value!);
            },
          ),
        );
      },
    );
  }
}

class YearsPicker<T extends GetxController> extends StatelessWidget {
  final T controller;

  YearsPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (controller) {
        var selectedYear = (controller as dynamic).selectedYear;
        int currentYear = DateTime.now().year - 1; // Set to one year less than the current year
        List<int> years = List.generate(currentYear - 1960 + 1, (index) => 1960 + index);

        // Ensure selectedYear is within the list range or set it to null
        if (!years.contains(selectedYear)) {
          selectedYear = null;
        }

        return Container(
          width: 30 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: colorBlack_3,
            border: Border.all(
                color: borderColor, width: 0.25 * SizeConfig.widthMultiplier),
            borderRadius: BorderRadius.all(
                Radius.circular(2 * SizeConfig.widthMultiplier)),
          ),
          child: DropdownButton<int>(
            underline: Container(),
            alignment: AlignmentDirectional.center,
            menuMaxHeight: 30 * SizeConfig.heightMultiplier,
            icon: Icon(Icons.keyboard_arrow_down),
            value: selectedYear,
            hint: CustText(
              name: "YYYY",
              size: 1.6,
              fontWeightName: FontWeight.w500,
              isCapital: true,
            ),
            items: years
                .map((year) => DropdownMenuItem(
              value: year,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                child: CustText(
                  name: year.toString(),
                  size: 1.6,
                  fontWeightName: FontWeight.w500,
                  colors: colorWhite,
                  maxLine: 1,
                ),
              ),
            ))
                .toList(),
            onChanged: (value) {
              (controller as dynamic).setYear(value!);
            },
          ),
        );
      },
    );
  }
}
