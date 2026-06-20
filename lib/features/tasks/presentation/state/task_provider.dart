import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

enum TaskState { initial, loading, loaded, error }

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskState _state = TaskState.initial;
  TaskState get state => _state;

  List<TaskEntity> _tasks = [];
  List<TaskEntity> get tasks => _tasks;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  TaskProvider({required this.repository});

  Future<void> fetchTasks() async {
    _state = TaskState.loading;
    notifyListeners();

    try {
      _tasks = await repository.getTasks();
      _state = TaskState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = TaskState.error;
    }
    notifyListeners();
  }

  Future<void> updateStatus(int id, String currentStatus) async {
    final newStatus = currentStatus == 'Pending' ? 'Done' : 'Pending';
    try {
      await repository.updateTaskStatus(id, newStatus);
      await fetchTasks(); // Refresh list
    } catch (e) {
      _errorMessage = 'Gagal update: ${e.toString()}';
      notifyListeners();
    }
  }
}