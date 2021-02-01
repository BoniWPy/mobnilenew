class User {
  String _mobile;
  String _otp;
  User(this._mobile, this._otp);

  User.map(dynamic obj) {
    this._mobile = obj["mobile"];
    this._otp = obj["otp"];
  }

  String get username => _mobile;
  String get password => _otp;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["mobile"] = _mobile;
    map["otp"] = _otp;

    return map;
  }
}
