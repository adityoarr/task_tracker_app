import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'features/tasks/domain/repositories/task_repository_impl.dart';
import 'features/tasks/presentation/pages/task_list_page.dart';
import 'features/tasks/presentation/state/task_provider.dart';

void main() {
  final taskRepository = TaskRepositoryImpl(client: http.Client());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(repository: taskRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskListPage(),
    );
  }
}