class KnowledgeEntity {
  String? time;
  String? title;
  String? detail;
  String? summary;
  String? fromUrlOrOthers;
  String? tag;
  String? codes;
  String? codeStyle;
  List<String>? imgs;

  KnowledgeEntity(
      {this.time,
      this.title,
      this.detail,
      this.summary,
      this.fromUrlOrOthers,
      this.tag,
      this.codes,
      this.codeStyle,
      this.imgs});

  KnowledgeEntity.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    title = json['title'];
    detail = json['detail'];
    summary = json['summary'];
    fromUrlOrOthers = json['fromUrlOrOthers'];
    tag = json['tag'];
    codes = json['codes'];
    codeStyle = json['codeStyle'];
    imgs = json['imgs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['title'] = title;
    data['detail'] = detail;
    data['summary'] = summary;
    data['fromUrlOrOthers'] = fromUrlOrOthers;
    data['tag'] = tag;
    data['codes'] = codes;
    data['codeStyle'] = codeStyle;
    data['imgs'] = imgs;
    return data;
  }
}
