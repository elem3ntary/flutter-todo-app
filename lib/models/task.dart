class Task {
  int? id;
  bool completed;
  String name;
  String? description;
  int? ancestorTaskId;
  int? subtaskIndex;

  Duration time = const Duration(seconds: 0);
  int progressTabsCount;
  late final List<bool> _progress;
  final List<String> _feelings = [];

  Task(this.name,
      {this.description,
      this.progressTabsCount = 3,
      this.id,
      this.completed = false,
      this.ancestorTaskId,
      this.subtaskIndex}) {
    _progress = [for (var i = 0; i < progressTabsCount; i++) false];
  }

  bool get persisted => id != null;

  List<bool> getProgres() {
    return _progress;
  }

  List<String> getFeelings() {
    return _feelings;
  }

  void setProgressUpTo(int index) {
    for (var i = 0; i < progressTabsCount; i++) {
      if (i <= index) {
        _progress[i] = true;
      } else {
        _progress[i] = false;
      }
    }
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
