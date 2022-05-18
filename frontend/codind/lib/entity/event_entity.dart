class EventEntity {
  // title
  String todoName;
  // description
  String description;

  String startTime;
  String endTime;
  int eventStatus;

  EventEntity(
      {required this.description,
      required this.endTime,
      required this.eventStatus,
      required this.startTime,
      required this.todoName});
}
