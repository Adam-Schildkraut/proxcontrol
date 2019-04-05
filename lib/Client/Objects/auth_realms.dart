class AuthRealm {
  final String type;
  final String realm;
  final String comment;

  AuthRealm({this.type, this.realm, this.comment});

  factory AuthRealm.fromJson(Map<String, dynamic> json) {
    return AuthRealm(
      type: json['type'],
      realm: json['realm'],
      comment: json['comment']
    );
  }
}