import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:ePaunaLite/Utils/colors.dart';
import 'package:ePaunaLite/controller/manage_service/repository/get_service_repository.dart';

import '../model/services_model.dart';
import '../model/status_model.dart';
import '../repository/update_service_repository.dart';

part 'manage_service_event.dart';
part 'manage_service_state.dart';

class ManageServiceBloc extends Bloc<ManageServiceEvent, ManageServiceState> {
  ManageServiceBloc() : super(ManageServiceInitial()) {
    on<GetServiceEvent>((event, emit) async {
      GetServiceRepository getServiceRepository = GetServiceRepository();
      emit(GetServiceLoading());
      List<ServiceModel> serviceModel =
          await getServiceRepository.getServices();
      emit(GetServiceLoaded(serviceModel));
    });

    on<UpdateServiceEvent>((event, emit) async {
      UpdateServiceRepository updateServiceRepository =
          UpdateServiceRepository();
      emit(UpdateServiceLoading());
      StatusModel statusModel = await updateServiceRepository.updateService(
        event.serviceId,
        event.roomAvailable,
        event.startDate,
        event.endDate,
      );

      if (statusModel.status == true) {
        Fluttertoast.showToast(
            msg: statusModel.update!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: PrimaryColors.primarygreen,
            textColor: const Color(0xffffffff),
            fontSize: 16.0);
        emit(UpdateServiceLoaded(statusModel));
        BlocProvider.of<ManageServiceBloc>(Get.context!).add(GetServiceEvent());
      } else {
        Fluttertoast.showToast(
          msg: statusModel.update!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: PrimaryColors.primarygreen,
          textColor: const Color(0xffffffff),
          fontSize: 16.0,
        );
        emit(UpdateServiceLoaded(statusModel));
      }
    });
  }
}
