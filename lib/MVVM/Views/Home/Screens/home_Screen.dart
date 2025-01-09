import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/MVVM/View_Models/SettingsCubit/settings_cubit_cubit.dart';
import 'package:weather_app/theming/colors.dart';

import '../../Settings/Screen/Settings_Screen.dart';
import '../../Weather Forecast/Screens/Weather_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const WeatherScreen(),
      const SettingsScreen(),
    ];
  }

  final List<IconData> _iconList = [
    Icons.cloud_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: AnimatedBottomNavigationBar(
          gapWidth: 10,
          icons: _iconList,
          activeIndex: _currentIndex,
          gapLocation: GapLocation.end,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          activeColor: Colors.blue,
          inactiveColor: Colors.white,
          backgroundColor: ColorsManager.secondaryColor,
        ),
      ),
    );
  }
}
