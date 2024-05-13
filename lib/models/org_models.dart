/// Org model
class Org {
  int id;
  List<int> orgEvents = const [];
  String name;
  String email;
  String description;
  bool isActive;
  String? lastLogin;
  // String? password;
  String? alias; // alias is the org's acronym (e.g. AAA, BRASA, CSA etc.)
  bool isFollowed;
  List<int> studentLeaders;

// Constructor
  Org({
    this.id = -1,
    this.orgEvents = const [],
    this.name = 'null org name',
    this.email = 'null org email',
    this.description = 'null org description',
    this.isActive = false,
    this.lastLogin,
    // this.password,
    this.alias,
    this.isFollowed = false,
    this.studentLeaders = const [],
  });

// Convert JSON to Org object
  factory Org.fromJson(json) {
    return Org(
      id: json['id'],
      orgEvents: (json['orgEvents'] as List<dynamic>).cast<int>(),
      name: json['name'],
      email: json['email'],
      description: json['description'],
      isActive: json['is_active'],
      lastLogin: json['last_login'],
      // password: json['password'],
      alias: json['alias'],
      isFollowed: json['isFollowed'],
      studentLeaders: (json['studentLeaders'] as List<dynamic>).cast<int>(),
    );
  }
}
