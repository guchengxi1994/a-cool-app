part of 'mind_map_bloc.dart';

enum MindMapStatus {
  initial,
  addNode,
  removeNode,
}

class MindMapState extends Equatable {
  final MindMapStatus status;
  final List<MindMapNode> mindMapNodes;

  const MindMapState(
      {this.status = MindMapStatus.initial, this.mindMapNodes = const []});

  @override
  List<Object> get props => [status, mindMapNodes];

  MindMapState copyWith(
      MindMapStatus? status, List<MindMapNode>? mindMapNodes) {
    return MindMapState(
        status: status ?? this.status,
        mindMapNodes: mindMapNodes ?? this.mindMapNodes);
  }
}
