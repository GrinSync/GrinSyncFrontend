class Event {
  int id;
  String title;
  int host;
  String? hostName;
  int? org;
  String location;
  String? start;
  String? end;
  String description;
  bool? studentsOnly;
  List<String>? tags;
  bool isFavorited;
  int? nextRepeat;

  Event({
    this.id = -1,
    this.title = '',
    this.host = -1,
    this.hostName,
    this.org,
    this.location = '',
    this.start,
    this.end,
    this.description = 'No description provided.',
    this.studentsOnly = false,
    this.tags,
    this.isFavorited = false,
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
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      isFavorited: json['isFavorited'],
      nextRepeat: json['nextRepeat'],
    );
  }
}
