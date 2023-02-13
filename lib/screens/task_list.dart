// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/create_task.dart';
import 'dart:developer' as dev;
import 'package:rive/rive.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({
    super.key,
  });

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void _onTaskCompleted(int index, Task task, Animation animation) {
    dev.log('Task with id ${task.id} complete callback');
    _listKey.currentState!.removeItem(
        index,
        (context, animation) =>
            _buildItem(context.watch<TaskState>(), index, task, animation));
  }

  Widget _buildItem(
      TaskState state, int index, Task task, Animation animation) {
    dev.log('$task is being built');
    final myTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );
    return SlideTransition(
      position: animation.drive(myTween),
      child: Dismissible(
        onDismissed: (dismisDirection) {
          dev.log('tile was dismissed');
          state.deteleTask(task);
        },
        key: GlobalKey(),
        background: Container(
          color: Colors.red,
          child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete),
              )),
        ),
        child: TodoTile(
          task,
          onCompleted: () => _onTaskCompleted(index, task, animation),
        ),
      ),
    );
  }

  List<Task> filterTaskToDisplay(List<Task> tasks) {
    return tasks
        .where((task) => !task.completed && task.ancestorTaskId == null)
        .toList();
  }

  final _emptyTaskList = Center(
      key: const Key('emptyTaskListWidget'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const SizedBox(
            width: 200,
            height: 200,
            child: RiveAnimation.asset('assets/animations/happy-chic.riv'),
          ),
          const Text('Congrats! Everything is done'),
        ],
      ));

  Widget _taskList(List<Task> tasks) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: tasks.length,
            itemBuilder: ((context, index, animation) => _buildItem(
                context.watch<TaskState>(), index, tasks[index], animation)),
          ),
        ),
      ],
    );
  }

  void _onFloatingActionButtonPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewTask()));
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      body: FutureBuilder(
          future: state.getTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }

            final List<Task> tasks = filterTaskToDisplay(snapshot.data!);
            dev.log(
                'Total of ${tasks.length} task(s) is to be loaded in the task list');
            if (tasks.isEmpty) {
              return _emptyTaskList;
            }
            return _taskList(tasks);
          }),
      floatingActionButton: FloatingActionButton(
        key: const Key('addTask'),
        onPressed: () => _onFloatingActionButtonPressed(context),
        child: const IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
