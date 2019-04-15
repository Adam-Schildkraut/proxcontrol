class VMStat {
  final int time;
  final num mem;
  final int maxdisk;
  final int disk;
  final num netin;
  final num diskread;
  final int maxcpu;
  final num netout;
  final num cpu;
  final int maxmem;
  final num diskwrite;

  VMStat({
    this.time,
    this.mem,
    this.maxdisk,
    this.disk,
    this.netin,
    this.diskread,
    this.maxcpu,
    this.netout,
    this.cpu,
    this.maxmem,
    this.diskwrite
  });

  factory VMStat.fromJson(Map<String, dynamic> json) {
    return VMStat(
      time: json['time'] as int,
      mem: json['mem'] as num,
      maxdisk: json['maxdisk'] as int,
      disk: json['disk'] as int,
      netin: json['netin'] as num,
      diskread: json['diskread'] as num,
      maxcpu: json['maxcpu'] as num,
      netout: json['netout'] as num,
      cpu: json['cpu'] as num,
      maxmem: json['maxmem'] as int,
      diskwrite: json['diskwrite'] as num,
    );
  }
}