class Org {
  int? id;
  String? name;
  String? email;
  String? description;
  bool? is_active;
  String? last_login;
  // String? password;
  List<int>? studentLeaders;


  Org({
    this.id,
    this.name,
    this.email,
    this.description,
    this.is_active,
    this.last_login,
    // this.password,
    this.studentLeaders
  });

  factory Org.fromJson(json) {
    return Org(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      description: json['description'],
      is_active: json['is_active'],
      last_login: json['last_login'],
      // password: json['password'],
      studentLeaders: (json['studentLeaders'] as List<dynamic>).cast<int>(),
    );
  }
}
