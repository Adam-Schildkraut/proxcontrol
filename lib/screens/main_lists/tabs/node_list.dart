import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/node.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

class NodeListTab extends StatefulWidget {

  @override
  _NodeListTabState createState() => _NodeListTabState();
}

class _NodeListTabState extends State<NodeListTab> {
  List<Node> _nodes = new List<Node>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _nodes = DataHandler.getNodeList();
  }

  Future<Null> _onRefresh() async {
    await Client.requestNodes();
    _nodes = DataHandler.getNodeList();
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: ListView.separated(
        itemCount: _nodes.length,
        padding: EdgeInsets.all(12),
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          Color iconColor;
          if ((_nodes[index].status).contains("online")) {
            iconColor = Colors.green;
          } else if ((_nodes[index].status).contains("offline")) {
            iconColor = Colors.grey;
          }

          return new ListTile(
            leading: Icon(FontAwesomeIcons.server, color: iconColor),
            title: Text("${_nodes[index].node}"),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Text("CPU Usage: ${num.parse((_nodes[index].cpu * 100).toStringAsFixed(2))}%"),
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 14),
                ),
                Text("RAM Usage: ${double.parse((((_nodes[index].mem / 1073741824) / (_nodes[index].maxmem / 1073741824)) * 100).toStringAsFixed(2))}%"),
              ],
            ),
          );
        },
      ),
    );
  }
}