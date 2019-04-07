import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:Proxcontrol/server_details_login_screen.dart';

class GettingStartedSceen extends StatelessWidget {
  final pages = [
    PageViewModel(
        pageColor: Colors.indigo,
        title: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text('Welcome to Proxcontrol',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 42))),
        mainImage: Image.asset('assets/logo.png'),
        body: Text('Take control of your Proxmox cluster today. With everything you need to manage your installation, Proxcontrol is the perfect mobile companion app.'),
        bubble: Icon(FontAwesomeIcons.desktop)
    ),

    PageViewModel(
        pageColor: Colors.indigo,
        title: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text('VM Management',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 42))),
        mainImage: Image.asset('assets/logo.png'),
        body: Text('With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.'),
        bubble: Icon(FontAwesomeIcons.desktop)
    ),

    PageViewModel(
        pageColor: Colors.indigo,
        title: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text('LXC Management',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 42))),
        mainImage: Image.asset('assets/logo.png'),
        body: Text('With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.'),
        bubble: Icon(FontAwesomeIcons.cube)
    ),

    PageViewModel(
        pageColor: Colors.indigo,
        title: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text('Cluster Management',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 42))),
        mainImage: Image.asset('assets/logo.png'),
        body: Text('With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.'),
        bubble: Icon(FontAwesomeIcons.server)
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => IntroViewsFlutter(
            pages,
            fullTransition: 300,
            background: Colors.transparent,
            showSkipButton: false,
            onTapDoneButton: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ServerDetailsLoginScreen()));
            },
            pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0)
        )
    );
  }


  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proxcontrol',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Builder(
          builder: (context) => IntroViewsFlutter(
              pages,
              fullTransition: 300,
              background: Colors.transparent,
              showSkipButton: false,
              onTapDoneButton: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ServerDetailsLoginScreen()));
                },
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0)
          )
      ),
    );
  }
  */

}
