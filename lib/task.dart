class Task {
  bool done = false;
  String name;
  String? description;
  Duration time = const Duration(seconds: 0);
  int progressTabsCount;
  late final List<bool> _progress;
  final List<String> _feelings = [];

  Task(this.name, {this.description, this.progressTabsCount = 3}) {
    _progress = [for (var i = 0; i < progressTabsCount; i++) false];
  }

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
}
