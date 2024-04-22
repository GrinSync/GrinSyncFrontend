class User {
  String? token;
  int id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;

  User(
      {this.token,
      this.id = -1,
      this.username,
      this.firstName,
      this.lastName,
      this.email});

  factory User.fromJson(json) {
    return User(
        username: json['username'],
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email']);
  }
}
