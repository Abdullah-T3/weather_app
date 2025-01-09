import 'package:flutter/material.dart';
import 'package:weather_app/Responsive/UiComponanets/InfoWidget.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';

class BuildItemWidget extends StatelessWidget {
  const BuildItemWidget({super.key, required this.data, this.style, required this.title});
  final String data;
  final String title;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (context, deviceInfo) {
      return Container(
        height: deviceInfo.screenWidth * 0.35,
        width: deviceInfo.screenWidth * 0.42,
        decoration: BoxDecoration(
          color: ColorsManager.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            top: deviceInfo.screenHeight * 0.01,
            start: deviceInfo.screenWidth * 0.04,
            end: deviceInfo.screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.textGray,
              ),
              SizedBox(height: deviceInfo.screenHeight * 0.02),
              Text(
                '$data',
                style: style ??
                    TextStyles.title.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.07,
                    ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
