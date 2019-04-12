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
        Color iconColor;
        if ((containers[index].status).contains("running")) {
          iconColor = Colors.green;
        } else if ((containers[index].status).contains("paused")) {
          iconColor = Colors.orange;
        } else if ((containers[index].status).contains("stopped")) {
          iconColor = Colors.grey;
        }

        return new ListTile(
            leading: Icon(FontAwesomeIcons.cube, color: iconColor),
            title: Text("${containers[index].name}"),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  child: Text("CPU Usage: ${num.parse((containers[index].cpu * 100).toStringAsFixed(2))}%"),
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10),
                ),
                Text("RAM Usage: ${double.parse((((containers[index].mem / 1073741824) / (containers[index].maxmem / 1073741824)) * 100).toStringAsFixed(2))}%"),
              ],
            )
        );
      },
    );
  }
}