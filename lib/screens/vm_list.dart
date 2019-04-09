import 'package:flutter/material.dart';
import 'package:Proxcontrol/Client/Objects/vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VMListTab extends StatefulWidget {
  final List<VM> vms;
  const VMListTab({Key key, @required this.vms}) : super(key: key);

  @override
  _VMListTabState createState() => _VMListTabState(vms);
}

class _VMListTabState extends State<VMListTab> {
  List<VM> vms;
  _VMListTabState(this.vms);

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      itemCount: vms.length,
      padding: EdgeInsets.all(12),
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return new ListTile(
            leading: Icon(FontAwesomeIcons.desktop),
            title: Text("Name: ${vms[index].name}"),
            subtitle: Text("Status: ${vms[index].status}")
        );
      },
    );
  }
}