class Occurrence {
  String id;
  String local;
  String date;
  String timeStart;
  String timeEnd;
  String qrCode;

  Occurrence(
      {this.id,
      this.local,
      this.date,
      this.timeStart,
      this.timeEnd,
      this.qrCode});

  Occurrence.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    local = json['local'];
    date = json['date'];
    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
    qrCode = json['qrCode'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['local'] = this.local;
    data['date'] = this.date;
    data['timeStart'] = this.timeStart;
    data['timeEnd'] = this.timeEnd;
    data['qrCode'] = this.qrCode;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Occurrence &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          local == other.local &&
          date == other.date &&
          timeStart == other.timeStart &&
          timeEnd == other.timeEnd &&
          qrCode == other.qrCode;

  @override
  int get hashCode =>
      id.hashCode ^
      local.hashCode ^
      date.hashCode ^
      local.hashCode ^
      timeStart.hashCode ^
      timeEnd.hashCode ^
      qrCode.hashCode;
}
