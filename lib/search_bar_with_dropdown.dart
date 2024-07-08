import 'package:flutter/material.dart';
import 'package:weather_app/models/city_row_dropdown.dart';
import 'package:weather_app/search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchBarWithDropDown extends StatefulWidget {
  SearchBarWithDropDown({super.key, required this.onSelectCity});
  final Function onSelectCity;

  State<SearchBarWithDropDown> createState() => _SearchBarWithDropDownState();
}

class _SearchBarWithDropDownState extends State<SearchBarWithDropDown> {
  List<Map> cityList = [
    {
      "id": 1116327,
      "name": "Hisar",
      "region": "Haryana",
      "country": "India",
      "lat": 29.17,
      "lon": 75.72,
      "url": "hisar-haryana-india"
    },
    {
      "id": 3126051,
      "name": "Hisai",
      "region": "Mie",
      "country": "Japan",
      "lat": 34.67,
      "lon": 136.47,
      "url": "hisai-mie-japan"
    },
    {
      "id": 2435261,
      "name": "Hisarlikaya",
      "region": "Ankara",
      "country": "Turkey",
      "lat": 39.73,
      "lon": 32.54,
      "url": "hisarlikaya-ankara-turkey"
    }
  ];
  var isDropDownVisible = false;

  void getCityList(String seachStr) async {
    final api_key = "d84f9b983e1f4d90acd124547240407";
    var url =
        "http://api.weatherapi.com/v1/search.json?key=$api_key&q=$seachStr";
    await http.get(Uri.parse(url)).then((value) {
      var data = jsonDecode(value.body);
      print({data, "asfsfs"});
      setState(() {
        cityList = List<Map>.from(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onChangeInput(val) {
      if (val.length > 2) {
        setState(() {
          isDropDownVisible = true;
        });
        getCityList(val);
      } else {
        setState(() {
          isDropDownVisible = false;
        });
      }
    }

    void onSelectCity(city) {
      widget.onSelectCity(city);
    }

    return Column(
      children: [
        Stack(
          children: [
            SearchBarInput(onChangeInput: onChangeInput),
            if (isDropDownVisible)
              Positioned(
                top:
                    70, // Adjust this value based on the height of the search bar
                left: 0,
                right: 0,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 200, // Adjust height as needed
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...cityList.map((city) => CityRow(
                              city: city["name"],
                              state: city['region'],
                              country: city['country'],
                              data: city,
                              onTap: () {
                                onSelectCity(city);
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Other elements in the column
      ],
    );
  }
}
