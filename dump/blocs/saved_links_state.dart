part of 'saved_links_bloc.dart';

enum SavedLinksStatus { initial, add, remove }

class SavedLinksState extends Equatable {
  final SavedLinksStatus savedLinksStatus;
  final List<my_entity.Link> links;

  const SavedLinksState(
      {this.savedLinksStatus = SavedLinksStatus.initial,
      this.links = const []});

  @override
  List<Object> get props => [savedLinksStatus, links];

  SavedLinksState copyWith(
      SavedLinksStatus? savedLinksStatus, List<my_entity.Link>? links) {
    return SavedLinksState(
        savedLinksStatus: savedLinksStatus ?? this.savedLinksStatus,
        links: links ?? this.links);
  }
}
