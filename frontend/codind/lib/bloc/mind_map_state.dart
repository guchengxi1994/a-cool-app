part of 'mind_map_bloc.dart';

enum MindMapStatus {
  initial,
  addNode,
  removeNode,
}

class MindMapState extends Equatable {
  final MindMapStatus status;
  final List<MindMapNode> mindMapNodes;
  final List<Widget> widgets;
  final List<GlobalKey<MindMapNodeWidgetState>> globalKeys;

  const MindMapState(
      {this.status = MindMapStatus.initial,
      this.mindMapNodes = const [],
      this.globalKeys = const [],
      this.widgets = const []});

  @override
  List<Object> get props => [status, mindMapNodes, widgets, globalKeys];

  MindMapState copyWith(
      MindMapStatus? status,
      List<MindMapNode>? mindMapNodes,
      List<Widget>? widgets,
      List<GlobalKey<MindMapNodeWidgetState>>? globalKeys) {
    return MindMapState(
        status: status ?? this.status,
        mindMapNodes: mindMapNodes ?? this.mindMapNodes,
        widgets: widgets ?? this.widgets,
        globalKeys: globalKeys ?? this.globalKeys);
  }

  @override
  bool operator ==(Object other) {
    if (status != MindMapStatus.initial) {
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
