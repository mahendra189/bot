class User {
  final String firstName;
  final String LastName;
  final String phoneNumber;
  final String systemID;
  final String profileImageUrl;

  User({
    required this.firstName,
    required this.LastName,
    required this.phoneNumber,
    required this.systemID,
    required this.profileImageUrl,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      firstName: data['firstName'],
      LastName: data['LastName'],
      phoneNumber: data['phoneNumber'],
      systemID: data['systemID'],
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'LastName': LastName,
      'phoneNumber': phoneNumber,
      'systemID': systemID,
      'profileImageUrl': profileImageUrl,
    };
  }

}