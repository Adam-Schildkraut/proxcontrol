import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';

class ContainerListTab extends StatefulWidget {
  @override
  _ContainerTabState createState() => _ContainerTabState();
}

class _ContainerTabState extends State<ContainerListTab> {
  List<VM> containers;

  @override
  void initState() {
    super.initState();
    containers = DataHandler.getContainerList();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      itemCount: containers.length,
      padding: EdgeInsets.all(12),
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return new ListTile(
            leading: Icon(FontAwesomeIcons.desktop),
            title: Text("Name: ${containers[index].name}"),
            subtitle: Text("Status: ${containers[index].status}")
        );
      },
    );
  }
}