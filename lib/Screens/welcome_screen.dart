import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Proxcontrol/Screens/Login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Getting Started"),
      ),
      body: GridView.count(
        primary: false,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 1/12),
        crossAxisCount: 1,
        children: <Widget>[
          RaisedButton(
              child: Text('GET STARTED', style: TextStyle(fontSize: 14, letterSpacing: 1.25, fontWeight: FontWeight.w500)),
              onPressed: () {
                _disableFirstStartup();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => new LoginPage()));
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