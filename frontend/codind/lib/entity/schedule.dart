class Schedule {
  String? title;
  double? completion;
  List<Subject>? subject;
  // String? startTime = "";
  // String? endTime = "";

  String getStartTime() {
    var _d = _getStartTime();
    return _d.toString().split(" ")[0];
  }

  String getEndTime() {
    var _d = _getEndTime();
    return _d.toString().split(" ")[0];
  }

  Schedule({this.title, this.completion, this.subject});

  String get duation => _getDuation();

  String get comp => _getCompletion();

  String _getDuation() {
    return _getEndTime().difference(_getStartTime()).inDays.toString();
  }

  DateTime _getStartTime() {
    DateTime minDate = DateTime.parse(subject![0].from!);

    for (var s in subject!) {
      var _date = DateTime.parse(s.from!);
      if (_date.difference(minDate).isNegative) {
        minDate = _date;
      }
    }
    return minDate;
  }

  String _getCompletion() {
    double sum = 0;
    for (var s in subject!) {
      sum += s.subCompletion!;
    }
    return (((sum / subject!.length) * 100) ~/ 1).toString() + "%";
  }

  DateTime _getEndTime() {
    DateTime maxDate = DateTime.parse(subject![0].to!);

    for (var s in subject!) {
      var _date = DateTime.parse(s.to!);
      if (maxDate.difference(_date).isNegative) {
        maxDate = _date;
      }
    }
    return maxDate;
  }

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

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return (title == (other as Schedule).title) && subject == other.subject;
    }
  }

  @override
  int get hashCode => super.hashCode;
}

class Subject {
  String? subTitle;
  String? from;
  String? to;
  double? subCompletion;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return (subTitle == (other as Subject).subTitle) &&
          (from == other.from) &&
          (to == other.to) &&
          (subCompletion == other.subCompletion);
    }
  }

  bool validate() {
    if (subTitle == null || subTitle == "") {
      return false;
    }

    if (from == "未输入" || to == "未输入") {
      return false;
    }

    return true;
  }

  Subject({this.subTitle, this.from, this.to, this.subCompletion});

  Subject.fromJson(Map<String, dynamic> json) {
    subTitle = json['subTitle'];
    from = json['from'];
    to = json['to'];
    subCompletion = json['subCompletion'];
  }

  int get fromDay => _getStartTime().day;
  int get toDay => _getEndTime().day;

  String get duation => _getDuation();

  String _getDuation() {
    return _getEndTime().difference(_getStartTime()).inDays.toString();
  }

  DateTime _getEndTime() {
    DateTime maxDate = DateTime.parse(to!);
    return maxDate;
  }

  DateTime _getStartTime() {
    DateTime minDate = DateTime.parse(from!);
    return minDate;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subTitle'] = subTitle;
    data['from'] = from;
    data['to'] = to;
    data['subCompletion'] = subCompletion;
    return data;
  }

  @override
  int get hashCode => super.hashCode;
}
