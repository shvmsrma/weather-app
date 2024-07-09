import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/models/city_item.dart';
import 'package:weather_app/models/city_row_dropdown.dart';
import 'package:weather_app/search_bar.dart';

class CitySearch extends StatefulWidget {
  final Function(CityItem) onSelectCity;

  CitySearch({required this.onSelectCity});

  @override
  _CitySearchState createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {
  List<CityItem> cityList = [];

  Future<List<CityItem>> getCityList(String text) async {
    print('getCityList called with filter:');
    if (text.length < 3) {
      setState(() {
        cityList = [];
      });
      return [];
    }
    final api_key = "d84f9b983e1f4d90acd124547240407";
    var url = "http://api.weatherapi.com/v1/search.json?key=$api_key&q=$text";

    var response = await http.get(Uri.parse(url));
    print({'response': response.body, 'status': response.statusCode});

    if (response.statusCode == 200) {
      List<CityItem> _cities = [];
      var data = jsonDecode(response.body) as List;
      print({'data': data});
      data.forEach((d) {
        _cities.add(CityItem(
            id: d['id'],
            name: d['name'],
            country: d['country'],
            region: d['region'],
            lat: d['lat'],
            long: d['lon'],
            url: d['url']));
      });

      setState(() {
        cityList = _cities;
      });

      print('City list updated with ${_cities.length} items.');
      return _cities;
    } else {
      print('Error fetching city list: ${response.statusCode}');
      setState(() => cityList = []);
      return [];
    }
  }

  onTap(CityItem city) {
    widget.onSelectCity(city);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarInput(onChangeInput: (String str) {
          getCityList(str);
        }),
        if (cityList.length > 0)
          Container(
            constraints: BoxConstraints(minHeight: 100),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), color: Colors.black),
            child: ListView(
                shrinkWrap: true,
                children: cityList.map((city) {
                  return CityRow(
                      city: city,
                      onTap: () => {
                            setState(() {
                              cityList = [];
                            }),
                            onTap(city)
                          });
                }).toList()),
          ),
      ],
    );
  }
}
