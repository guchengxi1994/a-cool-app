class Schedule {
  String? title;
  double? completion;
  List<Subject>? subject;

  Schedule({this.title, this.completion, this.subject});

  Schedule.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    completion = json['completion'];
    if (json['subject'] != null) {
      subject = <Subject>[];
      json['subject'].forEach((v) {
        subject!.add(Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['completion'] = completion;
    if (subject != null) {
      data['subject'] = subject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subject {
  String? subTitle;
  String? from;
  String? to;
  double? subCompletion;

  Subject({this.subTitle, this.from, this.to, this.subCompletion});

  Subject.fromJson(Map<String, dynamic> json) {
    subTitle = json['subTitle'];
    from = json['from'];
    to = json['to'];
    subCompletion = json['subCompletion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subTitle'] = subTitle;
    data['from'] = from;
    data['to'] = to;
    data['subCompletion'] = subCompletion;
    return data;
  }
}
