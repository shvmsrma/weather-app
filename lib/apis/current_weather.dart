import 'dart:convert';
import 'package:http/http.dart' as http;

getCurrentWeatherDetails(double? lat, double? long) async {
  print(lat);
  final api_key = "d84f9b983e1f4d90acd124547240407";
  var url =
      "http://api.weatherapi.com/v1/current.json?key=$api_key&q=$lat,$long";
  await http.get(Uri.parse(url)).then((value) {
    var data = jsonDecode(value.body);
    print(data);
    return data;
  });
}

getDayForecast(double? lat, double? long) async {
  final api_key = "d84f9b983e1f4d90acd124547240407";
  var url =
      "http://api.weatherapi.com/v1/current.json?key=$api_key&q=$lat,$long";
  await http.get(Uri.parse(url)).then((value) {
    var data = jsonDecode(value.body);
    return data;
  });
}
