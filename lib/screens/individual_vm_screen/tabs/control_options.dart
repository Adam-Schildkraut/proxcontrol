import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';

class ControlOptions extends StatefulWidget {
  final VM vm;

  ControlOptions({Key key, @required this.vm}) : super(key: key);
  @override
  _ControlOptionsState createState() => _ControlOptionsState(this.vm);
}

class _ControlOptionsState extends State<ControlOptions> {
  final VM vm;
  _ControlOptionsState(this.vm);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Not Implemented"),
    );
  }
}