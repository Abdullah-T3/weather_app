import 'package:flutter/material.dart';
import 'package:weather_app/helpers/extantions.dart';

import '../../../routing/routs.dart';
import '../../../theming/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (_) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
        ),
        Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/image/logo_2.png'),
            ))),
        SizedBox(
          height: 30,
        ),
        Text("Breeze", style: TextStyles.title.copyWith(fontSize: 60)),
        Text("Weather App", style: TextStyle(color: Color(0xFF9399A2), fontSize: 28)),
      ],
    ));
  }
}
