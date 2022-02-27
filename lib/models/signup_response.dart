import 'dart:convert';
/// reason : "An otp has been sent to your registered emailId "
/// status : "SUCCESS"

SignupResponse signupResponseFromJson(String str) => SignupResponse.fromJson(json.decode(str));
String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());
class SignupResponse {
  SignupResponse({
      String? reason, 
      String? status,}){
    _reason = reason;
    _status = status;
}

  SignupResponse.fromJson(dynamic json) {
    _reason = json['reason'];
    _status = json['status'];
  }
  String? _reason;
  String? _status;

  String? get reason => _reason;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reason'] = _reason;
    map['status'] = _status;
    return map;
  }

}