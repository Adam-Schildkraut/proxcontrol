import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

class VMListTab extends StatefulWidget {
  @override
  _VMListTabState createState() => _VMListTabState();
}

class _VMListTabState extends State<VMListTab> {
  List<VM> vms = new List<VM>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    //vms = DataHandler.getVMList();
    _onRefresh();
  }

  Future<Null> _onRefresh() async {
    await Client.requestVMS();
    if (await DataHandler.showTemplates()) {
      setState(() {
        vms = DataHandler.getVMList();
      });
    } else if (!await DataHandler.showTemplates()){
      setState(() {
        vms = DataHandler.getVMList().where((i) => i.template == 0).toList();
      });
    }
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
            Color iconColor;
            if ((vms[index].status).contains("running")) {
              iconColor = Colors.green;
            } else if ((vms[index].status).contains("paused")) {
              iconColor = Colors.orange;
            } else if ((vms[index].status).contains("stopped")) {
              iconColor = Colors.grey;
            }

            return new ListTile(
                leading: Icon(FontAwesomeIcons.desktop, color: iconColor),
                title: Text("${vms[index].name}"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Text("CPU Usage: ${num.parse((vms[index].cpu * 100).toStringAsFixed(2))}%"),
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10),
                    ),
                    Text("RAM Usage: ${double.parse((((vms[index].mem / 1073741824) / (vms[index].maxmem / 1073741824)) * 100).toStringAsFixed(2))}%"),
                  ],
                )
            );
          },
        ),
        onRefresh: _onRefresh);
  }
}