/*
class Node {
  NodeData data;

  Node({this.data});

  factory Node.fromJson(Map<String, dynamic> parsedJson) {
    return Node(
        data: NodeData.fromJson(parsedJson['data'])
    );
  }
}
*/

class Node {
  final String level;
  final int maxcpu;
  final double cpu;
  final String type;
  final int maxmem;
  final String status;
  final String node;
  final String ssl_fingerprint;
  final int maxdisk;
  final int disk;
  final int uptime;
  final int mem;
  final String id;


  Node({
    this.level,
    this.maxcpu,
    this.cpu,
    this.type,
    this.maxmem,
    this.status,
    this.node,
    this.ssl_fingerprint,
    this.maxdisk,
    this.disk,
    this.uptime,
    this.mem,
    this.id
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      level: json['level'] as String,
      maxcpu: json['maxcpu'] as int,
      cpu: json['cpu'] as double,
      type: json['type'] as String,
      maxmem: json['maxmem'] as int,
      status: json['status'] as String,
      node: json['node'] as String,
      ssl_fingerprint: json['ssl_fingerprint'] as String,
      maxdisk: json['maxdisk'] as int,
      disk: json['disk'] as int,
      uptime: json['uptime'] as int,
      mem: json['mem'] as int,
      id: json['id'] as String,
    );
  }
}