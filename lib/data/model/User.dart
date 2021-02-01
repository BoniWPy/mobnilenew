class User {
  int id;
  String _mobile;
  String _otp;

  User(this._mobile, this._otp);
  User.map(dynamic obj) {
    this._mobile = obj["mobile"];
    this._otp = obj["otp"];
    
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["mobile"] = this._mobile;
    map["otp"] = this._otp;
    return map;
  }
  void setUserId(int id) {
    this.id = id;
  }
}