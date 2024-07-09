import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/models/city_item.dart';

class SearchBarWithDropDown extends StatefulWidget {
  SearchBarWithDropDown({super.key, required this.onSelectCity});
  final Function onSelectCity;

  @override
  State<SearchBarWithDropDown> createState() => _SearchBarWithDropDownState();
}

class _SearchBarWithDropDownState extends State<SearchBarWithDropDown> {
  List<CityItem> cityList = [];

  Future<List<CityItem>> getCityList(String filter) async {
    print('getCityList called with filter: $filter');
    if (filter.length < 3) {
      print('Filter length is less than 3, returning empty list.');
      setState(() => cityList = []);
      return [];
    }

    final api_key = "d84f9b983e1f4d90acd124547240407";
    var url = "http://api.weatherapi.com/v1/search.json?key=$api_key&q=$filter";

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
            long: d['long'],
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

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<CityItem>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search for a city",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        menuProps: MenuProps(
          backgroundColor: Colors.white,
        ),
        emptyBuilder: (context, searchEntry) {
          return Center(
            child: Text(
              searchEntry.length < 3
                  ? "Enter at least 3 characters to search"
                  : "No cities found",
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        },
      ),
      items: cityList,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: "Select a city",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
        ),
      ),
      asyncItems: (String filter) async {
        print('asyncItems called with filter: $filter');
        return await getCityList(filter);
      },
      itemAsString: (CityItem? u) => u?.name ?? "",
      onChanged: (CityItem? data) {
        if (data != null) {
          print('City selected: ${data.name}, ${data.country}');
          widget.onSelectCity(data);
        }
      },
      dropdownBuilder: (context, selectedItem) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: selectedItem == null
              ? Text("Select a city", style: TextStyle(color: Colors.grey[600]))
              : Text(
                  "${selectedItem.name}, ${selectedItem.country}",
                  style: TextStyle(color: Colors.black87),
                ),
        );
      },
    );
  }
}
