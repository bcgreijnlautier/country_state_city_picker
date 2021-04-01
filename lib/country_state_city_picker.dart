library country_state_city_picker;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'model/select_status_model.dart' as StatusModel;

class SelectState extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final TextStyle? style;
  final Color? dropdownColor;
  final String selectCityText;
  final String selectStateText;
  final String selectCountryText;
  final double spacing;
  final double dropdownWidth;

  const SelectState({
    Key? key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    this.style,
    this.dropdownColor,
    this.selectCityText = 'City',
    this.selectStateText = 'State',
    this.selectCountryText = 'Country',
    this.spacing = 10,
    this.dropdownWidth = 150,
  }) : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  late List<String> _cities = [widget.selectCityText];
  late List<String> _country = [widget.selectCountryText];
  late String _selectedCity = widget.selectCityText;
  late String _selectedCountry = widget.selectCountryText;
  late String _selectedState = widget.selectStateText;
  late List<String> _states = [widget.selectStateText];
  var responses;

  @override
  void initState() {
    getCounty();
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        _country.add((model.emoji ?? '') + '    ' + (model.name ?? ''));
      });
    });

    return _country;
  }

  Future getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          print(statename.toString());

          _states.add(statename.toString());
        }
      });
    });

    return _states;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            print(citynames.toString());

            _cities.add(citynames.toString());
          }
        });
      });
    });
    return _cities;
  }

  void _onSelectedCountry(String? value) {
    if (!mounted || value == null) return;
    setState(() {
      _selectedState = "Choose State";
      _states = ["Choose State"];
      _selectedCountry = value;
      this.widget.onCountryChanged(value);
      getState();
    });
  }

  void _onSelectedState(String? value) {
    if (!mounted || value == null) return;
    setState(() {
      _selectedCity = "Choose City";
      _cities = ["Choose City"];
      _selectedState = value;
      this.widget.onStateChanged(value);
      getCity();
    });
  }

  void _onSelectedCity(String? value) {
    if (!mounted || value == null) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _country.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Text(
                      dropDownStringItem,
                      style: widget.style,
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => _onSelectedCountry(value),
            value: _selectedCountry,
          ),
        ),
        SizedBox(width: widget.spacing),
        SizedBox(
          child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _states.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem, style: widget.style),
              );
            }).toList(),
            onChanged: (value) => _onSelectedState(value),
            value: _selectedState,
          ),
        ),
        SizedBox(width: widget.spacing),
        SizedBox(
          child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _cities.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem, style: widget.style),
              );
            }).toList(),
            onChanged: (value) => _onSelectedCity(value),
            value: _selectedCity,
          ),
        ),
      ],
    );
  }
}
