import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_player_id_event.dart';
part 'update_player_id_state.dart';

class UpdatePlayerIdBloc extends Bloc<UpdatePlayerIdEvent, UpdatePlayerIdState> {
  UpdatePlayerIdBloc() : super(UpdatePlayerIdInitial()) {
    on<UpdatePlayerIdEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
