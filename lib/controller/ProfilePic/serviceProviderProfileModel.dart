class ServiceProviderProfile {
  String? logo;

  ServiceProviderProfile({this.logo});

  ServiceProviderProfile.fromJson(Map<String, dynamic> json) {
    logo = json['Logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Logo'] = this.logo;
    return data;
  }
}
