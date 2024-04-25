class Event {
  int id;
  String? title;
  int host;
  String? hostName;
  String? org;
  String? location;
  String? start;
  String? end;
  String? description;
  bool? studentsOnly;
  String? tags;
  bool isFavoited;
  int? nextRepeat;

  Event({
    this.id = -1,
    this.title,
    this.host = -1,
    this.hostName,
    this.org,
    this.location,
    this.start,
    this.end,
    this.description,
    this.studentsOnly,
    this.tags,
    this.isFavoited = false,
    this.nextRepeat,
  });

  factory Event.fromJson(json) {
    return Event(
      id: json['id'],
      title: json['title'],
      host: json['host'],
      hostName: json['hostName'],
      org: json['parentOrg'],
      location: json['location'],
      start: json['start'],
      end: json['end'],
      description: json['description'],
      studentsOnly: json['studentsOnly'],
      tags: json['tags'],
      isFavoited: json['isFavorited'],
      nextRepeat: json['nextRepeat'],
    );
  }
}
