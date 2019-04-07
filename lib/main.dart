import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Proxcontrol/main_screen.dart';
import 'package:Proxcontrol/getting_started_screen.dart';
import 'package:Proxcontrol/Client/client.dart';
import 'package:Proxcontrol/logged_out_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Proxcontrol/internet_required_screen.dart';


SharedPreferences _preferences;

void main() async {

  Widget _defaultHome = new GettingStartedSceen();

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    _defaultHome = InternetRequiredScreen();
  } else {
    bool _seen = false;

    _preferences = await SharedPreferences.getInstance();
    _seen = (_preferences.get('seen') ?? false);

    if (_seen) {
      String url;
      String port;
      String ticket;
      Client client;

      url = _preferences.getString('url');
      port = _preferences.getString('port');
      ticket = _preferences.getString('ticket');

      if (ticket != null) {
        if (ticket.contains('')) {
          client = new Client(url, port);
          await client.getNewTicket().then((response) {
            if (response) {
              _defaultHome = MainScreen(client: client);
            } else {
              _defaultHome = LoggedOutScreen();
            }
          });
        }
      }
    }
  }

  runApp(App(_defaultHome));
}

SharedPreferences getSharedPreferences() {
  return _preferences;
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

