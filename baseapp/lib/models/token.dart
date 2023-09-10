class Token {
  String? idToken;
  String? username;
  String? userTypeID;
  String? email;
  String? fullName;
  String? userType;
  String? hashinfo;
  String? result;
  String? message;

  Token(
      {this.idToken,
      this.username,
      this.userTypeID,
      this.email,
      this.fullName,
      this.userType});

  Token.fromJson(Map<String, dynamic> json) {
    idToken = json['id_token'];
    username = json['username'];
    userTypeID = json['userTypeID'];
    email = json['email'];
    fullName = json['fullName'];
    userType = json['userType'];
    hashinfo = json['hashinfo'];
  }

  Token.fromJsonLogin(Map<String, dynamic> json) {
    email = json['email'];
    result = json['result'];
    message = json['message'];
  }

  Token.fromJsonSignUp(Map<String, dynamic> json) {
    email = json['email'];
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_token'] = this.idToken;
    data['username'] = this.username;
    data['userTypeID'] = this.userTypeID;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['userType'] = this.userType;
    data['hashinfo'] = this.hashinfo;
    return data;
  }
}
