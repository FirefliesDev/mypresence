class Event {
  String id;
  String title;
  String descripton;

  Event({this.id, this.title, this.descripton});

  Event.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descripton = json['descripton'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descripton'] = this.descripton;
    return data;
  }
}