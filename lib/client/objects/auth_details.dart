class AuthDetails {
  final String username;
  final String ticket;
  final String csrfprevetionToken;

  AuthDetails({this.username, this.ticket, this.csrfprevetionToken});

  factory AuthDetails.fromJson(Map<String, dynamic> json) {
    return AuthDetails(
        username: json['username'],
        ticket: json['ticket'],
        csrfprevetionToken: json['CSRFPreventionToken']
    );
  }
}