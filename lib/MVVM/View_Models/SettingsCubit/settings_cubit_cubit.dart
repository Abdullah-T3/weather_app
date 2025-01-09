import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'settings_cubit_state.dart';

class SettingsCubit extends Cubit<SettingsCubitState> {
  SettingsCubit() : super(SettingsCubitState(temperatureUnit: 'Celsius', windSpeedUnit: 'm/s'));
 // Method to update the temperature unit
  void updateTemperatureUnit(String unit) {
    emit(SettingsCubitState(temperatureUnit: unit));
  }

  void updateWindSpeedUnit(String unit) {
    emit(state.copyWith(windSpeedUnit: unit));
  }
}
 