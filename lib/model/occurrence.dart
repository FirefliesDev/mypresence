class Occurrence {
  int id;
  String local;
  String date;
  String timeStart;
  String timeEnd;

  Occurrence({this.id, this.local, this.date, this.timeStart, this.timeEnd});

  Occurrence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    local = json['local'];
    date = json['date'];
    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['local'] = this.local;
    data['date'] = this.date;
    data['timeStart'] = this.timeStart;
    data['timeEnd'] = this.timeEnd;
    return data;
  }
}