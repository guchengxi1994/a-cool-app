class MindMapNode {
  String? name;
  String? id; // uuid
  Properties? properties;
  double left = 300;
  double top = 500;
  List<MindMapNode> children = [];

  MindMapNode({this.name, this.id, this.properties});

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
