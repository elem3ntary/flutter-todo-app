import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/task_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskState(),
      child: const MainApp(),
    ),
  );
}

ThemeData appThemeData() {
  final defaultColorScheme = ThemeData.dark().colorScheme;
  final baseTheme = ThemeData.dark();
  final themeData = baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    colorScheme: defaultColorScheme.copyWith(
        background: const Color(0xff304163),
        secondary: const Color(0xff516C8D)),
  );
  return themeData;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: appThemeData(), home: TaskListPage());
  }
}
