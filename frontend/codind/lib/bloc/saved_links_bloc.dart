import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../entity/entity.dart' as my_entity;

part 'saved_links_event.dart';
part 'saved_links_state.dart';

class SavedLinksBloc extends Bloc<SavedLinksEvent, SavedLinksState> {
  SavedLinksBloc() : super(const SavedLinksState()) {
    on<InitialSavedLinksEvent>(_fetchToState);
  }

  Future<void> _fetchToState(
      InitialSavedLinksEvent event, Emitter<SavedLinksState> emit) async {
    emit(state.copyWith(SavedLinksStatus.initial, []));
  }
}
