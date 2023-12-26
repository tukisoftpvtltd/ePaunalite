import 'dart:convert';
import 'dart:developer';

import 'package:paunalite/controller/userData/userData.dart';

import '../model/services_model.dart';
import 'package:http/http.dart' as http;

class GetServiceRepository {
  Future<List<ServiceModel>> getServices() async {
    String sid = await getId();
    try {
      var url = 'https://pauna.tukisoft.com.np/api/serviceStock/$sid';

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonDecoded = jsonDecode(response.body);
        log(jsonDecoded.toString());

        List<ServiceModel> services =
            jsonDecoded.map((item) => ServiceModel.fromJson(item)).toList();

        return services;
      } else {
        // Handle error response here if needed
        throw Exception('Failed to load services');
      }
    } catch (e) {
      rethrow;
    }
  }
}
