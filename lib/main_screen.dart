import 'package:flutter/material.dart';
import 'package:Proxcontrol/Client/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Proxcontrol/main.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  final Client client;
  const MainScreen({Key key, @required this.client}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState(client);
}

class _MainScreenState extends State<MainScreen> {
  Client client;
  SharedPreferences _preferences = getSharedPreferences();
  _MainScreenState(this.client);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen Placeholder"),
        centerTitle: true),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: screenWidth / 12,
                top: screenHeight / 10,
                right: screenWidth / 12),
              child: Text("Username: ${_preferences.getString('username')}"),
            ),

            Container(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  top: screenHeight / 10,
                  right: screenWidth / 12),
              child: Text("Ticket: ${_preferences.getString('ticket')}"),
            ),

            Container(
              padding: EdgeInsets.only(
                  left: screenWidth / 6,
                  top: screenHeight / 8,
                  right: screenWidth / 6),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: EdgeInsets.all(10),
                color: Colors.indigoAccent,
                child: Text("RESET PREFERENCES THEN EXIT", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () {
                  _preferences.clear().then((result) {
                    exit(0);
                  });
                },
              ),
            )
          ],
        )
      ),
    );
  }
}