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
        return new ListTile(
          leading: Icon(FontAwesomeIcons.server),
          title: Text("Name: ${nodes[index].node}"),
          subtitle: Text("Status: ${nodes[index].status}"),
        );
      },
    );
  }
}