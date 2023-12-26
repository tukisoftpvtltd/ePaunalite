import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paunalite/controller/requestHistory/requestRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../controller/requestHistory/requestModel.dart';

class RequestHistory extends StatefulWidget {
  RequestHistory({super.key});

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  RequestModel? requestModel;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');
    RequestRepository repo = new RequestRepository();
    requestModel = await repo.getrequestData(sid!);
    print(sid);
    print(requestModel!.data?.length);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PrimaryColors.primarywhite,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Request History',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: loading == true
          ? const Center(child: CupertinoActivityIndicator())
          :  Container(
              height: height - 130,
              child: requestModel!.data != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: requestModel?.data?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          width: width,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Text(
                                    "${requestModel?.data![index].checkinDate}",
                                    // "hi",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${requestModel?.data![index].hotelType}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Rs. ${requestModel?.data![index].total}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${requestModel?.data![index].bedType}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Text(
                                        "Status : Accepted",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: PrimaryColors.primarygreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Stay Duration : From ${requestModel?.data![index].checkinDate} to \n${requestModel?.data![index].checkoutDate} ",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  thickness: 1,
                                )
                              ]),
                        );
                      })
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('No Request History Found')],
                      ),
                    )),
    );
  }
}
