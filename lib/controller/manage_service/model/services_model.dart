class ServiceModel {
  final String serviceId;
  final String serviceTitle;
  final String serviceSubTitle;
  final int inCount;
  final int outCount;
  final String startDate;
  final String endDate;

  ServiceModel({
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceSubTitle,
    required this.inCount,
    required this.outCount,
    required this.startDate,
    required this.endDate,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['ServiceId'],
      serviceTitle: json['ServiceTitle'],
      serviceSubTitle: json['ServiceSubTitle'],
      inCount: json['In'],
      outCount: json['Out'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
    );
  }
}
