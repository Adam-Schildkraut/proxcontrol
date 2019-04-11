import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/screens/container_list.dart';
import 'package:Proxcontrol/screens/node_list.dart';
import 'package:Proxcontrol/screens/vm_list.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    title: Text("Username: ${DataHandler.getUsername()}"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Ticket: ${DataHandler.getTicket()}"),
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
                        DataHandler.clearAllData();
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
                children: [
                  VMListTab(),
                  ContainerListTab(),
                  NodeListTab()
                ])
        )
    );
  }
}