import 'dart:collection';

class Task {
  int? id;
  bool completed;
  String name;
  String? description;
  int? ancestorTaskId;
  int? subtaskIndex;

  List<Task>? subtasks;

  Duration time = const Duration(seconds: 0);
  String feeling;
  final availableFeelings = ['😳', '😖', '😀'];

  Task(this.name,
      {this.description,
      this.id,
      this.completed = false,
      this.ancestorTaskId,
      this.subtaskIndex,
      this.feeling = ''});

  bool get persisted => id != null;

  String getLastFeeling() {
    return feeling;
  }

  int getFeelingCount() {
    return 1;
  }

  void addFeeling(String feeling) {
    this.feeling = feeling;
  }

  String getReadableTime() {
    var seconds = '${time.inSeconds.remainder(60)}'.padLeft(2, '0');
    var minutes = '${time.inMinutes.remainder(60)}'.padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed': completed ? 1 : 0,
      'ancestorTaskId': ancestorTaskId,
      'subtaskIndex': subtaskIndex,
      'feeling': feeling
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(map['name'],
        description: map['description'],
        id: map['id'],
        completed: map['completed'] == 1,
        ancestorTaskId: map['ancestorTaskId'],
        subtaskIndex: map['subtaskIndex'],
        feeling: map['feeling'] ?? '');
  }

  @override
  String toString() {
    return 'Task(id: $id, name: $name)';
  }
}
