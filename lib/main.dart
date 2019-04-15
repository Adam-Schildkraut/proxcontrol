import 'package:flutter/material.dart';
import 'package:Proxcontrol/screens/main_lists/main_lists_screen.dart';
import 'package:Proxcontrol/getting_started_screen.dart';
import 'package:Proxcontrol/logged_out_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Proxcontrol/internet_required_screen.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

void main() async {
  // Initialize the Data handler system including client connection support
  print("Initializing DataHandler...");
  await DataHandler.init();

  // Set the default homescreen of the app to the onboarding screen
  print("Setting default home to GettingStarted screen...");
  Widget _defaultHome = new GettingStartedScreen();

  // Check if the device has internet connectivity, either cellular or wifi
  // Set the homescreen to the InternetRequiredScreen if there is no connectivity
  print("Checking network connectivity...");
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    print("Connectivity Check Failed - Setting home screen to InternetRequiredScreen...");
    _defaultHome = InternetRequiredScreen();
  } else {

    print("Connectivity Check Passed. Checking for previous configurations...");
    if (await DataHandler.hasBeenSetup()) {
      print("Previous Configurations Found - Logging in...");

      int loginCode = await Client.login();
      print("Receiving login status: $loginCode");

      await Client.login().then((returnCode) async {
        print("Receiving login status: $returnCode");
        if (returnCode == 200) {
          print("Requesting VMs and Nodes");
          if (await Client.requestVMS() && await Client.requestNodes()) {
            print("VMs and Nodes Recieved - Setting homescreen to MainScreen");
            _defaultHome = MainScreen();
          } else {
            print("Failed to get VMs and Nodes - Setting homescreen to LoggedOutScreen");
            _defaultHome = LoggedOutScreen();
          }
        } else {
          print("An error occurred logging in - Setting homescreen to LoggedOutScreen");
          _defaultHome = LoggedOutScreen();
        }
      }).catchError((e) {
        print(e.toString());
        print("An error has occurred - Setting homscreen to LoggedOutScreen");
        _defaultHome = LoggedOutScreen();
      });
    }
  }

  print("Runing the app");
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

