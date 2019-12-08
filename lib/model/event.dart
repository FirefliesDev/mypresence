class Event {
  String id;
  String title;
  String descripton;
  String countParticipants;

  Event({this.id, this.title, this.descripton, this.countParticipants});

  Event.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descripton = json['descripton'];
    countParticipants = json['count_participants'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descripton'] = this.descripton;
    data['count_participants'] = this.countParticipants;
    return data;
  }
}
