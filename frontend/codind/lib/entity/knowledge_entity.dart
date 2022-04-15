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
}
