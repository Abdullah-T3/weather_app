import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/helpers/cherryToast/CherryToastMsgs.dart';
import 'package:weather_app/helpers/extantions.dart';
import 'package:weather_app/routing/routs.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../Responsive/models/DeviceInfo.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';
import '../../../View_Models/Authcubit/auth_cubit.dart';
import '../../../View_Models/SettingsCubit/settings_cubit_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    final currentWindSpeedUnit = context.read<SettingsCubit>().state.windSpeedUnit;
    selectedValue = currentWindSpeedUnit;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.secondaryColor,
        title: Text("Settings", style: TextStyles.title),
      ),
      body: Infowidget(
        builder: (context, deviceInfo) {
          return AnimatedBuilder(
            animation: _fadeAnimation, // Use AnimatedBuilder to handle animation updates
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value, // Apply the fade animation
                child: child,
              );
            },
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is Unauthenticated) {
                  context.pushReplacementNamed(Routes.loginScreen);
                }
                if (state is AuthError) {
                  CherryToastMsgs.CherryToastError(
                    info: deviceInfo,
                    context: context,
                    title: 'Error',
                    description: state.message,
                  );
                } else if (state is AuthLoading) {
                  CherryToastMsgs.CherryToastLoading(
                    info: deviceInfo,
                    context: context,
                    title: 'Loading...',
                    description: 'Please wait...',
                  );
                }
              },
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  top: deviceInfo.screenHeight * 0.02,
                  start: deviceInfo.screenWidth * 0.05,
                  end: deviceInfo.screenWidth * 0.05,
                ),
                child: _buildSettingsContent(deviceInfo),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsContent(Deviceinfo deviceInfo) {
    return BlocBuilder<SettingsCubit, SettingsCubitState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Units"),
            _buildTemperatureSettings(deviceInfo, state.temperatureUnit),
            _buildWindSpeedSettings(deviceInfo),
            _buildSectionTitle("About"),
            _buildAboutText(),
            _buildLogoutButton(),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: TextStyles.title),
    );
  }

  Widget _buildTemperatureSettings(Deviceinfo deviceInfo, String temperatureUnit) {
    return Container(
      width: deviceInfo.screenWidth * 0.9,
      padding: EdgeInsets.only(top: deviceInfo.screenHeight * 0.02, bottom: deviceInfo.screenHeight * 0.02, left: deviceInfo.screenWidth * 0.02, right: deviceInfo.screenWidth * 0.02),
      decoration: BoxDecoration(
        color: ColorsManager.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Temperature", style: TextStyles.textGray),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildModernToggleButton(
                text: "Celsius",
                isSelected: temperatureUnit == "Celsius",
                onPressed: () => context.read<SettingsCubit>().updateTemperatureUnit("Celsius"),
                deviceInfo: deviceInfo,
              ),
              _buildModernToggleButton(
                text: "Fahrenheit",
                isSelected: temperatureUnit == "Fahrenheit",
                onPressed: () => context.read<SettingsCubit>().updateTemperatureUnit("Fahrenheit"),
                deviceInfo: deviceInfo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
    required Deviceinfo deviceInfo,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        width: deviceInfo.screenWidth * 0.39,
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: deviceInfo.screenWidth * 0.02, vertical: deviceInfo.screenHeight * 0.01),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    ColorsManager.primaryColor,
                    ColorsManager.secondaryColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : ColorsManager.secondaryColor,
          borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.02),
          border: Border.all(
            color: isSelected ? Colors.transparent : ColorsManager.choosedColor,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : ColorsManager.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildWindSpeedSettings(Deviceinfo deviceInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: deviceInfo.screenHeight * 0.03),
        Text("Wind Speed", style: TextStyles.textGray),
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
    );
  }

  Widget _buildAboutText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "This app is a simple weather forecast app that uses the OpenWeatherMap API to get weather information. It is built using Flutter and the MVVM architecture.",
        style: TextStyles.textGray,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return MaterialButton(
      onPressed: () {
        context.read<AuthCubit>().signOut();
      },
      color: Colors.red,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text("Logout", style: TextStyles.logOutTextStyle),
    );
  }
}
