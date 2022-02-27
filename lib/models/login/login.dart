import 'dart:convert';
/// reason : "The signin is successful"
/// status : "SUCCESS"
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwaXl1c2hnb2VsMjhAZ21haWwuY29tIn0.QP8ywW_c1_ZXzXrJlNxtxXNxvf6AQ6N2w2K_U5K7GVsDTqL725o-TIt1s52BX5bo2Wv7VzZuMvi-JBPr8VuCgQ"
/// emailId : "piyushgoel28@gmail.com"
/// name : "piyushgoel28@gmail.com"
/// contact : "9891006457"

Login loginFromJson(String str) => Login.fromJson(json.decode(str));
String loginToJson(Login data) => json.encode(data.toJson());
class Login {
  Login({
      String? reason, 
      String? status, 
      String? token, 
      String? emailId, 
      String? name, 
      String? contact,
      String? imageUrl}){
    _reason = reason;
    _status = status;
    _token = token;
    _emailId = emailId;
    _name = name;
    _contact = contact;
    _profileImageUrl = profileImageUrl;
}

  Login.fromJson(dynamic json) {
    _reason = json['reason'];
    _status = json['status'];
    _token = json['token'];
    _emailId = json['emailId'];
    _name = json['name'];
    _contact = json['contact'];
    _profileImageUrl = json['profileImageUrl'];
  }
  String? _reason;
  String? _status;
  String? _token;
  String? _emailId;
  String? _name;
  String? _contact;
  String? _profileImageUrl;

  String? get reason => _reason;
  String? get status => _status;
  String? get token => _token;
  String? get emailId => _emailId;
  String? get name => _name;
  String? get contact => _contact;
  String? get profileImageUrl => _profileImageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reason'] = _reason;
    map['status'] = _status;
    map['token'] = _token;
    map['emailId'] = _emailId;
    map['name'] = _name;
    map['contact'] = _contact;
    map['profileImageUrl'] = _profileImageUrl;
    return map;
  }

}