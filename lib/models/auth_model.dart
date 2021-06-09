class AuthModel {
  String accessToken;
  String tokenType;

  AuthModel({this.accessToken, this.tokenType});

  void fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  void logout() {
    accessToken = '';
    tokenType = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}
