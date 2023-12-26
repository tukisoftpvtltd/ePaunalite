import 'dart:convert';
import 'package:http/http.dart' as http;
import 'serviceProviderProfileModel.dart';

class ServiceProviderProfileRepository {
  Future<ServiceProviderProfile> getServiceProvideProfile(String sid) async {
    try {
  
      var apiUrl = "https://pauna.tukisoft.com.np/api/serviceProviderProfilePic?Sid=$sid";
      print(apiUrl);
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'}
      );
      var data = jsonDecode(response.body);
      ServiceProviderProfile profileModel =  ServiceProviderProfile.fromJson(data);
      return profileModel;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
