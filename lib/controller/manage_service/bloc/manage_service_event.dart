part of 'manage_service_bloc.dart';

@immutable
sealed class ManageServiceEvent {}

class GetServiceEvent extends ManageServiceEvent {}

class UpdateServiceEvent extends ManageServiceEvent {
  final String serviceId;
  final String roomAvailable;
  final String startDate;
  final String endDate;

  UpdateServiceEvent(
      this.serviceId, this.roomAvailable, this.startDate, this.endDate);
}
