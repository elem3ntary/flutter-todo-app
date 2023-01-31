class Task {
  int? id;
  bool completed;
  String name;
  String? description;
  int? ancestorTaskId;
  int? subtaskIndex;

  List<Task>? subtasks;

  Duration time = const Duration(seconds: 0);
  final List<String> _feelings = [];
  final availableFeelings = ['😳', '😖', '😀'];

  Task(this.name,
      {this.description,
      this.id,
      this.completed = false,
      this.ancestorTaskId,
      this.subtaskIndex});

  bool get persisted => id != null;

  List<String> getFeelings() {
    return _feelings;
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
      'subtaskIndex': subtaskIndex
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(map['name'],
        description: map['description'],
        id: map['id'],
        completed: map['completed'] == 1,
        ancestorTaskId: map['ancestorTaskId'],
        subtaskIndex: map['subtaskIndex']);
  }

  @override
  String toString() {
    return 'Task(id: $id, name: $name)';
  }
}
