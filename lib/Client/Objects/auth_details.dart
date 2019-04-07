class AuthDetails {
  AuthDetailsData data;

  AuthDetails({this.data});

  factory AuthDetails.fromJson(Map<String, dynamic> parsedJson) {
    return AuthDetails(
      data: AuthDetailsData.fromJson(parsedJson['data'])
    );
  }
}

class AuthDetailsData {
  final String username;
  final String ticket;
  final String csrfprevetionToken;

  AuthDetailsData({this.username, this.ticket, this.csrfprevetionToken});

  factory AuthDetailsData.fromJson(Map<String, dynamic> json) {
    return AuthDetailsData(
      username: json['username'],
      ticket: json['ticket'],
      csrfprevetionToken: json['CSRFPreventionToken']
    );
  }
}