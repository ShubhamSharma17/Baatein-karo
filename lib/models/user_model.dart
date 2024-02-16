class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phoneNumber;
  String? profilePicture;

  UserModel({
    this.email,
    this.name,
    this.phoneNumber,
    this.profilePicture,
    this.uid,
  });
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    phoneNumber = map['phoneNumber'];
    profilePicture = map['profilePicture'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}
