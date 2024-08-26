import 'package:geolocator/geolocator.dart';
import 'package:heyconvo/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = "4573f9b4c3ce8dfe7e9d9efa5ed4c380";
const openWeatherMapUrl = "https://api.openweathermap.org/data/2.5/weather";

class Location {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getCurrentLocation() async {
    try {
      // await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      kerror("$e");
    }
  }
}

class WeatherModel {
  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    // print(location.latitude);
    if (location.latitude != 0) {
      NetworkHelper networkHelper = NetworkHelper(
          url:
              '$openWeatherMapUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
      var weatherData = await networkHelper.getData();
      return weatherData;
    } else {
      return null;
    }
  }
}

class NetworkHelper {
  NetworkHelper({this.url = ""});
  final String url;

  Future getData() async {
    if (url.isEmpty) {
      return;
    }
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      String data = response.body;
      var weather = jsonDecode(data);
      // print(weather);
      return weather;
    } else {
      // print(response.statusCode);
    }
  }
}
