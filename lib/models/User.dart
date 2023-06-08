class User {
  int? userId;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? profilePic;


  User({this.userId, this.userName, this.email, this.firstName, this.lastName, this.profilePic});


  factory User.fromJson(Map<String,dynamic> responseData){
    return User(
      userId: responseData['id'],
      userName: responseData['username'],
      email : responseData['email'],
      firstName: responseData['first_name'],
      lastName : responseData['last_name'],
      profilePic: responseData['profile_pic'],
    );
  }
}