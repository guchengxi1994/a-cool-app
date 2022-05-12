// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:codind/entity/enums.dart';

class Schedule {
  String? title;
  double? completion;
  List<Subject>? subject;
  bool? editable = true;
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

  int get fromMonth => _getStartTime().month;
  int get fromYear => _getStartTime().year;

  int get toMonth => _getEndTime().month;
  int get toYear => _getEndTime().year;

  Schedule({this.title, this.completion, this.subject, this.editable});

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
    return "${((sum / subject!.length) * 100) ~/ 1}%";
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
    editable = json['editable'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['completion'] = completion;
    if (subject != null) {
      data['subject'] = subject!.map((v) => v.toJson()).toList();
    }
    data['editable'] = editable ?? true;
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
  int get hashCode => title.hashCode + completion.hashCode + subject.hashCode;
}

class Subject {
  String? subTitle;
  String? from;
  String? to;
  double? subCompletion;
  SubjectJob? subjectJob;
  bool? editable = true;

  @override
  String toString() {
    return jsonEncode(toJson());
  }

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

  Subject(
      {this.subTitle,
      this.from,
      this.to,
      this.subCompletion,
      this.subjectJob,
      this.editable});

  Subject.fromJson(Map<String, dynamic> json) {
    subTitle = json['subTitle'];
    from = json['from'];
    to = json['to'];
    subCompletion = json['subCompletion'];
    editable = json['editable'] ?? true;

    try {
      String job = json['job'];
      String type = job.split("__split__")[0];
      String content = job.split("__split__")[1];
      SubjectJob _subjectJob = SubjectJob();
      if (type == "string") {
        _subjectJob.subjectMdFrom = DataFrom.string;
      } else if (type == "net") {
        _subjectJob.subjectMdFrom = DataFrom.net;
      } else if (type == "asset") {
        _subjectJob.subjectMdFrom = DataFrom.asset;
      } else {
        _subjectJob.subjectMdFrom = DataFrom.file;
      }
      _subjectJob.fileLocation = content;
      subjectJob = _subjectJob;
    } catch (_) {}
  }

  int get fromDay => _getStartTime().day;
  int get toDay => _getEndTime().day;

  int get fromMonth => _getStartTime().month;
  int get fromYear => _getStartTime().year;

  int get toMonth => _getEndTime().month;
  int get toYear => _getEndTime().year;

  String get duation => _getDuation();

  String _getDuation() {
    return _getEndTime().difference(_getStartTime()).inDays.toString();
  }

  DateTime _getEndTime() {
    // print(to!);
    DateTime maxDate;
    try {
      maxDate = DateTime.parse(to!);
    } catch (_) {
      int _year = int.parse(to!.split("-")[0]);
      int _month = int.parse(to!.split("-")[1]);
      int _day = int.parse(to!.split("-")[2]);
      maxDate = DateTime(_year, _month, _day);
    }

    return maxDate;
  }

  DateTime _getStartTime() {
    DateTime minDate;

    try {
      minDate = DateTime.parse(from!);
    } catch (_) {
      // print(from);
      int _year = int.parse(from!.split("-")[0]);
      int _month = int.parse(from!.split("-")[1]);
      int _day = int.parse(from!.split("-")[2]);
      minDate = DateTime(_year, _month, _day);
    }
    return minDate;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subTitle'] = subTitle;
    data['from'] = from;
    data['to'] = to;
    data['subCompletion'] = subCompletion;
    data['editable'] = editable ?? true;
    if (subjectJob != null) {
      var s = "";
      if (subjectJob!.subjectMdFrom == DataFrom.asset) {
        s = "asset";
      } else if (subjectJob!.subjectMdFrom == DataFrom.net) {
        s = "net";
      } else if (subjectJob!.subjectMdFrom == DataFrom.file) {
        s = "file";
      } else {
        s = "string";
      }
      data['job'] = "${s}__split__${subjectJob!.fileLocation ?? ""}";
    }
    return data;
  }

  @override
  int get hashCode =>
      subTitle.hashCode + from.hashCode + to.hashCode + subCompletion.hashCode;
}

class SubjectJob {
  String? fileLocation;
  DataFrom? subjectMdFrom;

  SubjectJob({this.fileLocation, this.subjectMdFrom});
}
