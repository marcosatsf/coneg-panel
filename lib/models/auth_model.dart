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

  String toAuth() {
    return "$tokenType $accessToken";
  }
}
