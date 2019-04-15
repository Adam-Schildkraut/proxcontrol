import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/screens/main_lists/tabs/container_list.dart';
import 'package:Proxcontrol/screens/main_lists/tabs/node_list.dart';
import 'package:Proxcontrol/screens/main_lists/tabs/vm_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _ticket;
  String _username;
  bool _showTemplates = false;

  @override
  void initState() {
    DataHandler.showTemplates().then((status) {
      _showTemplates = status;
    });

    DataHandler.getTicket().then((ticket) {
      setState(() {
        _ticket = ticket;
      });
    });

    DataHandler.getUsername().then((username) {
      setState(() {
        _username = username;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return new DefaultTabController (
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
                  SwitchListTile(
                    title: Text("Display Templates"),
                    value: _showTemplates,
                    secondary: Icon(FontAwesomeIcons.copy),
                    onChanged: (status) async {
                      setState(() {
                        _showTemplates = status;
                      });
                      await DataHandler.setShowTemplates(status);
                    },
                  ),
                  ListTile(
                    title: Text("Username: $_username"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Ticket: $_ticket"),
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