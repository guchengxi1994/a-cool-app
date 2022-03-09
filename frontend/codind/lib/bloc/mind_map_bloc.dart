import 'package:bloc/bloc.dart';
import 'package:codind/entity/entity.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'mind_map_event.dart';
part 'mind_map_state.dart';

class MindMapBloc extends Bloc<MindMapEvent, MindMapState> {
  var uuid = const Uuid();
  MindMapBloc() : super(const MindMapState()) {
    on<InitialMindMapEvent>(_fetchToState);
  }

  Future<void> _fetchToState(
      InitialMindMapEvent event, Emitter<MindMapState> emit) async {
    MindMapNode mindMapNode =
        MindMapNode(name: "root", id: uuid.v4(), properties: null);
    emit(state.copyWith(MindMapStatus.initial, [mindMapNode]));
  }
}
