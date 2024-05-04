class Org {
  int id;
  List<int> orgEvents = const [];
  String name;
  String email;
  String description;
  bool isActive;
  String? lastLogin;
  // String? password;
  List<int> studentLeaders;


  Org({
    this.id = -1,
    this.orgEvents = const [],
    this.name = 'null name',
    this.email = 'null email',
    this.description = 'null description',
    this.isActive = false,
    this.lastLogin,
    // this.password,
    this.studentLeaders = const [],
  });

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
      studentLeaders: (json['studentLeaders'] as List<dynamic>).cast<int>(),
    );
  }
}
