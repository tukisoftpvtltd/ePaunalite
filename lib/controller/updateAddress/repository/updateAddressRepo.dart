import 'dart:convert';
import 'package:http/http.dart' as http;


class UpdateAddressRepository {
  Future<bool> updateAddress(String sid,String hotelname,String phone,String address,String city) async {
    try {
  
      
      // print(apiUrl);
      // print(data);
      var mainDataUrl = "https://pauna.tukisoft.com.np/api/service/$sid";
        var response1 = await http.get(
        Uri.parse(mainDataUrl),
        headers: {'Content-Type': 'application/json',},
      );
       var mainData = json.decode(response1.body);
      // print(mainData);
      // print("the Bid is"+mainData['Bid']);
      //   print("the Email is "+mainData['Email']);
      var additionalDataUrl = "https://pauna.tukisoft.com.np/api/serviceBasicInformation/$sid";
       var response2 = await http.get(
        Uri.parse(additionalDataUrl),
        headers: {'Content-Type': 'application/json',},
      );
      var additionalData = json.decode(response2.body);
      // print(additionalData);
      // print("Google Map location is"+additionalData['GoogleMapLocation']);
      // print("description is"+additionalData['Description']);
      // print("Conatact us is"+additionalData['ContactUs']);
      var data2 ={
        "Address": address,
        "Bid": mainData['Bid'],
        "City": city,
        "ContactUs": additionalData['ContactUs'],
        "Description":additionalData['Description'],
        "Email": mainData['Email'],
        "FullName": hotelname,
        "GoogleMapLocation":additionalData['GoogleMapLocation'],
        "MobileNumber": phone
      };
      print(jsonEncode(data2));
      // if(true){
      // var postUrl = "https://pauna.tukisoft.com.np/api/service/$sid";
      //  var response3 = await http.post(
      //   Uri.parse(additionalDataUrl),
      //   headers: {'Content-Type': 'application/json',},
      //   body:data2,
      // );
      // }
      // print("Email is"+additionalData['Email']);
      // var updateData = jsonEncode(data);
      // var response = await http.post(
      //   Uri.parse(apiUrl),
      //   headers: {'Content-Type': 'application/json',},
      //   body: updateData,
      // );
      // var resposeData = jsonDecode(response.body);
      
      return true;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
