class Event {
  int id;
  String title;
  String descripton;

  Event({this.id, this.title, this.descripton});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descripton = json['descripton'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descripton'] = this.descripton;
    return data;
  }
}