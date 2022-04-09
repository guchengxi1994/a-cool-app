part of 'mind_map_bloc.dart';

enum MindMapStatus {
  initial,
  addNode,
  removeNode,
}

class MindMapState extends Equatable {
  final MindMapStatus status;
  final List<MindMapNodeV2> mindMapNodes;
  final List<MindMapEdge> edges;
  final Map<String, dynamic> data;

  const MindMapState({
    this.status = MindMapStatus.initial,
    this.mindMapNodes = const [],
    this.edges = const [],
    this.data = const {"nodes": [], "edges": []},
  });

  // void getJson() {
  //   var res = <String, dynamic>{};

  //   res["nodes"] = [];
  //   res["edges"] = [];

  //   for (var i in edges) {
  //     res["edges"].add(i.toJson());
  //   }

  //   for (var i in mindMapNodes) {
  //     res["nodes"].add(i.toJson());
  //   }

  //   data = res;
  // }

  @override
  List<Object> get props => [status, mindMapNodes, edges, data];

  MindMapState copyWith(
      MindMapStatus? status,
      List<MindMapNodeV2>? mindMapNodes,
      List<MindMapEdge>? edges,
      Map<String, dynamic>? data) {
    return MindMapState(
        status: status ?? this.status,
        mindMapNodes: mindMapNodes ?? this.mindMapNodes,
        edges: edges ?? this.edges,
        data: data ?? this.data);
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
