class Event {
  int id;
  String? title;
  String? host;
  String? org; 
  String? location;
  String? start;
  String? end;
  String? description;
  bool? studentsOnly;
  String? tags;

  Event(
      {this.id = -1,
      this.title,
      this.host,
      this.org,
      this.location,
      this.start,
      this.end,
      this.description,
      this.studentsOnly,
      this.tags});

  factory Event.fromJson(json) {
    return Event(
        id: json['id'],
        title: json['title'],
        host: json['host'],
        org: json['parentOrg'],
        location: json['location'],
        start: json['start'],
        end: json['end'],
        description: json['description'],
        studentsOnly: json['studentsOnly'],
        tags: json['tags']);
  }
}
