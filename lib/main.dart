import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Proxcontrol/main_screen.dart';
import 'package:Proxcontrol/getting_started_screen.dart';
import 'package:Proxcontrol/Client/client.dart';
import 'package:Proxcontrol/logged_out_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Proxcontrol/internet_required_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Proxcontrol/Client/Objects/node.dart';
import 'package:Proxcontrol/Client/Objects/vm.dart';

SharedPreferences _preferences;
FlutterSecureStorage _sStorage;

void main() async {

  Widget _defaultHome = new GettingStartedScreen();
  _sStorage = new FlutterSecureStorage();

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
      Client client;
      List<VM> vms = new List<VM>();
      List<Node> nodes = new List<Node>();

      url = _preferences.getString('url');
      port = _preferences.getString('port');

      client = new Client(url, port);
      await client.getNewTicket().then((response) async {
        if (response) {
          await client.getNodes().then((response) {
            nodes = response;
          });

          await client.getAllVMs().then((response) {
            vms = response;
          });

          _defaultHome = MainScreen(client: client, nodes: nodes, vms: vms);
        } else {
          _defaultHome = LoggedOutScreen();
        }
      });
    }
  }

  runApp(App(_defaultHome));
}

SharedPreferences getSharedPreferences() {
  return _preferences;
}

FlutterSecureStorage getSecureStorage() {
  return _sStorage;
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

