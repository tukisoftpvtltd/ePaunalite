import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_model.dart';
import '../model/updatePID_model.dart';


class loginRepository{
  Future<String?> login(String email ,String password,String playerId)async {
    try {
      updatePIDModel updatepidData;
      print("The player Id is");
      print(playerId);
      var loginUrl = "https://pauna.tukisoft.com.np/api/serviceProviderLogin";
      final Map<String, dynamic> loginData = {
        'LoginPassword':password,
        'LoginEmail':email
      };
      var response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData),
      );
      var loginResponse =jsonDecode(response.body);
      LoginModel loginModel = LoginModel.fromJson(loginResponse);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(loginModel.message);
      // loginModel.serviceProviderId
      if(loginModel.status ==true){
         prefs.setString('sid',loginModel.serviceProviderId! );
         prefs.setString('login','true' );
      var updatePIDUrl = "https://pauna.tukisoft.com.np/api/updateServiceProviderPlayerId";
      final Map<String, dynamic> data = {
        'Sid':loginModel.serviceProviderId,
        'playerId':playerId
      };
      print("The updates player id data is"+data.toString());
      var response2 = await http.post(
        Uri.parse(updatePIDUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      
      var updatePIDData =jsonDecode(response2.body);
      updatePIDModel updatepidData = updatePIDModel.fromJson(updatePIDData);
      return updatepidData.message;
      }
      return "User crendential is not valid";
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
