class AuthRealm {
  String type;
  String realm;
  String comment;

  AuthRealm(String type, String realm, String comment) {
    this.type = type;
    this.realm = realm;
    this.comment = comment;
  }

  AuthRealm.fromJson(Map json)
      : type = json['type'],
        realm = json['realm'],
        comment = json['comment'];

  Map toJson() {
    return {'type' : type, 'realm' : realm, 'comment' : comment};
  }

  String getType() {
    return type;
  }

  String getRealm() {
    return realm;
  }

  String getComment() {
    return comment;
  }
}