class Event {
  int id;
  String? title;
  // String? orgID;
  // String? location;
  String? start;
  String? end;
  String? description;
  bool? studentsOnly;
  //List<String>? tags;
  String? tags;

  Event(
      {this.id = -1,
      this.title,
      //this.orgID,
      //this.location,
      this.start,
      this.end,
      this.description,
      this.studentsOnly,
      this.tags});

  factory Event.fromJson(json) {
    return Event(
        id: json['id'],
        title: json['title'],
        //orgID: json['orgID'],
        //location: json['location'],
        start: json['start'],
        end: json['end'],
        description: json['description'],
        studentsOnly: json['studentsOnly'],
        tags: json['tags']);
  }
}
