import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';
import 'package:Proxcontrol/screens/individual_vm_screen/individual_vm_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VMListTab extends StatefulWidget {
  @override
  _VMListTabState createState() => _VMListTabState();
}

class _VMListTabState extends State<VMListTab> {
  List<VM> _vms = new List<VM>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    //vms = DataHandler.getVMList();
    _onLoad();
  }

  Future<Null> _onLoad() async {
    if (await DataHandler.showTemplates()) {
      setState(() {
        _vms = DataHandler.getVMList();
      });
    } else if (!await DataHandler.showTemplates()){
      setState(() {
        _vms = DataHandler.getVMList().where((i) => i.template == 0).toList();
      });
    }
  }

  Future<Null> _onRefresh() async {
    await Client.requestVMS();
    if (await DataHandler.showTemplates()) {
      setState(() {
        _vms = DataHandler.getVMList();
      });
    } else if (!await DataHandler.showTemplates()){
      setState(() {
        _vms = DataHandler.getVMList().where((i) => i.template == 0).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: ModalProgressHUD(
          inAsyncCall: _processing,
          child: ListView.separated(
            itemCount: _vms.length,
            padding: EdgeInsets.all(12),
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              Color iconColor;
              if ((_vms[index].status).contains("running")) {
                iconColor = Colors.green;
              } else if ((_vms[index].status).contains("paused")) {
                iconColor = Colors.orange;
              } else if ((_vms[index].status).contains("stopped")) {
                iconColor = Colors.grey;
              }

              return new ListTile(
                  onTap: () async {
                    setState(() {
                      _processing = true;
                    });
                    await Client.requestVMStats(_vms[index].node, _vms[index].vmid, "hour", "AVERAGE");
                    await Future.delayed(new Duration(seconds: 1), () {
                      setState(() {
                        _processing = false;
                      });
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            IndividualVMScreen(vm: _vms[index])));
                  },
                  leading: Icon(FontAwesomeIcons.desktop, color: iconColor),
                  title: Text("${_vms[index].name}"),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text("CPU Usage: ${num.parse((_vms[index].cpu * 100).toStringAsFixed(2))}%"),
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 14),
                      ),
                      Text("RAM Usage: ${double.parse((((_vms[index].mem / 1073741824) / (_vms[index].maxmem / 1073741824)) * 100).toStringAsFixed(2))}%"),
                    ],
                  )
              );
            },
          ),
      )
    );
  }
}