import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/updatePlayerIdModel.dart';


class updateServiceProviderPlayerIdRepository {
  Future<UpdatePlayerIdModel> updateServiceProviderPlayerId(String sid, String PlayerId) async {
    try {
  
      var apiUrl = "https://pauna.tukisoft.com.np/api/updateServiceProviderPlayerId/";
      final Map<String, dynamic> data = {
        'Sid':sid,
        'playerId':PlayerId
      };
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      var data2 = jsonDecode(response.body);
      UpdatePlayerIdModel updateplayerIdModel =  UpdatePlayerIdModel.fromJson(data2);
      return updateplayerIdModel;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
