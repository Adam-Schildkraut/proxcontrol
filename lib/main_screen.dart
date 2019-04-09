import 'package:flutter/material.dart';
import 'package:Proxcontrol/Client/client.dart';
import 'package:Proxcontrol/screens/node_list.dart';
import 'package:Proxcontrol/screens/vm_list.dart';
import 'package:Proxcontrol/screens/container_list.dart';
import 'package:Proxcontrol/Client/Objects/node.dart';
import 'package:Proxcontrol/Client/Objects/vm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Proxcontrol/main.dart';
import 'dart:io';


class MainScreen extends StatefulWidget {
  final Client client;
  final List<Node> nodes;
  final List<VM> vms;
  const MainScreen({Key key, @required this.client, @required this.nodes, @required this.vms}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState(client, nodes, vms);
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences _preferences = getSharedPreferences();

  List<Node> nodes;
  List<VM> vms;
  Client client;
  _MainScreenState(this.client, this.nodes, this.vms);

  @override
  void initState() {
    super.initState();
  }

  void _clearAppData() async {
    final _sStorage = getSecureStorage();
    await _sStorage.deleteAll();
    _preferences.clear().then((result) {
      exit(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void _showDialog(String title, String message, bool shouldExit) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  if (shouldExit) {
                    exit(0);
                  } else Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    /*
    client.getNodes().then((response) {
      nodes = response;
    }).catchError((e) {
      print(e.toString());
      _showDialog("Fetch Error", "Unable to fetch the list of nodes. Please check your connection and try again.", true);
    });

    client.getAllVMs().then((response) {
      vms = response;
    }).catchError((e) {
      print(e.toString());
      _showDialog("Fetch Error", "Unable to fetch the list of VMs. Please check your connection and try again.", true);
    });
    */

    return new DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              centerTitle: true,
              bottom: TabBar(
                  tabs: [
                    Tab(text: "VMs"),
                    Tab(text: "Containers"),
                    Tab(text: "Nodes")
                  ]),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Dev Menu'),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                    ),
                  ),
                  ListTile(
                    title: Text("Username: ${_preferences.getString('username')}"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Ticket: ${_preferences.getString('ticket')}"),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: screenHeight / 20,left: screenWidth / 12, right: screenWidth / 12, bottom: screenHeight / 40),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      padding: EdgeInsets.all(10),
                      color: Colors.indigoAccent,
                      child: Text("RESET PREFERENCES THEN EXIT", textAlign: TextAlign.center),
                      onPressed: () {
                        _clearAppData();
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
                children: [
                  VMListTab(vms: vms),
                  ContainerListTab(),
                  NodeListTab(nodes: nodes)
                ])
        )
    );
  }
}