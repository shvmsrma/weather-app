import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/widgets/city_details.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/city_item.dart';
import 'package:weather_app/models/day_forecast.dart';
import 'package:weather_app/models/week_forecast.dart';
import 'package:weather_app/widgets/seven_day_forecast.dart';
import 'package:weather_app/widgets/day_forecast.dart';
import 'package:weather_app/widgets/header.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_animation/weather_animation.dart';
import 'package:weather_app/widgets/actions.dart';

String getDayOfWeek(int epoch) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
  int dayOfWeekInt = date.weekday;
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

class _WeatherMainState extends State<WeatherMain> {
  Location? pickedLocation;
  bool isGettingLocation = true;
  bool isFetchingDayForecast = false;
  bool isFetchingWeeklyForecast = false;
  CurrentCity cityDetails = CurrentCity(0, 0, '', '', 0, 0, 0, '');
  List<Forecast> dayForecast = [];
  List<WeekForecast> weekForecast = [];

  Future<void> getCurrentLocation() async {
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
      cityDetails = CurrentCity(
          locationData.latitude!, locationData.longitude!, '', '', 0, 0, 0, '');
    });

    await getCityWeatherDetails();
  }

  Future<void> getCityWeatherDetails() async {
    setState(() {
      isGettingLocation = true;
      isFetchingDayForecast = true;
      isFetchingWeeklyForecast = true;
    });

    await getCurrentWeatherDetails();
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

  Future<void> getCityDayForecast() async {
    const apiKey = 'd84f9b983e1f4d90acd124547240407';
    var latitude = cityDetails.lat;
    var longitude = cityDetails.long;
    var url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=1&aqi=no&alerts=no";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    var hourlyData = data['forecast']['forecastday'][0]['hour'];
    List<Forecast> dayForecastDetails = [];
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
          i == updatedClosestIndex ? 'Now' : hour['time'].split(' ')[1],
          (hour['temp_c'] is int) ? hour['temp_c'].toDouble() : hour['temp_c'],
          (hour['wind_kph'] is int)
              ? hour['wind_kph'].toDouble()
              : hour['wind_kph'],
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
  }

  Future<void> getCityWeeklyForecast() async {
    const apiKey = 'd84f9b983e1f4d90acd124547240407';
    var latitude = cityDetails.lat;
    var longitude = cityDetails.long;
    var url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=7&aqi=no&alerts=no";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
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
        weekForecast['day']['condition']['text'],
      ));
    }
    setState(() {
      weekForecast = weeklyForecastDetails;
    });
  }

  Future<void> getCurrentWeatherDetails() async {
    const apiKey = 'd84f9b983e1f4d90acd124547240407';
    var lat = cityDetails.lat;
    var long = cityDetails.long;
    var url =
        "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$long";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    setState(() {
      cityDetails = CurrentCity(
          cityDetails.lat,
          cityDetails.long,
          data['location']['name'],
          data['current']['condition']['text'],
          data['current']['temp_c'].toInt(),
          data['current']['temp_c'].toInt(),
          data['current']['temp_c'].toInt(),
          data['current']['condition']['text']);
    });
  }

  void addToFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(cityDetails.name);
    prefs.setStringList('favorites', favorites);
  }

  void onCityChange(CityItem cityDetail) {
    setState(() {
      cityDetails = CurrentCity(
          cityDetail.lat, cityDetail.long, cityDetail.name, '', 0, 0, 0, '');
      getCityWeatherDetails();
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Widget getWeatherAnimation() {
    String condition = cityDetails.forecastType.toLowerCase();
    if (condition.isNotEmpty) {
      if (condition.contains('rain') || condition.contains('drizzle')) {
        return const RainWidget();
      } else if (condition.contains('snow') || condition.contains('sleet')) {
        return const SnowWidget();
      } else if (condition.contains('thunder') ||
          condition.contains('lightning')) {
        return const ThunderWidget();
      } else if (condition.contains('cloud') ||
          condition.contains('overcast')) {
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
    return const SunWidget();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Weather'),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Weather animation background
              Positioned.fill(
                child: getWeatherAnimation(),
              ),
              // Main content
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 80),
                      ActionContainer(
                        isFavorite: true,
                        onTap: () {
                          addToFavorites();
                        },
                      ),
                      if (isGettingLocation)
                        const Center(child: CircularProgressIndicator())
                      else if (isFetchingDayForecast)
                        Column(
                          children: [
                            CityDetails(
                              cityDetails: cityDetails,
                            ),
                            const Center(child: CircularProgressIndicator()),
                          ],
                        )
                      else if (isFetchingWeeklyForecast)
                        Column(
                          children: [
                            CityDetails(
                              cityDetails: cityDetails,
                            ),
                            DayForecast(forecastDetails: dayForecast),
                            const Center(child: CircularProgressIndicator()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            CityDetails(cityDetails: cityDetails),
                            DayForecast(forecastDetails: dayForecast),
                            SevenDayForecast(weekWeatherDetails: weekForecast),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Header(
                    onChangeInput: (CityItem city) => onCityChange(city)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
