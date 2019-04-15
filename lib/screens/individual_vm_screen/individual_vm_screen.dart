import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:Proxcontrol/screens/individual_vm_screen/tabs/control_options.dart';
import 'package:Proxcontrol/screens/individual_vm_screen/tabs/settings.dart';
import 'package:Proxcontrol/screens/individual_vm_screen/tabs/status.dart';

class IndividualVMScreen extends StatefulWidget {
  final VM vm;
  IndividualVMScreen({Key key, @required this.vm}) : super(key: key);

  @override
  _IndividualVMScreenState createState() => _IndividualVMScreenState(this.vm);
}

class _IndividualVMScreenState extends State<IndividualVMScreen> {
  final VM vm;
  _IndividualVMScreenState(this.vm);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("${vm.name}"),
            centerTitle: true,
            bottom: TabBar(
                tabs: [
                  Tab(text: "Status"),
                  Tab(text: "Control Options"),
                  Tab(text: "Settings",)
                ]),
          ),
          body: TabBarView(
              children: [
                Status(vm: vm),
                ControlOptions(vm: vm),
                Settings(vm: vm)
              ]),
        ));
  }
}