import 'dart:convert';
/// reason : "Your otp is correct"
/// status : "SUCCESS"

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));
String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());
class OtpResponse {
  OtpResponse({
      String? reason, 
      String? status,}){
    _reason = reason;
    _status = status;
}

  OtpResponse.fromJson(dynamic json) {
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