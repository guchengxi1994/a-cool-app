class Link {
  int? linkId;
  String? linkName;
  String? linkUrl;
  String? savedTime;
  String? thumvnailUrl;

  Link(
      {this.linkId,
      this.linkName,
      this.linkUrl,
      this.savedTime,
      this.thumvnailUrl});

  Link.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    linkName = json['linkName'];
    linkUrl = json['linkUrl'];
    savedTime = json['savedTime'];
    thumvnailUrl = json['thumvnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['linkId'] = linkId;
    data['linkName'] = linkName;
    data['linkUrl'] = linkUrl;
    data['savedTime'] = savedTime;
    data['thumvnailUrl'] = thumvnailUrl;
    return data;
  }
}
