/*
class VM {
  VMData data;

  VM({this.data});

  factory VM.fromJson(Map<String, dynamic> parsedJson) {
    return VM(
        data: VMData.fromJson(parsedJson['data'])
    );
  }
}
*/

class VM {
  final int cpus;
  //final String maxdisk;
  //final String maxmem;
  final String name;
  //final String pid;
  //final String qmpstatus;
  final String status;
  //final String uptime;
  //final String vmid;

  VM({
    this.cpus,
    //this.maxdisk,
    //this.maxmem,
    this.name,
   // this.pid,
    //this.qmpstatus,
    this.status,
    //this.uptime,
    //this.vmid
  });

  factory VM.fromJson(Map<String, dynamic> json) {
    return VM(
      cpus: json['cpus'] as int,
     // maxdisk: json['maxdisk'] as String,
     // maxmem: json['maxmem'] as String,
      name: json['name'] as String,
     // pid: json['pid'] as String,
     // qmpstatus: json['qmpstatus'] as String,
      status: json['status'] as String,
     // uptime: json['uptime'] as String,
     // vmid: json['vmid'] as String
    );
  }
}