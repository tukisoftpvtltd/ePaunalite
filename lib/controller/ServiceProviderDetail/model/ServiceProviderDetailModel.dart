class ServiceProviderDetailModel {
  String? fullName;
  String? sid;
  String? email;
  String? mobileNumber;
  String? bid;
  String? categoryName;

  ServiceProviderDetailModel(
      {this.fullName,
      this.sid,
      this.email,
      this.mobileNumber,
      this.bid,
      this.categoryName});

  ServiceProviderDetailModel.fromJson(Map<String, dynamic> json) {
    fullName = json['FullName'];
    sid = json['Sid'];
    email = json['Email'];
    mobileNumber = json['MobileNumber'];
    bid = json['Bid'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FullName'] = this.fullName;
    data['Sid'] = this.sid;
    data['Email'] = this.email;
    data['MobileNumber'] = this.mobileNumber;
    data['Bid'] = this.bid;
    data['categoryName'] = this.categoryName;
    return data;
  }
}