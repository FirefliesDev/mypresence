class Occurrence {
  String id;
  String local;
  String date;
  String timeStart;
  String timeEnd;

  Occurrence({this.id, this.local, this.date, this.timeStart, this.timeEnd});

  Occurrence.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    local = json['local'];
    date = json['date'];
    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['local'] = this.local;
    data['date'] = this.date;
    data['timeStart'] = this.timeStart;
    data['timeEnd'] = this.timeEnd;
    return data;
  }
}