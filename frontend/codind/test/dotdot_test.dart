class Person {
  int? age;
  String? name;

  Person({this.age, this.name});

  void setAge(int a) {
    age = a;
  }

  void setName(String n) {
    name = n;
  }
}

void main() {
  Person p = Person()
    ..age = 18
    ..name = "Dart";

  print(p.age);
  print(p.name);

  Person p2 = Person()
    ..setAge(17)
    ..setName("flutter");

  /// 错误的代码
  // Person p3 = Person().setAge(19);
}
