class VM {
  final String id;
  final int maxdisk;
  final int netout;
  final int mem;
  final int vmid;
  final int disk;
  final int netin;
  final int diskread;
  final String pool;
  final String type;
  final int maxmem;
  final int maxcpu;
  final String node;
  final int diskwrite;
  final int uptime;
  final String status;
  final num cpu;
  final int template;
  final String name;

  VM({
    this.id,
    this.maxdisk,
    this.netout,
    this.mem,
    this.vmid,
    this.disk,
    this.netin,
    this.diskread,
    this.pool,
    this.type,
    this.maxmem,
    this.maxcpu,
    this.node,
    this.diskwrite,
    this.uptime,
    this.status,
    this.cpu,
    this.template,
    this.name
  });

  factory VM.fromJson(Map<String, dynamic> json) {
    return VM(
      id: json['id'] as String,
      maxdisk: json['maxdisk'] as int,
      netout: json['netout'] as int,
      mem: json['mem'] as int,
      vmid: json['vmid'] as int,
      disk: json['disk'] as int,
      netin: json['netin'] as int,
      diskread: json['diskread'] as int,
      pool: json['pool'] as String,
      type: json['type'] as String,
      maxmem: json['maxmem'] as int,
      maxcpu: json['maxcpu'] as int,
      node: json['node'] as String,
      diskwrite: json['diskwrite'] as int,
      uptime: json['uptime'] as int,
      status: json['status'] as String,
      cpu: json['cpu'] as num,
      template: json['template'] as int,
      name: json['name'] as String,
    );
  }
}