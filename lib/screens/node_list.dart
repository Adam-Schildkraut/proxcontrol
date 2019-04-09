import 'package:flutter/material.dart';
import 'package:Proxcontrol/Client/Objects/node.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NodeListTab extends StatefulWidget {
  final List<Node> nodes;
  const NodeListTab({Key key, @required this.nodes}) : super(key: key);

  @override
  _NodeListTabState createState() => _NodeListTabState(nodes);
}

class _NodeListTabState extends State<NodeListTab> {
  List<Node> nodes;
  _NodeListTabState(this.nodes);

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