class UsersModel {
  final String email;
  final int? id;

  UsersModel({this.id, required this.email});

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(id: map['id'] as int, email: map['email'] as String);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }
}
