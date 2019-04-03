import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Proxcontrol/Screens/home_screen.dart';
import 'package:Proxcontrol/Screens/welcome_screen.dart';

void main() async {
  Widget _defaultHome = new WelcomeScreen();
  bool _seen = false;

  SharedPreferences preferences = await SharedPreferences.getInstance();
  //_seen = (preferences.get('seen') ?? false);

  if (_seen) {
    _defaultHome = new HomeScreen();
  }

  runApp(new MaterialApp(
    title: 'Proxcontrol',
    home: _defaultHome,
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primaryColor: Colors.indigo,
      fontFamily: 'Nunito'
    ),
  ));
}