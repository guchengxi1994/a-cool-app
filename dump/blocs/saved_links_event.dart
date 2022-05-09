part of 'saved_links_bloc.dart';

abstract class SavedLinksEvent extends Equatable {
  const SavedLinksEvent();

  @override
  List<Object> get props => [];
}

class InitialSavedLinksEvent extends SavedLinksEvent {}
