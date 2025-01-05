class User {
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? avatarUrl;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }
}