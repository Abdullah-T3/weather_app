import 'package:flutter/material.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';
import '../Widgets/build_item_widget.dart';

class DetailsScreen extends StatelessWidget {
  final String date;
  final String condition;
  final double maxTemp;
  final double minTemp;
  final String iconUrl;
  final String ctiyName;
  final String temperatureUnit;

  const DetailsScreen({
    super.key,
    required this.date,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
    required this.iconUrl,
    required this.ctiyName,
    required this.temperatureUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorsManager.secondaryColor,
        title: Text(
          ctiyName,
          style: TextStyles.title,
        ),
      ),
      body: Center(
        child: Infowidget(
          builder: (context, deviceInfo) {
            return Padding(
              padding: EdgeInsetsDirectional.only(
                top: deviceInfo.screenHeight * 0.02,
                start: deviceInfo.screenWidth * 0.05,
                end: deviceInfo.screenWidth * 0.05,
              ),
              child: Column(
                children: [
                  Text(
                    ctiyName,
                    style: TextStyles.title.copyWith(
                      fontSize: 42,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    date,
                    style: TextStyles.title,
                  ),
                  const SizedBox(height: 10),
                  // Icon URL: If it's empty, display a placeholder or default icon
                  if (iconUrl.isNotEmpty)
                    Image.network(
                      'https:$iconUrl',
                      width: deviceInfo.screenWidth * 0.4,
                      height: deviceInfo.screenWidth * 0.4,
                    ),

                  const SizedBox(height: 10),
                  // Max/Min Temperature Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildItemWidget(
                        data: '${maxTemp.toStringAsFixed(1)} ${temperatureUnit == 'Celsius' ? '°C' : '°F'}',
                        title: 'Max Temp',
                      ),
                      const SizedBox(width: 10),
                      BuildItemWidget(
                        data: '${minTemp.toStringAsFixed(1)} ${temperatureUnit == 'Celsius' ? '°C' : '°F'}',
                        title: 'Min Temp',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Condition Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildItemWidget(
                        data: condition,
                        title: 'Condition',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
