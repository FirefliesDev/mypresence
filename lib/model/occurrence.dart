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
}
