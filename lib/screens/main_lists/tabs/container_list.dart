import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';
import 'package:Proxcontrol/screens/individual_container_screen/individual_container_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ContainerListTab extends StatefulWidget {
  @override
  _ContainerTabState createState() => _ContainerTabState();
}

class _ContainerTabState extends State<ContainerListTab> {
  List<VM> _containers = new List<VM>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  Future<Null> _onLoad() async {
    if (await DataHandler.showTemplates()) {
      setState(() {
        _containers = DataHandler.getContainerList();
      });
    } else if (!await DataHandler.showTemplates()){
      setState(() {
        _containers = DataHandler.getContainerList().where((i) => i.template == 0).toList();
      });
    }
  }

  Future<Null> _onRefresh() async {
    await Client.requestVMS();
    if (await DataHandler.showTemplates()) {
      setState(() {
        _containers = DataHandler.getContainerList();
      });
    } else if (!await DataHandler.showTemplates()){
      setState(() {
        _containers = DataHandler.getContainerList().where((i) => i.template == 0).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      onRefresh: _onRefresh,
      key: _refreshIndicatorKey,
      child: ModalProgressHUD(
          inAsyncCall: _processing,
          child: ListView.separated(
            itemCount: _containers.length,
            padding: EdgeInsets.all(12),
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              Color iconColor;
              if ((_containers[index].status).contains("running")) {
                iconColor = Colors.green;
              } else if ((_containers[index].status).contains("stopped")) {
                iconColor = Colors.grey;
              }

              return new ListTile(
                  onTap: () async {
                    setState(() {
                      _processing = true;
                    });
                    await Client.requestVMStats(_containers[index].node, _containers[index].vmid, "hour", "AVERAGE");
                    await Future.delayed(new Duration(seconds: 1), () {
                      setState(() {
                        _processing = false;
                      });
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            IndividualContainerScreen(container: _containers[index])));
                  },
                  leading: Icon(FontAwesomeIcons.cube, color: iconColor),
                  title: Text("${_containers[index].name}"),
                  subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                            child: Text("CPU Usage: ${num.parse((_containers[index].cpu * 100).toStringAsFixed(2))}%"),
                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 14)),
                        Text("RAM Usage: ${double.parse((((_containers[index].mem / 1073741824) / (_containers[index].maxmem / 1073741824)) * 100).toStringAsFixed(2))}%")
                      ]
                  )
              );
            },
          ),
      )
    );
  }
}