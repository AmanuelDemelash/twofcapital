class UserModel {
  String? uid;
  String? email;
  String? phone;
  String? name;

  UserModel({this.uid, this.email, this.phone, this.name});

  // You can add a method to create a User object from a Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      phone: data['phone'],
      name: data['name'],
    );
  }
}
