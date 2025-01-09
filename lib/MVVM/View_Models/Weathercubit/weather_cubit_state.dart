part of 'weather_cubit_cubit.dart';

@immutable
abstract class WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;

  WeatherLoaded(this.weatherData);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}

class WeatherUnitChanged extends WeatherState {
  final String temperatureUnit;
  final String windSpeedUnit;
  final WeatherData weatherData;

  WeatherUnitChanged(this.temperatureUnit, this.windSpeedUnit, this.weatherData);
}
