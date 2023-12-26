import 'dart:convert';

import 'package:paunalite/controller/manage_service/model/status_model.dart';
import 'package:http/http.dart' as http;

import '../../userData/userData.dart';

class UpdateServiceRepository {
  Future<StatusModel> updateService(String serviceId, String roomAvailable,
      String startDate, String endDate) async {
    String sid = await getId();
    try {
      var url = 'https://pauna.tukisoft.com.np/api/serviceStock';
      var body = {
        "Sid": sid,
        "ServiceId": serviceId,
        "inStock": roomAvailable,
        "startDate": startDate,
        "endDate": endDate
      };
      var response = await http.post(Uri.parse(url), body: body);
      var jsonDecoded = jsonDecode(response.body);
      StatusModel statusModel = StatusModel.fromJson(jsonDecoded);
      return statusModel;
    } catch (e) {
      rethrow;
    }
  }
}
