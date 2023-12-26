import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paunalite/controller/requestHistory/requestModel.dart';



class RequestRepository {
  Future<RequestModel> getrequestData(String sid) async {
    try {
  
      var apiUrl = "https://pauna.tukisoft.com.np/api/getBookingDataBySid/$sid";
      print(apiUrl);
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'}
      );
      var data = jsonDecode(response.body);
      RequestModel bookingData = RequestModel.fromJson(data);
      return bookingData;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
