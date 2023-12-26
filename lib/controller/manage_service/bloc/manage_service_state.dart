part of 'manage_service_bloc.dart';

@immutable
sealed class ManageServiceState {}

final class ManageServiceInitial extends ManageServiceState {}

class GetServiceLoading extends ManageServiceState {}

class GetServiceLoaded extends ManageServiceState {
  final List<ServiceModel> serviceModel;

  GetServiceLoaded(this.serviceModel);
}

class UpdateServiceLoading extends ManageServiceState {}

class UpdateServiceLoaded extends ManageServiceState {
  final StatusModel statusModel;

  UpdateServiceLoaded(this.statusModel);
}
