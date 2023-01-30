import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/create_task.dart';
import '../state/task_state.dart';
import 'dart:developer' as dev;
import 'package:rive/rive.dart';

class MainPage extends StatelessWidget {
  MainPage({
    super.key,
  });

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  Widget _buildItem(int index, Task task, Animation animation) {
    dev.log('$task is being built');
    final myTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );
    return SlideTransition(
      position: animation.drive(myTween),
      child: TodoTile(
        task,
        onCompleted: () {
          dev.log('Task with id ${task.id} complete callback');
          _listKey.currentState!.removeItem(index,
              (context, animation) => _buildItem(index, task, animation));
        },
      ),
    );
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

            final List<Task> tasks =
                snapshot.data!.where((element) => !element.completed).toList();
            dev.log(
                'Total of ${tasks.length} task(s) is to be loaded in the task list');
            if (tasks.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                      width: 200,
                      height: 200,
                      child: RiveAnimation.asset(
                          'assets/animations/happy-chic.riv')),
                  const Text('Congrats! Everything is done'),
                ],
              ));
            }
            return Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: tasks.length,
                    itemBuilder: ((context, index, animation) =>
                        _buildItem(index, tasks[index], animation)),
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewTask()));
        },
        child: const IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
