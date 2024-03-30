class User {
  String? token;
  String? username;
  String? firstName;
  String? lastName;

  User({
    this.token,
    this.username,
    this.firstName,
    this.lastName
  });

  factory User.fromJson(json){
    return User(
      username: json['username'],

    );
  } 
}
