class User {
  String? token;
  String? username;
  String? firstName;
  String? lastName;
  String? email;

  User({this.token, this.username, this.firstName, this.lastName, this.email});

  factory User.fromJson(json) {
    return User(
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email']);
  }
}
