class StatusModel {
  bool? status;
  String? update;

  StatusModel({this.status, this.update});

  StatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    update = json['update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['update'] = this.update;
    return data;
  }
}
