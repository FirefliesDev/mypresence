class Item {
  String id;
  String title;
  String description;

  Item({this.id, this.title, this.description});

  Item.fromJson(Map<dynamic, dynamic> snapshot)
      : title = snapshot["title"],
        description = snapshot["description"];
  toJson() {
    return {
      "title": title,
      "description": description,
    };
  }
}