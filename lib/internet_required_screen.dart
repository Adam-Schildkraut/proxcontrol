import 'package:flutter/material.dart';
import 'dart:io';

class InternetRequiredScreen extends StatefulWidget {

  @override
  _InternetRequiredScreenState createState() => _InternetRequiredScreenState();
}

class _InternetRequiredScreenState extends State<InternetRequiredScreen> {

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
                    top: screenHeight / 6,
                    right: screenWidth / 12),
                child: Text("This app requires internet access to function. Please try again when you are connected to the internet.", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),

              Container(
                padding: EdgeInsets.only(
                    left: screenWidth / 6,
                    top: screenHeight / 4,
                    right: screenWidth / 6),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.all(10),
                  color: Colors.indigoAccent,
                  child: Text("EXIT", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    exit(0);
                  },
                ),
              )
            ],
          )
      ),
    );
  }
}