import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';

class VMListTab extends StatefulWidget {
  @override
  _VMListTabState createState() => _VMListTabState();
}

class _VMListTabState extends State<VMListTab> {
  List<VM> vms;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    vms = DataHandler.getVMList();
  }

  Future<Null> _onRefresh() async {
    await Client.requestVMS();
    setState(() {
      vms = DataHandler.getVMList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
        child: ListView.separated(
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
        ),
        onRefresh: _onRefresh);
  }
}