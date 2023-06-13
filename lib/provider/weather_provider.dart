import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;
  double latitude = 0.0;
  double longitude = 0.0;
  String unit = 'metric'; //or imperial

  void setNewPosition(Position position) {
    latitude = position.latitude;
    longitude = position.longitude;
    _getCurrentData();
    _getForecastData();
  }

  bool get hasDataLoaded => currentWeather != null && forecastWeather != null;
  
  Future<void> _getCurrentData() async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        final map = json.decode(response.body);
        currentWeather = CurrentWeather.fromJson(map);
        //print('Current temp: ${currentWeather!.main!.temp}');
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        //print(map['message']);
      }
    } catch(error) {
      print(error.toString());
    }
  }

  Future<void> _getForecastData() async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        final map = json.decode(response.body);
        forecastWeather = ForecastWeather.fromJson(map);
        print('Forecast Items: ${forecastWeather!.list!.length}');
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        print(map['message']);
      }
    } catch(error) {
      print(error.toString());
    }
  }
}