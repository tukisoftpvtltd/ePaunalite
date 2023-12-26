class ServiceProviderAddressModel {
  String? sid;
  String? address;
  String? contactUs;
  String? website;
  String? googleMapLocation;
  String? description;
  String? city;
  String? generalFacilitiy;
  String? popularFacilitiy;
  String? services;
  int? min;
  int? max;
  String? createdAt;
  String? updatedAt;

  ServiceProviderAddressModel(
      {this.sid,
      this.address,
      this.contactUs,
      this.website,
      this.googleMapLocation,
      this.description,
      this.city,
      this.generalFacilitiy,
      this.popularFacilitiy,
      this.services,
      this.min,
      this.max,
      this.createdAt,
      this.updatedAt});

  ServiceProviderAddressModel.fromJson(Map<String, dynamic> json) {
    sid = json['Sid'];
    address = json['Address'];
    contactUs = json['ContactUs'];
    website = json['Website'];
    googleMapLocation = json['GoogleMapLocation'];
    description = json['Description'];
    city = json['City'];
    generalFacilitiy = json['GeneralFacilitiy'];
    popularFacilitiy = json['PopularFacilitiy'];
    services = json['Services'];
    min = json['min'];
    max = json['max'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Sid'] = this.sid;
    data['Address'] = this.address;
    data['ContactUs'] = this.contactUs;
    data['Website'] = this.website;
    data['GoogleMapLocation'] = this.googleMapLocation;
    data['Description'] = this.description;
    data['City'] = this.city;
    data['GeneralFacilitiy'] = this.generalFacilitiy;
    data['PopularFacilitiy'] = this.popularFacilitiy;
    data['Services'] = this.services;
    data['min'] = this.min;
    data['max'] = this.max;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}