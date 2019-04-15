import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';

class Settings extends StatefulWidget {
  final VM vm;

  Settings({Key key, @required this.vm}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState(this.vm);
}

class _SettingsState extends State<Settings> {
  final VM vm;
  _SettingsState(this.vm);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Not Implemented"),
    );
  }
}