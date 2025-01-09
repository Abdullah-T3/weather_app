import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/MVVM/View_Models/Weathercubit/weather_cubit_cubit.dart';
import 'package:weather_app/MVVM/View_Models/SettingsCubit/settings_cubit_cubit.dart'; // Import SettingsCubit
import '../MVVM/Views/Auth/Screens/login_screen.dart';
import '../MVVM/Views/Auth/Screens/sign_up_screen.dart';
import '../MVVM/Views/Home/Screens/home_Screen.dart';
import '../MVVM/Views/Settings/Screen/Settings_Screen.dart';
import '../MVVM/Views/Splash/splash_screen.dart';
import '../MVVM/Views/Details/Screen/details_screen.dart'; // Import DetailsScreen
import 'routs.dart';

class AppRouts {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homePage:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => WeatherCubit(),
            child: const HomeScreen(),
          ),
        );
      case Routes.settingScreen:
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        );
      case Routes.detailScreen:
        // Ensure this case is unique and defined
        final args = settings.arguments as Map<String, dynamic>;

        final date = args['date'] as String;
        final condition = args['condition'] as String;
        final maxTemp = args['maxTemp'] as double;
        final minTemp = args['minTemp'] as double;
        final iconUrl = args['iconUrl'] as String;
        final cityName = args['cityName'] as String;
        final temperatureUnit = args['temperatureUnit'] as String;

        // Wrap DetailsScreen with SettingsCubit
        return MaterialPageRoute(
          builder: (context) => BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit(),
            child: DetailsScreen(
              date: date,
              condition: condition,
              maxTemp: maxTemp,
              minTemp: minTemp,
              iconUrl: iconUrl,
              ctiyName: cityName,
              temperatureUnit: temperatureUnit,
              
            ),
          ),
        );

      default:
        return null;
    }
  }
}
