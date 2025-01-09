import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/helpers/extantions.dart';
import 'package:weather_app/routing/routs.dart';

import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';
import '../../../View_Models/Authcubit/auth_cubit.dart';
import '../../../View_Models/SettingsCubit/settings_cubit_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedValue; // Declare selectedValue

  @override
  void initState() {
    super.initState();
    // Initially set the selectedValue to the current wind speed unit from settings
    final currentWindSpeedUnit = context.read<SettingsCubit>().state.windSpeedUnit;
    selectedValue = currentWindSpeedUnit; // Set initial value from the state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.secondaryColor,
        title: Text(
          "Settings",
          style: TextStyles.title,
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.pushReplacementNamed(Routes.loginScreen);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthLoading) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Loading...")));
          }
        },
        child: Infowidget(
          builder: (context, deviceInfo) {
            return Padding(
              padding: EdgeInsetsDirectional.only(
                top: deviceInfo.screenHeight * 0.02,
                start: deviceInfo.screenWidth * 0.05,
                end: deviceInfo.screenWidth * 0.05,
              ),
              child: BlocBuilder<SettingsCubit, SettingsCubitState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Units",
                        style: TextStyles.title,
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.02),
                      Container(
                        width: deviceInfo.screenWidth * 0.9,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorsManager.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Temperature",
                              style: TextStyles.textGray,
                            ),
                            const SizedBox(height: 8),
                            ToggleButtons(
                              color: ColorsManager.textWhite,
                              borderColor: ColorsManager.choosedColor,
                              selectedBorderColor: ColorsManager.textWhite,
                              constraints: BoxConstraints(
                                minWidth: deviceInfo.localWidth * 0.4,
                                minHeight: deviceInfo.localHeight * 0.05,
                              ),
                              isSelected: [
                                state.temperatureUnit == "Celsius",
                                state.temperatureUnit == "Fahrenheit",
                              ],
                              onPressed: (index) {
                                context.read<SettingsCubit>().updateTemperatureUnit(
                                      index == 0 ? "Celsius" : "Fahrenheit",
                                    );
                              },
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: Colors.white,
                              fillColor: ColorsManager.primaryColor,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("Celsius"),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("Fahrenheit"),
                                ),
                              ],
                            ),
                            SizedBox(height: deviceInfo.screenHeight * 0.03),
                            Text(
                              "Wind Speed",
                              style: TextStyles.textGray,
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              dropdownColor: ColorsManager.textWhite,
                              value: selectedValue, 
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue; 
                                });
                                context.read<SettingsCubit>().updateWindSpeedUnit(newValue!);
                              },
                              items: [
                                'Km/h',
                                'm/s',
                                'mph'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyles.textGray),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.03),
                      Text(
                        "About",
                        style: TextStyles.title,
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.03),
                      Text(
                        "This app is a simple weather forecast app that uses the OpenWeatherMap API to get weather information. It is built using Flutter and the MVVM architecture.",
                        style: TextStyles.textGray,
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.03),
                      MaterialButton(
                        onPressed: () {
                          context.read<AuthCubit>().signOut();
                        },
                        color: Colors.red,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Logout",
                          style: TextStyles.logOutTextStyle,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
