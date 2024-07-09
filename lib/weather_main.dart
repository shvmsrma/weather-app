import 'package:flutter/material.dart';
import 'package:weather_app/city_details.dart';
import 'package:weather_app/models/day_forecast.dart';
import 'package:weather_app/models/week_forecast.dart';
import 'package:weather_app/seven_day_forecast.dart';
import 'package:weather_app/day_forecast.dart';
import 'package:weather_app/header.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_animation/weather_animation.dart';

const apiKey = 'd84f9b983e1f4d90acd124547240407';
String getDayOfWeek(int epoch) {
  // Create a DateTime object from the epoch timestamp
  DateTime date = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);

  // Get the day of week as an int (1 = Monday, 7 = Sunday)
  int dayOfWeekInt = date.weekday;

  // Convert the int to a day name
  switch (dayOfWeekInt) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Invalid day';
  }
}

class WeatherMain extends StatefulWidget {
  const WeatherMain({super.key});
  @override
  State<WeatherMain> createState() => _WeatherMainState();
}

class CurrentCity {
  CurrentCity(this.lat, this.long);
  final double? lat;
  final double? long;
}

class _WeatherMainState extends State<WeatherMain> {
  Location? pickedLocation;
  bool isGettingLocation = false;
  bool isFetchingDayForecast = false;
  bool isFetchingWeeklyForecast = false;
  String city = "";
  String dayType = "";
  int temp = 0;
  String forecastType = "";
  int minTemp = 0;
  int maxTemp = 0;
  CurrentCity? cityDetails;
  List<Forecast> dayForecast = [];
  List<WeekForecast> weekForecast = [];
  getCurrentLocation() async {
    Location location = Location();

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

    locationData = await location.getLocation();
    print(locationData);
    setState(() {
      cityDetails = CurrentCity(locationData.latitude, locationData.longitude);
    });
    getCurrentWeatherDetails(locationData.latitude, locationData.longitude);
  }

  void getCityWeatherDetails() async {
    setState(() {
      isGettingLocation = true;
      isFetchingDayForecast = true;
      isFetchingWeeklyForecast = true;
    });
    await getCurrentLocation();
    setState(() {
      isGettingLocation = false;
    });
    await getCityDayForecast();
    setState(() {
      isFetchingDayForecast = false;
    });
    await getCityWeeklyForecast();
    setState(() {
      isFetchingWeeklyForecast = false;
    });
  }

  getCityDayForecast() async {
    var latitude = cityDetails?.lat;
    var longitude = cityDetails?.long;
    var url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=1&aqi=no&alerts=no";
    await http.get(Uri.parse(url)).then((value) {
      var data = jsonDecode(value.body);
      var hourlyData = data['forecast']['forecastday'][0]['hour'];
      List<Forecast> dayForecastDetails = [];
      // Assuming 'localtime_epoch' is available to determine "now"
      int currentTimeEpoch = data['location']['localtime_epoch'];
      int closestIndex = 0;
      int updatedClosestIndex = 0;
      int smallestDifference =
          (hourlyData[0]['time_epoch'] - currentTimeEpoch).abs();
      for (int i = 1; i < hourlyData.length; i++) {
        int currentDifference =
            (hourlyData[i]['time_epoch'] - currentTimeEpoch).abs();
        if (currentDifference < smallestDifference) {
          smallestDifference = currentDifference;
          closestIndex = i;
        }
      }
      updatedClosestIndex = closestIndex;
      int endIndex = closestIndex + 4;
      if (endIndex > hourlyData.length) {
        closestIndex = hourlyData.length - 4;
        endIndex = hourlyData.length;
      }

      for (int i = closestIndex; i < endIndex; i++) {
        var hour = hourlyData[i];
        dayForecastDetails.add(
          Forecast(
            i == updatedClosestIndex
                ? 'Now'
                : hour['time'].split(' ')[1], // Extracts "HH:MM"
            (hour['temp_c'] is int)
                ? hour['temp_c'].toDouble()
                : hour['temp_c'], // Ensures conversion to double if needed
            (hour['wind_kph'] is int)
                ? hour['wind_kph'].toDouble()
                : hour['wind_kph'], // Ensures conversion to double if needed
            (hour['chance_of_rain'] is int)
                ? hour['chance_of_rain'].toDouble()
                : hour['chance_of_rain'],
            hour['condition']['text'],
          ),
        );
      }

      setState(() {
        print({'debug 2', dayForecastDetails, hourlyData});
        dayForecast = dayForecastDetails;
      });
    });
  }

  getCityWeeklyForecast() async {
    var latitude = cityDetails?.lat;
    var longitude = cityDetails?.long;
    var url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=7&aqi=no&alerts=no";
    await http.get(Uri.parse(url)).then((value) {
      var data = jsonDecode(value.body);
      var weeklyData = data['forecast']['forecastday'];
      List<WeekForecast> weeklyForecastDetails = [];
      int currentTimeEpoch = data['location']['localtime_epoch'];

      var sortedData = List.from(weeklyData)
        ..sort((a, b) {
          int aEpoch = a['date_epoch'] as int;
          int bEpoch = b['date_epoch'] as int;
          return (aEpoch - currentTimeEpoch)
              .abs()
              .compareTo((bEpoch - currentTimeEpoch).abs());
        });
      for (int i = 0; i < sortedData.length; i++) {
        var weekForecast = sortedData[i];
        weeklyForecastDetails.add(WeekForecast(
            i == 0 ? 'Today' : getDayOfWeek(weekForecast['date_epoch']),
            weekForecast['day']['mintemp_c'],
            weekForecast['day']['maxtemp_c'],
            weekForecast['day']['condition']['text']));
      }
      setState(() {
        weekForecast = weeklyForecastDetails;
      });
    });
  }

  void getCurrentWeatherDetails(double? lat, double? long) async {
    var url =
        "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$long";
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
    getCityWeatherDetails();
  }

  // Widget getWrapperWidget() {
  //   final condition = forecastType;
  //   switch (condition) {
  //     case 'sunny':
  //       return SunWidget();
  //     case 'cloudy':
  //       return CloudWidget();
  //     case 'windy':
  //       return WindWidget();
  //     case 'rainy':
  //       return RainWidget();
  //     default:
  //       return Icon(Icons.error); // Fallback for unknown condition
  //   }
  // }
  Widget getWeatherAnimation() {
    String condition = forecastType.toLowerCase();

    if (condition.contains('rain') || condition.contains('drizzle')) {
      return const RainWidget();
    } else if (condition.contains('snow') || condition.contains('sleet')) {
      return const SnowWidget();
    } else if (condition.contains('thunder') ||
        condition.contains('lightning')) {
      return const ThunderWidget();
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return const CloudWidget();
    } else if (condition.contains('fog') || condition.contains('mist')) {
      return const CloudWidget();
    } else if (condition.contains('wind') || condition.contains('gust')) {
      return const WindWidget();
    } else if (condition.contains('sun') || condition.contains('clear')) {
      return const SunWidget();
    } else {
      return const SunWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // Make the scaffold background transparent
          body: Stack(
            children: [
              // Weather animation background
              Positioned.fill(
                child: getWeatherAnimation(),
              ),
              // Your existing content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(onChangeInput: onCityChange),
                    if (isGettingLocation)
                      const Center(child: CircularProgressIndicator())
                    else if (isFetchingDayForecast)
                      Column(
                        children: [
                          CityDetails(
                            city: city,
                            dayType: dayType,
                            temp: temp,
                            minTemp: minTemp,
                            maxTemp: maxTemp,
                            forecastType: forecastType,
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      )
                    else if (isFetchingWeeklyForecast)
                      Column(
                        children: [
                          CityDetails(
                            city: city,
                            dayType: dayType,
                            temp: temp,
                            minTemp: minTemp,
                            maxTemp: maxTemp,
                            forecastType: forecastType,
                          ),
                          DayForecast(forecastDetails: dayForecast),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      )
                    else
                      Column(
                        children: [
                          CityDetails(
                            city: city,
                            dayType: dayType,
                            temp: temp,
                            minTemp: minTemp,
                            maxTemp: maxTemp,
                            forecastType: forecastType,
                          ),
                          DayForecast(forecastDetails: dayForecast),
                          SevenDayForecast(weekWeatherDetails: weekForecast),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
