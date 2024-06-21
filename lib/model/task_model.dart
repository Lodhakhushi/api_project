class TaskModel {
  String? todoId;
  String? title;
  String? subtitle;
  bool? isCompleted;
  String? priority;
  String? assignedAt;
  String? completedAt;

  TaskModel(
      {this.todoId,
      required this.title,
      required this.subtitle,
      this.isCompleted = false,
      required this.priority,
      required this.assignedAt,
      this.completedAt = ""});

  factory TaskModel.fromDoc(Map<String, dynamic> doc) {
    return TaskModel(
        todoId: doc['todoId'],
        title: doc['title'],
        subtitle: doc['subtitle'],
        isCompleted: doc['isCompleted'],
        priority: doc['priority'] ?? 'Low',
        assignedAt: doc['assignedAt'],
        completedAt: doc['completedAt']);
  }

  Map<String, dynamic> toDoc() {
    return {
      "todoId": todoId,
      "title": title,
      "subtitle": subtitle,
      "isCompleted": isCompleted,
      "priority": priority,
      "assignedAt": assignedAt,
      "completedAt": completedAt
    };
  }
}
