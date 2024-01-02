// ignore_for_file: unused_local_variable, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ePaunaLite/controller/ServiceProviderDetail/model/ServiceProviderDetailModel.dart';
import 'package:ePaunaLite/controller/ServiceProviderDetail/repository/ServiceProviderDetailRepo.dart';
import 'package:ePaunaLite/controller/updateAddress/repository/updateAddressRepo.dart';
import '../../Utils/colors.dart';
import '../../controller/address/address_model.dart';
import '../../controller/address/address_repository.dart';
import '/Views/app_data/colors.dart';
import '/Views/app_data/size.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainProfile extends StatefulWidget {
  String hotelName;
  String phoneno;
  String address;
  String city;
  MainProfile(
      {super.key,
      required this.hotelName,
      required this.phoneno,
      required this.address,
      required this.city});

  @override
  State<MainProfile> createState() => MainProfileState();
}

class MainProfileState extends State<MainProfile> {
  TextEditingController hotelname = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController current_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  // UpdatePasswordRepository updatePasswordRepository =
  //     UpdatePasswordRepository();
  final _formKey = GlobalKey<FormState>();
  var userId = '';
  int gender = 5;
  // late TextEditingController city;
  @override
  void initState() {
    hotelname.text = widget.hotelName;
    address.text = widget.address;
    phone.text = widget.phoneno;
    city.text = widget.city;
    super.initState();
    getSid();
  }

  String sid = '';
  getSid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sidValue = prefs.getString('sid');
    setState(() {
      sid = sidValue.toString();
    });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hotelName = prefs.getString('hotelName');
    String? phoneno = prefs.getString('phoneno');
    String? sidValue = prefs.getString('sid');
    String? addressValue = prefs.getString('address');
    String? cityValue = prefs.getString('city');
    setState(() {
      hotelname.text = hotelName!;
      phone.text = phoneno!;
      address.text = addressValue!;
      city.text = cityValue!;
      sid = sidValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSize size = AppSize(context: context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: PrimaryColors.primarywhite,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Service Information',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          leading: BackButton(color: Colors.black),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 2),
          child: Card(
            child: Container(
              decoration: BoxDecoration(color: whiteColor),
              child: Padding(
                padding: EdgeInsets.all(0),
                // EdgeInsets.fromLTRB(size.small() * 12, size.small() * 15,
                //     size.small() * 12, size.small() * 12),

                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.white,
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        // Text(
                        //   'Profile ',
                        //   style: TextStyle(
                        //     fontSize: 20 * size.ex_small(),
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),

                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.person_outline,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                widget.hotelName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: PrimaryColors.primaryblue,
                                  fontSize: 15 * size.ex_small(),
                                  fontWeight: FontWeight.w500,
                                  height: 1.5 * size.ex_small() / size.small(),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      height: 10,
                    ),
                    Container(
                      color: PrimaryColors.backgroundcolor,
                      height: 5,
                    ),
                    Container(
                      color: Colors.white,
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Your Information :',
                        style: TextStyle(
                          fontSize: 19 * size.ex_small(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.ex_small() * 13,
                    ),
                    textformfieldforfill(
                      ffem: size.ex_small(),
                      hint: "Hotel Name",
                      controller: hotelname,
                    ),
                    SizedBox(
                      height: size.ex_small() * 13,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number ';
                            }
                            if (value.length != 10) {
                              return 'Please enter valid phone number ';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.all(size.ex_small() * 10),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff7A7C7E),
                                fontSize: 16 * size.ex_small()),
                            hintText: 'Phone Number',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffA7A4A4)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffA7A4A4)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.ex_small() * 13,
                    ),
                    textformfieldforfill(
                      ffem: size.ex_small(),
                      hint: "Address",
                      controller: address,
                    ),
                    SizedBox(
                      height: size.ex_small() * 13,
                    ),
                    textformfieldforfill(
                      ffem: size.ex_small(),
                      hint: "City",
                      controller: city,
                    ),
                    SizedBox(
                      height: size.ex_small() * 20,
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) => AlertDialog(
                    //           title: Center(
                    //               child: Text(
                    //             'Change Password',
                    //             style: TextStyle(
                    //                 color: mainColor,
                    //                 fontWeight: FontWeight.bold),
                    //           )),
                    //           content: Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               crossAxisAlignment: CrossAxisAlignment.stretch,
                    //               children: [
                    //                 textformfieldforfill(
                    //                   ffem: size.ex_small(),
                    //                   hint: "Current Password",
                    //                   controller: current_password,
                    //                 ),
                    //                 SizedBox(
                    //                   height: size.ex_small() * 13,
                    //                 ),
                    //                 textformfieldforfill(
                    //                   lastIndex: true,
                    //                   ffem: size.ex_small(),
                    //                   hint: "New Password",
                    //                   controller: new_password,
                    //                 ),
                    //               ]),
                    //           actions: [
                    //             ElevatedButton(
                    //                 style: ElevatedButton.styleFrom(
                    //                     backgroundColor: mainColor),
                    //                 onPressed: () async {

                    //                   // await updatePasswordRepository
                    //                   //     .update(
                    //                   //         new_password: new_password.text,
                    //                   //         old_password: current_password.text)
                    //                   //     .then((value) {
                    //                   //   Navigator.pop(context);
                    //                   //   new_password.clear;
                    //                   //   current_password.clear;
                    //                   //   return showDialog(
                    //                   //       context: context,
                    //                   //       builder: (context) {
                    //                   //         return WillPopScope(
                    //                   //           onWillPop: () async {
                    //                   //             return false;
                    //                   //           },
                    //                   //           child: AlertDialog(
                    //                   //             content:
                    //                   //                 Text('${value['Message']}'),
                    //                   //             actions: [
                    //                   //               ElevatedButton(
                    //                   //                   style: ElevatedButton
                    //                   //                       .styleFrom(
                    //                   //                           backgroundColor:
                    //                   //                               mainColor),
                    //                   //                   onPressed: () {
                    //                   //                     Navigator.pop(context);
                    //                   //                   },
                    //                   //                   child: Text('Ok'))
                    //                   //             ],
                    //                   //           ),
                    //                   //         );
                    //                   //       });
                    //                   // });
                    //                   // // updateData(
                    //                   // //     apiType: 'PUT',
                    //                   // //     apiUrl:
                    //                   // //         '$baseUrl/api/updatePassword/$userId?OldPassword=${current_password.text}&NewPassword=${new_password.text}');
                    //                   // Navigator.pop(context);
                    //                 },
                    //                 child: Text('Update')),
                    //             ElevatedButton(
                    //                 style: ElevatedButton.styleFrom(
                    //                     backgroundColor: mainColor),
                    //                 onPressed: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //                 child: Text('Close'))
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //     child: Text(
                    //       'Do you want to change password ?',
                    //       style: TextStyle(color: mainColor),
                    //     )),

                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Loading'),
                                    CircularProgressIndicator.adaptive()
                                  ],
                                ),
                              );
                            });
                        UpdateAddressRepository repo =
                            UpdateAddressRepository();
                        bool checker = await repo.updateAddress(
                            sid,
                            hotelname.text,
                            phone.text,
                            address.text,
                            city.text);
                        if (checker == false) {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Update Failed",
                                    style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text("Error Occured"),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: mainColor),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'))
                                  ],
                                );
                              });
                        } else {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Updated Successfully",
                                    style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text("Update was successful"),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: mainColor),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'))
                                  ],
                                );
                              });
                        }

                        // if (_formKey.currentState!.validate()) {
                        //   setState(() {
                        //     storeUsername(firstname.text, lastname.text);
                        //     updateData(
                        //         apiType: 'PUT',
                        //         apiUrl:
                        //             'https://pauna.tukisoft.com.np/api/user/$userId?FirstName=${firstname.text}&LastName=${lastname.text}&UserId=$userId&Email=${email.text}&Gender=${gender}&MobileNumber=${phone.text}');
                        //   });
                        // }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          width: size.ex_small() * 100,
                          height: size.ex_small() * 45,
                          decoration: BoxDecoration(
                              color: mainColor,
                              border: Border.all(
                                  color: const Color(0xff968B8B), width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              "Save Changes",
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // !GetUserData
  Future<dynamic> getUserData(
      {required String apiUrl, required String apiType}) async {
    var headersList = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(apiUrl);
    var req = http.Request(apiType, url);
    req.headers.addAll(headersList);
    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    final body = jsonDecode(resBody);
    var data = {
      "FirstName": await body['FirstName'],
      "LastName": await body['LastName'],
      "UserId": await body['FirstName'],
      "Email": await body['Email'],
      "Gender": await body['Gender'],
      "MobileNumber": await body['MobileNumber'],
    };
    setState(() {
      storeUsername(data['FirstName'], data['LastName']);
      // firstname.text = data['FirstName'];
      // lastname.text = data['LastName'];
      phone.text = data['MobileNumber'] ?? '';
      // email.text = data['Email'] ?? '';
      gender = data['Gender'] ?? '';
    });
  }

  storeUsername(firstname, lastname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", '$firstname $lastname');
  }

  updateData({required String apiUrl, required String apiType}) async {
    var headersList = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(apiUrl);
    var req = await http.Request(apiType, url);
    req.headers.addAll(headersList);
    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    final body = jsonDecode(resBody);
    print(res.statusCode);
    (res.statusCode == 200)
        ? showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return await false;
                },
                child: AlertDialog(
                  content: Text('Successfully Updated'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pop(context);
                        },
                        child: Text('Ok'))
                  ],
                ),
              );
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Could not be Updated'),
                actions: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: mainColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'))
                ],
              );
            });
  }
}

class textformfieldforfill extends StatelessWidget {
  textformfieldforfill(
      {Key? key,
      this.lastIndex,
      required this.ffem,
      required this.controller,
      required this.hint})
      : super(key: key);
  String hint;
  bool? lastIndex;
  TextEditingController controller;
  final double ffem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        textInputAction:
            (lastIndex == true) ? TextInputAction.none : TextInputAction.next,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(ffem * 10),
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xff7A7C7E),
              fontSize: 16 * ffem),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffA7A4A4)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffA7A4A4)),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}

//1100
//1500
//2500