class User {
  String id;
  String identifier;
  String provider;
  String photoUrl;
  String displayName;
  bool present;

  User(
      {this.id,
      this.identifier,
      this.provider,
      this.photoUrl,
      this.displayName,
      this.present = false});

  User.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    provider = json['provider'];
    photoUrl = json['photo_url'];
    displayName = json['display_name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['identifier'] = this.identifier;
    data['provider'] = this.provider;
    data['photo_url'] = this.photoUrl;
    data['display_name'] = this.displayName;
    return data;
  }
}
