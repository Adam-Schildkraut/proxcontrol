import 'package:flutter/material.dart';
import 'package:Proxcontrol/server_details_login_screen.dart';

class LoggedOutScreen extends StatefulWidget {
  @override
  _LoggedOutScreenState createState() => _LoggedOutScreenState();
}

class _LoggedOutScreenState extends State<LoggedOutScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Logged Out"),
        centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: screenWidth / 12,
                right: screenWidth / 12),
              child: Text("You have been logged out. In order to access your VM's please log back in.", textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
            ),

            Container(
              padding: EdgeInsets.only(
                  left: screenWidth / 6,
                  top: screenHeight / 3,
                  right: screenWidth / 6),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
                padding: EdgeInsets.all(10),
                color: Colors.indigoAccent,
                child: Text("LOGIN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>
                      ServerDetailsLoginScreen()));
                },
              ),
            )
          ],
        ),
      )
    );
  }
}