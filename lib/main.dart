import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/create_task.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/task_list.dart';
import 'package:todo_app/screens/zenmode.dart';

import 'state/task_state.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var defaultColorScheme = ThemeData.dark().colorScheme;
    var baseTheme = ThemeData.dark();
    var themeData = baseTheme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
      colorScheme: defaultColorScheme.copyWith(
          background: const Color(0xff304163),
          secondary: const Color(0xff516C8D)),
    );
    return MaterialApp(theme: themeData, home: const MainPage());
  }
}
