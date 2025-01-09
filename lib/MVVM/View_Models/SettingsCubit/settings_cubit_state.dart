part of 'settings_cubit_cubit.dart';

@immutable
 class SettingsCubitState {
  final String temperatureUnit;
  final String windSpeedUnit;

  SettingsCubitState({
    this.temperatureUnit = "Celsius",
    this.windSpeedUnit = "Km/h",
  });

  SettingsCubitState copyWith({String? temperatureUnit, String? windSpeedUnit}) {
    return SettingsCubitState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
    );
  }
}