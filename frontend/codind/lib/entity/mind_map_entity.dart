enum NodePosition { left, right, center }

class MindMapNode {
  String? name;
  String? id; // uuid
  Properties? properties;
  double left = 300;
  double top = 500;
  String? fatherId;
  bool isRoot = false;
  NodePosition? postion;

  List<MindMapNode> leftChildren = [];
  List<MindMapNode> rightChildren = [];

  MindMapNode({this.name, this.id, this.properties, required this.postion});

  MindMapNode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Properties {
  String? note;
  String? color;

  Properties({this.note, this.color});

  Properties.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['color'] = color;
    return data;
  }
}

class MindMapNodeV2 {
  String? id;
  String? label;
  bool? isRoot;
  String? position;

  MindMapNodeV2({this.id, this.label, this.isRoot, this.position});

  MindMapNodeV2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    isRoot = json['isRoot'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['isRoot'] = isRoot;
    data['position'] = position;
    return data;
  }
}

class MindMapEdge {
  String? from;
  String? to;

  MindMapEdge({this.from, this.to});

  MindMapEdge.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
