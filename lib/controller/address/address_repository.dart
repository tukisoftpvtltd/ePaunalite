import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'address_model.dart';

class addressRepository{
  Future<ServiceProviderAddressModel> getAddress(String sid)async {
    try {
      
      var addressUrl = "https://pauna.tukisoft.com.np/api/serviceBasicInformation/$sid";
      print("The sid is");
      print(sid);
      print(addressUrl);
      var response = await http.get(
        Uri.parse(addressUrl),
        headers: {'Content-Type': 'application/json'},
      );
      var addressResponse =jsonDecode(response.body);
      ServiceProviderAddressModel addressModel = ServiceProviderAddressModel.fromJson(addressResponse);

      return addressModel;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
