import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/node.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';

class NodeListTab extends StatefulWidget {

  @override
  _NodeListTabState createState() => _NodeListTabState();
}

class _NodeListTabState extends State<NodeListTab> {
  List<Node> nodes;

  @override
  void initState() {
    super.initState();
    nodes = DataHandler.getNodeList();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      itemCount: nodes.length,
      padding: EdgeInsets.all(12),
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        Color iconColor;
        if ((nodes[index].status).contains("online")) {
          iconColor = Colors.green;
        } else if ((nodes[index].status).contains("offline")) {
          iconColor = Colors.grey;
        }

        return new ListTile(
          leading: Icon(FontAwesomeIcons.server, color: iconColor),
          title: Text("${nodes[index].node}"),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text("CPU Usage: ${num.parse((nodes[index].cpu * 100).toStringAsFixed(2))}%"),
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10),
              ),
              Text("RAM Usage: ${double.parse((((nodes[index].mem / 1073741824) / (nodes[index].maxmem / 1073741824)) * 100).toStringAsFixed(2))}%"),
            ],
          ),
        );
      },
    );
  }
}