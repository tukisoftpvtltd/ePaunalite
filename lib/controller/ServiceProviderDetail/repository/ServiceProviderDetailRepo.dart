import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/ServiceProviderDetailModel.dart';


class ServiceProvideDetailRepository {
  Future<ServiceProviderDetailModel> getServiceProvideDetail(String sid) async {
    try {
  
      var apiUrl = "https://pauna.tukisoft.com.np/api/service/$sid";
      print(apiUrl);
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'}
      );
      var data = jsonDecode(response.body);
      ServiceProviderDetailModel hotelDetailModel =  ServiceProviderDetailModel.fromJson(data);
      return hotelDetailModel;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
