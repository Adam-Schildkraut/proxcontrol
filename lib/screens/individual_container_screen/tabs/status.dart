import 'package:flutter/material.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Proxcontrol/client/objects/vm_stat.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

class Status extends StatefulWidget {
  final VM container;

  Status({Key key, @required this.container}) : super(key: key);
  @override
  _StatusState createState() => _StatusState(this.container);
}

class _StatusState extends State<Status> {
  final VM container;
  static List<VMStat> stats;
  _StatusState(this.container);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  List<String> _timeIntervals = ["Hour", "Day", "Week", "Month", "Year"];
  String _selectedTimeInterval = "Hour";

  static List<charts.Series<CPUStats, DateTime>> _createCPUData() {
    List<CPUStats> data = [];
    for (int i = 0; i < stats.length; i++) {
      num number;
      if (stats[i].cpu == null) {
        number = 0;
      } else {
        number = num.parse((stats[i].cpu * 100).toStringAsFixed(2));
      }
      data.add(CPUStats(DateTime.fromMillisecondsSinceEpoch(stats[i].time*1000), number));
    }

    return [
      new charts.Series<CPUStats, DateTime>(
        id: 'CPU',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CPUStats time, _) => time.time,
        measureFn: (CPUStats percent, _) => percent.cpu,
        data: data,
      )
    ];
  }

  static List<charts.Series<RAMStats, DateTime>> _createRAMData() {
    List<RAMStats> data = [];
    for (int i = 0; i < stats.length; i++) {
      num number;
      if (stats[i].mem == null) {
        number = 0;
      } else {
        number = num.parse((stats[i].mem / 1073741824).toStringAsFixed(2));
      }
      data.add(RAMStats(DateTime.fromMillisecondsSinceEpoch(stats[i].time*1000), number));
    }

    return [
      new charts.Series<RAMStats, DateTime>(
        id: 'RAM',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (RAMStats time, _) => time.time,
        measureFn: (RAMStats usage, _) => usage.mem,
        data: data,
      )
    ];
  }

  static List<charts.Series<DiskIOStats, DateTime>> _createDiskIOData() {
    List<DiskIOStats> diskRead = [];
    List<DiskIOStats> diskWrite = [];

    for (int i = 0; i < stats.length; i++) {
      num read;
      num write;

      if (stats[i].diskread == null) {
        read = 0;
      } else read = num.parse((stats[i].diskread).toStringAsFixed(2));

      if (stats[i].diskwrite == null) {
        write = 0;
      } else write = num.parse((stats[i].diskwrite).toStringAsFixed(2));
      diskRead.add(DiskIOStats(DateTime.fromMillisecondsSinceEpoch(stats[i].time*1000), read));
      diskWrite.add(DiskIOStats(DateTime.fromMillisecondsSinceEpoch(stats[i].time*1000), write));
    }

    return [
      new charts.Series<DiskIOStats, DateTime>(
        id: 'Read',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DiskIOStats time, _) => time.time,
        measureFn: (DiskIOStats usage, _) => usage.speed,
        data: diskRead,
      ),
      new charts.Series<DiskIOStats, DateTime>(
        id: 'Write',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DiskIOStats time, _) => time.time,
        measureFn: (DiskIOStats usage, _) => usage.speed,
        data: diskWrite,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    stats = DataHandler.getVMStatsList();
  }

  // TODO Make this work to refresh data
  Future<Null> _onRefresh() async {
    await Client.requestVMStats(container.node, container.vmid, _selectedTimeInterval, "AVERAGE");
    setState(() {
      stats = DataHandler.getVMStatsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: ListView(
        children: <Widget>[
          /*
          DropdownButton(
            value: _selectedTimeInterval,
            onChanged: (newValue) {
              setState(() {
                _selectedTimeInterval = newValue;
                _onRefresh();
              });
            },
            items: _timeIntervals.map((interval) {
              return DropdownMenuItem(
                child: new Text(interval),
                value: interval,
              );
            }).toList(),
          ),
          */
          Container(
            padding: EdgeInsets.only(left: width / 30, right: width / 30, top: height / 30),
            height: height /2.5,
            child: Card(
              child: charts.TimeSeriesChart(
                _createCPUData(),
                animate: false,
                behaviors: [
                  new charts.ChartTitle(
                      "CPU",
                      behaviorPosition: charts.BehaviorPosition.top,
                      titleOutsideJustification: charts.OutsideJustification.middle,
                      innerPadding: 18),
                  new charts.ChartTitle(
                      "%",
                      titleDirection: charts.ChartTitleDirection.horizontal,
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                  new charts.ChartTitle(
                      "Time",
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification: charts.OutsideJustification.middle)
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: width / 30, right: width / 30, top: height / 30),
            height: height /2.5,
            child: Card(
              child: charts.TimeSeriesChart(
                _createRAMData(),
                animate: false,
                behaviors: [
                  new charts.ChartTitle(
                      "RAM",
                      behaviorPosition: charts.BehaviorPosition.top,
                      titleOutsideJustification: charts.OutsideJustification.middle,
                      innerPadding: 18),
                  new charts.ChartTitle(
                      "gb",
                      titleDirection: charts.ChartTitleDirection.horizontal,
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                  new charts.ChartTitle(
                      "Time",
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification: charts.OutsideJustification.middle)
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: width / 30, right: width / 30, top: height / 30, bottom: height / 30),
            height: height /2,
            child: Card(
              child: charts.TimeSeriesChart(
                _createDiskIOData(),
                animate: false,
                behaviors: [
                  new charts.ChartTitle(
                      "Disk IO",
                      behaviorPosition: charts.BehaviorPosition.top,
                      titleOutsideJustification: charts.OutsideJustification.middle,
                      innerPadding: 18),
                  new charts.ChartTitle(
                      "k",
                      titleDirection: charts.ChartTitleDirection.horizontal,
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                  new charts.ChartTitle(
                      "Time",
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification: charts.OutsideJustification.middle),
                  new charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      outsideJustification: charts.OutsideJustification.middleDrawArea
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CPUStats {
  final DateTime time;
  final num cpu;

  CPUStats(this.time, this.cpu);
}

class RAMStats {
  final DateTime time;
  final num mem;

  RAMStats(this.time, this.mem);
}

class DiskIOStats {
  final DateTime time;
  final num speed;

  DiskIOStats(this.time, this.speed);
}