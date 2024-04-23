import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/task_provider.dart';
import 'package:task_app/screens/home_page.dart';
import 'package:task_app/screens/task_detail_page.dart';
import 'package:task_app/screens/task_list_page.dart';
import 'package:task_app/screens/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Establece la pantalla de inicio de sesión como la ruta inicial
      routes: {
        '/login': (context) => const LoginPage(), // Agrega la ruta para la pantalla de inicio de sesión
        '/home': (context) => const HomePage(), // Agrega la ruta para la página principal
        '/task-list': (context) => const TaskListPage(),
        '/task-detail': (context) => const TaskDetailPage(),
      },
    );
  }
}
