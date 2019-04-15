import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:Proxcontrol/screens/individual_container_screen/tabs/control_options.dart';
import 'package:Proxcontrol/screens/individual_container_screen/tabs/settings.dart';
import 'package:Proxcontrol/screens/individual_container_screen/tabs/status.dart';

class IndividualContainerScreen extends StatefulWidget {
  final VM container;
  IndividualContainerScreen({Key key, @required this.container}) : super(key: key);

  @override
  _IndividualContainerScreenState createState() => _IndividualContainerScreenState(this.container);
}

class _IndividualContainerScreenState extends State<IndividualContainerScreen> {
  final VM container;
  _IndividualContainerScreenState(this.container);

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
            title: Text("${container.name}"),
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
                Status(container: container),
                ControlOptions(vm: container),
                Settings(vm: container)
              ]),
        ));
  }
}