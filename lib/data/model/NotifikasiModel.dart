class NotifikasiModel {
  int _id;
  String _id_content;
  String _title;
  String _body;
  String _tanggal;
  String _jam;
  String _jenis_notifikasi;
  String _status;
  String _group_id;
  String _group_name;
  String _click_action;
  String _href;
  String _parameters;

  NotifikasiModel(
      this._id_content,
      this._title,
      this._body,
      this._tanggal,
      this._jam,
      this._jenis_notifikasi,
      this._status,
      this._group_id,
      this._group_name,
      this._click_action,
      this._href,
      this._parameters);

  NotifikasiModel.map(dynamic obj) {
    this._id_content = obj["id_content"];
    this._title = obj["title"];
    this._body = obj["body"];
    this._tanggal = obj["tanggal"];
    this._jam = obj["jam"];
    this._jenis_notifikasi = obj["jenis_notifikasi"];
    this._status = obj["status"];
    this._group_id = obj["grup_id"];
    this._group_name = obj["grup_name"];
    this._click_action = obj['click_action'];
    this._href = obj['href'];
    this._parameters = obj['parameters'];
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
    map["group_id"] = this._group_id;
    map["group_name"] = this._group_id;
    map["click_action"] = this._click_action;
    map["href"] = this._href;
    map["parameters"] = this._parameters;

    return map;
  }
}
