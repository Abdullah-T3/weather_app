// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/Responsive/UiComponanets/InfoWidget.dart';
import 'package:weather_app/helpers/extantions.dart';
import '../../../../routing/routs.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/styles.dart';
import '../../../View_Models/SettingsCubit/settings_cubit_cubit.dart';
import '../../../View_Models/Weathercubit/weather_cubit_cubit.dart';
import '../Widgets/info_item_widget.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit()..fetchWeather(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Weather Forecast',
            style: TextStyles.title,
          ),
          backgroundColor: ColorsManager.secondaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<WeatherCubit>().fetchWeather();
              },
            ),
          ],
        ),
        body: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            print('state: $state');
            if (state is WeatherLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is WeatherError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<WeatherCubit>().fetchWeather();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is WeatherLoaded) {
              final weather = state.weatherData;
              return Infowidget(builder: (context, deviceInfo) {
                return RefreshIndicator(
                  onRefresh: () => context.read<WeatherCubit>().fetchWeather(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: deviceInfo.screenWidth,
                      height: deviceInfo.screenHeight * 0.9,
                      padding: EdgeInsetsDirectional.only(
                        top: deviceInfo.screenHeight * 0.02,
                        start: deviceInfo.screenWidth * 0.05,
                        end: deviceInfo.screenWidth * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${weather.location.name}, ${weather.location.country}',
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (weather.location.region.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Region: ${weather.location.region}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          if (weather.current.condition.icon.isNotEmpty) ...[
                            Image.network(
                              'https:${weather.current.condition.icon}',
                              width: deviceInfo.screenWidth * 0.3,
                              height: deviceInfo.screenWidth * 0.3,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          BlocBuilder<SettingsCubit, SettingsCubitState>(
                            builder: (context, settingsState) {
                              final temperatureUnit = settingsState.temperatureUnit;
                              final windSpeedUnit = settingsState.windSpeedUnit;

                              // Convert temperature based on the selected unit
                              final temperature = temperatureUnit == "Celsius" ? weather.current.tempC : (weather.current.tempC * 9 / 5) + 32;

                              // Convert wind speed based on the selected unit
                              final windSpeed = windSpeedUnit == "Km/h" ? weather.current.windKph : weather.current.windKph * 0.621371;

                              return Column(
                                children: [
                                  Text(
                                    '$temperature ${temperatureUnit == "Celsius" ? "°C" : "°F"}',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    weather.current.condition.text,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InfoItemWidget(
                                        label: 'Humidity',
                                        value: '${weather.current.humidity.toString()}%',
                                        icon: Icons.water_drop_outlined,
                                      ),
                                      InfoItemWidget(
                                        label: 'Wind',
                                        value: '${windSpeed.toStringAsFixed(1)} $windSpeedUnit',
                                        icon: Icons.wind_power_outlined,
                                      ),
                                      InfoItemWidget(
                                        label: 'Visibility',
                                        value: '${weather.current.visKm.toString()} km',
                                        icon: Icons.visibility_outlined,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Forecast',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: weather.forecast.forecastday.length,
                              itemBuilder: (context, index) {
                                final forecastDay = weather.forecast.forecastday[index];

                                // Get the selected temperature unit from SettingsCubit
                                final temperatureUnit = context.read<SettingsCubit>().state.temperatureUnit;

                                // Convert the max and min temperature based on the selected unit (Celsius or Fahrenheit)
                                final maxTemp = temperatureUnit == 'Celsius' ? forecastDay.day.maxtempC : (forecastDay.day.maxtempC * 9 / 5) + 32;
                                final minTemp = temperatureUnit == 'Celsius' ? forecastDay.day.mintempC : (forecastDay.day.mintempC * 9 / 5) + 32;

                                // Format the temperature as needed (with 1 decimal place)
                                final maxTempStr = maxTemp.toStringAsFixed(1);
                                final minTempStr = minTemp.toStringAsFixed(1);

                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed(Routes.detailScreen, arguments: {
                                      'date': _formatDate(forecastDay.date),
                                      'condition': forecastDay.day.condition.text,
                                      'maxTemp': maxTemp, // Converted max temp
                                      'minTemp': minTemp, // Converted min temp
                                      'iconUrl': forecastDay.day.condition.icon,
                                      'cityName': weather.location.name,
                                      'temperatureUnit': temperatureUnit,
                                    });
                                  },
                                  child: Card(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(0.1),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: ListTile(
                                      leading: forecastDay.day.condition.icon.isNotEmpty
                                          ? Image.network(
                                              'https:${forecastDay.day.condition.icon}',
                                              width: 40,
                                              height: 40,
                                              errorBuilder: (_, __, ___) => const Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                              ),
                                            )
                                          : null,
                                      title: Text(
                                        _formatDate(forecastDay.date),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Max: $maxTempStr°${temperatureUnit == "Celsius" ? "C" : "F"} | Min: $minTempStr°${temperatureUnit == "Celsius" ? "C" : "F"}',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.water_drop,
                                            color: Colors.blue.shade300,
                                            size: 16,
                                          ),
                                          Text(
                                            '${forecastDay.day.dailyChanceOfRain}%',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    if (date.year == now.year && date.month == now.month && date.day == now.day + 1) {
      return 'Tomorrow';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
