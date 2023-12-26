class RequestModel {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  RequestModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  RequestModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  String? tCode;
  String? sid;
  String? userId;
  String? hotelType;
  String? bedType;
  String? rate;
  String? roomQuantity;
  String? checkinDate;
  String? checkoutDate;
  int? noOfGuest;
  String? note;
  String? paymentMethod;
  String? paymentId;
  String? total;
  String? discount;
  String? createdAt;
  String? updatedAt;
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;

  Data(
      {this.tCode,
      this.sid,
      this.userId,
      this.hotelType,
      this.bedType,
      this.rate,
      this.roomQuantity,
      this.checkinDate,
      this.checkoutDate,
      this.noOfGuest,
      this.note,
      this.paymentMethod,
      this.paymentId,
      this.total,
      this.discount,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.firstName,
      this.lastName,
      this.email});

  Data.fromJson(Map<String, dynamic> json) {
    tCode = json['tCode'];
    sid = json['sid'];
    userId = json['user_id'];
    hotelType = json['hotel_type'];
    bedType = json['bed_type'];
    rate = json['rate'];
    roomQuantity = json['room_quantity'];
    checkinDate = json['checkin_date'];
    checkoutDate = json['checkout_date'];
    noOfGuest = json['no_of_guest'];
    note = json['note'];
    paymentMethod = json['payment_method'];
    paymentId = json['payment_id'];
    total = json['total'];
    discount = json['discount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullName = json['FullName'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tCode'] = this.tCode;
    data['sid'] = this.sid;
    data['user_id'] = this.userId;
    data['hotel_type'] = this.hotelType;
    data['bed_type'] = this.bedType;
    data['rate'] = this.rate;
    data['room_quantity'] = this.roomQuantity;
    data['checkin_date'] = this.checkinDate;
    data['checkout_date'] = this.checkoutDate;
    data['no_of_guest'] = this.noOfGuest;
    data['note'] = this.note;
    data['payment_method'] = this.paymentMethod;
    data['payment_id'] = this.paymentId;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['FullName'] = this.fullName;
    data['FirstName'] = this.fullName;
    data['LastName'] = this.fullName;
    data['Email'] = this.email;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}