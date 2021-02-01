class NotifikasiModel {
  int _id;
  String _id_content;
  String _title;
  String _body;
  String _tanggal;
  String _jam;
  String _jenis_notifikasi;
  String _status;
  NotifikasiModel(this._id_content, this._title, this._body, this._tanggal,
      this._jam, this._jenis_notifikasi, this._status);
  NotifikasiModel.map(dynamic obj) {
    this._id_content = obj["id_content"];
    this._title = obj["title"];
    this._body = obj["body"];
    this._tanggal = obj["tanggal"];
    this._jam = obj["jam"];
    this._jenis_notifikasi = obj["jenis_notifikasi"];
    this._status = obj["status"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id_content"] = this._id_content;
    map["title"] = this._title;
    map["body"] = this._body;
    map["tanggal"] = this._tanggal;
    map["jam"] = this._jam;
    map["jenis_notifikasi"] = this._jenis_notifikasi;
    map["status"] = this._status;
    return map;
  }
  // void setNotifikasiModelId(int id) {
  //   this._id = id;
  // }
}
