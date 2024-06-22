class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  User(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}
