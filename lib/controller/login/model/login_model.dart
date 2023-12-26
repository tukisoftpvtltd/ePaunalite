class LoginModel {
  bool? status;
  String? message;
  String? serviceProviderId;

  LoginModel({this.status, this.message, this.serviceProviderId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    serviceProviderId = json['ServiceProviderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['ServiceProviderId'] = this.serviceProviderId;
    return data;
  }
}