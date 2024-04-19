class Event {
  int id;
  String? title;
  int host;
  String? org; 
  String? location;
  String? start;
  String? end;
  String? description;
  bool? studentsOnly;
  String? tags;
  bool isFavoited;  

  Event(
      {this.id = -1,
      this.title,
      this.host = -1,
      this.org,
      this.location,
      this.start,
      this.end,
      this.description,
      this.studentsOnly,
      this.tags,
      this.isFavoited = false});

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
        tags: json['tags'],
        isFavoited: json['isFavorited']
        );
  }
}
