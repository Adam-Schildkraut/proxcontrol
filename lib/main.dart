import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Widget _defaultHome = new WelcomeScreen();
  bool _seen = false;

  SharedPreferences preferences = await SharedPreferences.getInstance();
  _seen = (preferences.get('seen') ?? false);

  if (_seen) {
    _defaultHome = new HomeScreen();
  }

  runApp(new MaterialApp(
    title: 'Proxcontrol',
    home: _defaultHome,
    theme: new ThemeData(
      primarySwatch: Colors.indigo,
      accentColor: Colors.brown,
    ),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('VM listig will go here by default.'),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        primary: false,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 1/12),
        crossAxisCount: 1,
        children: <Widget>[
          Text('Welcome to Proxcontrol', textAlign: TextAlign.center, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25), textScaleFactor: 1),
          RaisedButton(
                child: Text('GET STARTED', style: TextStyle(fontSize: 14, letterSpacing: 1.25, fontWeight: FontWeight.w500)),
                onPressed: () {
                  _disableFirstStartup();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new HomeScreen()));
                }
          )
        ],
      ),
    );
  }

  Future _disableFirstStartup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('seen', true);
  }
}