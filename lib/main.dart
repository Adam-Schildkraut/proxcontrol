import 'package:flutter/material.dart';
import 'package:Proxcontrol/main_screen.dart';
import 'package:Proxcontrol/getting_started_screen.dart';
import 'package:Proxcontrol/logged_out_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Proxcontrol/internet_required_screen.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

void main() async {
  // Initialize the Data handler system including client connection support
  await DataHandler.init();

  // Set the default homescreen of the app to the onboarding screen
  Widget _defaultHome = new GettingStartedScreen();

  // Check if the device has internet connectivity, either cellular or wifi
  // Set the homescreen to the InternetRequiredScreen if there is no connectivity
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    _defaultHome = InternetRequiredScreen();
  } else {

    if (await DataHandler.hasBeenSetup()) {
      await Client.login().then((returnCode) async {
        if (returnCode == 200) {
          await Client.requestVMS();
          await Client.requestNodes();
          _defaultHome = MainScreen();
        } else {
          _defaultHome = LoggedOutScreen();
        }
      }).catchError((e) {
        print(e.toString());
        _defaultHome = LoggedOutScreen();
      });
    }
  }

  runApp(App(_defaultHome));
}

class App extends StatelessWidget {
  final _defaultHome;

  App(this._defaultHome);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proxcontrol',
      theme: ThemeData(
        primarySwatch: Colors.indigo),
      home: _defaultHome,
    );
  }
}

