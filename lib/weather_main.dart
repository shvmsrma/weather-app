import 'package:flutter/material.dart';
import 'package:weather_app/city_details.dart';
import 'package:weather_app/seven_day_forecast.dart';
import 'package:weather_app/day_forecast.dart';
import 'package:weather_app/header.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherMain extends StatefulWidget {
  @override
  State<WeatherMain> createState() => _WeatherMainState();
}

class _WeatherMainState extends State<WeatherMain> {
  Location? pickedLocation;
  bool isGettingLocation = false;
  String city = "";
  String dayType = "";
  int temp = 0;
  String forecastType = "";
  int minTemp = 0;
  int maxTemp = 0;

  void getCurrentLocation() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    setState(() {
      isGettingLocation = false;
    });
    print(locationData);
    getCurrentWeatherDetails(locationData.latitude, locationData.longitude);
  }

  void getCurrentWeatherDetails(double? lat, double? long) async {
    final api_key = "d84f9b983e1f4d90acd124547240407";
    var url =
        "http://api.weatherapi.com/v1/current.json?key=$api_key&q=$lat,$long";
    await http.get(Uri.parse(url)).then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        city = data['location']['name'];
        dayType = data['current']['condition']['text'];
        temp = data['current']['temp_c'].toInt();
        forecastType = data['current']['condition']['text'];
        minTemp = data['current']['temp_c']
            .toInt(); // Placeholder, API does not provide min temp in the current weather endpoint
        maxTemp = data['current']['temp_c']
            .toInt(); // Placeholder, API does not provide max temp in the current weather endpoint
      });
    });
  }

  void onCityChange(value) {
    setState(() {
      city = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          body: isGettingLocation
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Header(onChangeInput: onCityChange),
                      CityDetails(
                        city: city,
                        dayType: dayType,
                        temp: temp,
                        minTemp: minTemp,
                        maxTemp: maxTemp,
                        forecastType: forecastType,
                      ),
                      DayForecast(),
                      SevenDayForecast(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
