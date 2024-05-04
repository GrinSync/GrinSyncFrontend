class User {
  String? token;
  int? id;
  String? username;
  String firstName;
  String lastName;
  String? email;
  String? type;
  List<String>? interestedTags; // commented out because it is not used as of now. Also, it should only be used for other users (current user's interested tags are stored in PREFERREDTAGS in global.dart)
  List<int>? childOrgs;

  User(
      {this.token,
      this.id,
      this.firstName = '',
      this.lastName = '',
      this.email,
      this.type,
      this.interestedTags,
      this.childOrgs
      });

  factory User.fromJson(json) {
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        type: json['type'],
        interestedTags: (json['interestedTags'] as List<dynamic>).cast<String>(),
        childOrgs: (json['childOrgs'] as List<dynamic>).cast<int>()
        );

  }
}
