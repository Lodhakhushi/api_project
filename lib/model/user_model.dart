class UserModel {
  String? name;
  String? email;
  String? password;

  UserModel({required this.name, required this.email, required this.password});

  factory UserModel.fromDoc(Map<String, dynamic> doc) {
    return UserModel(
        name: doc['name'],
        email: doc['email'],
        password: doc['password']);
  }

  Map<String, dynamic> toDoc() {
    return {"name": name, "email": email, "password": password};
  }
}
