import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ePaunaLite/Views/app_data/colors.dart';
import 'package:ePaunaLite/Views/components/buttons.dart';
import 'package:ePaunaLite/controller/manage_service/bloc/manage_service_bloc.dart';

import '../../Utils/constants.dart';

class ManageService extends StatefulWidget {
  const ManageService({super.key});

  @override
  State<ManageService> createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService> {
  bool startDateSelected = false;
  bool endDateSelected = false;
  ScrollController scrollController = ScrollController();
  DateTime startDate = DateTime.now().toLocal();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController roomAvailableController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String serviceId = '';
  int selectedContainerIndex = -1;
  void _selectStartDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2300),
    );
    if (selectedDate != null) {
      setState(() {
        startDateSelected = true;
        startDate = selectedDate;
        startDateController.text = dateFormatter.format(startDate);
      });
    }
  }

  void _selectEndDate() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2300));
    if (selectedDate != null) {
      setState(() {
        endDateSelected = true;
        endDate = selectedDate;
        endDateController.text = dateFormatter.format(endDate);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    startDateController.text = dateFormatter.format(startDate);
    endDateController.text = dateFormatter.format(endDate);
    BlocProvider.of<ManageServiceBloc>(context).add(GetServiceEvent());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: whiteColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: blackColor,
            ),
          ),
        ),
        body: BlocBuilder<ManageServiceBloc, ManageServiceState>(
          builder: (context, state) {
            if (state is GetServiceLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is GetServiceLoaded) {
              return SingleChildScrollView(
                controller: scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Room Type: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              '(Select One)',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.serviceModel.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  selectedContainerIndex == index;
                              //     selectedContainerIndex =0;
                              // serviceId =
                              //           state.serviceModel[0].serviceId;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedContainerIndex =
                                          index; // Update the selected index
                                    });
                                    serviceId =
                                        state.serviceModel[index].serviceId;
                                  },
                                  child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      // height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          width: selectedContainerIndex == index
                                              ? 2
                                              : 2,
                                          color: selectedContainerIndex == index
                                              ? Colors
                                                  .green // Change the color when selected
                                              : Color.fromARGB(
                                                  255, 202, 201, 201),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.hotel,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${state.serviceModel[index].serviceTitle}  ${state.serviceModel[index].serviceSubTitle}',
                                                  ),
                                                  Text(
                                                    'Room Available: ${state.serviceModel[index].inCount}',
                                                  ),
                                                  Text(
                                                      'Start Date: ${state.serviceModel[index].startDate}'),
                                                  Text(
                                                      'End Date: ${state.serviceModel[index].endDate}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Room Available:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          onTap: () {
                            const double scrollToPosition =
                                60.0 * (3 - 1); // Adjust this value as needed
                            scrollController.animateTo(
                              scrollToPosition,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          controller: roomAvailableController,
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter room available';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: '0',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, right: 5),
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            greyColor), // Change the border color here
                                    borderRadius: BorderRadius.circular(
                                        10.0), // You can adjust the border radius as well
                                  ),
                                  child: TextField(
                                    readOnly: true,
                                    controller: startDateController,
                                    decoration: const InputDecoration(
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.center,
                                      hintText: "Check In",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.calendar_month_outlined,
                                      ),
                                    ),
                                    onTap: _selectStartDate,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, right: 5),
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            greyColor), // Change the border color here
                                    borderRadius: BorderRadius.circular(
                                        10.0), // You can adjust the border radius as well
                                  ),
                                  child: TextField(
                                    readOnly: true,
                                    controller: endDateController,
                                    decoration: const InputDecoration(
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.center,
                                      hintText: 'Check Out',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.calendar_month_outlined,
                                      ),
                                    ),
                                    onTap: _selectEndDate,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomButton(
                          onpressed: () {
                            try {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<ManageServiceBloc>(context).add(
                                  UpdateServiceEvent(
                                    state.serviceModel[selectedContainerIndex]
                                        .serviceId,
                                    roomAvailableController.text,
                                    startDate.toString(),
                                    endDate.toString(),
                                  ),
                                );
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "Please select a room type",
                                toastLength: Toast
                                    .LENGTH_SHORT, // Duration for which the toast is visible
                                gravity: ToastGravity.BOTTOM, // Toast gravity
                                timeInSecForIosWeb:
                                    1, // Time for iOS-specific customization
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          label: "SUBMIT",
                          width: MediaQuery.of(context).size.width,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
