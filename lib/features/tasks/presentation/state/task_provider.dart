import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

enum TaskState { initial, loading, loaded, error }

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskState _state = TaskState.initial;
  TaskState get state => _state;

  final List<TaskEntity> _tasks = [];
  List<TaskEntity> get tasks => _tasks;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isFetchingMore = false;

  bool get hasMoreData => _hasMoreData;
  bool get isFetchingMore => _isFetchingMore;

  TaskProvider({required this.repository});

  Future<void> fetchTasks({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _tasks.clear();
      _state = TaskState.loading;
      notifyListeners();
    }

    if (!_hasMoreData || _isFetchingMore) return;

    if (_tasks.isNotEmpty) {
      _isFetchingMore = true;
      notifyListeners();
    }

    try {
      final newTasks = await repository.getTasks(page: _currentPage, limit: 10);

      if (newTasks.isEmpty || newTasks.length < 10) {
        _hasMoreData = false;
      }

      _tasks.addAll(newTasks);
      _currentPage++;
      _state = TaskState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      if (_tasks.isEmpty) _state = TaskState.error;
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus(int id, String currentStatus) async {
    final newStatus = currentStatus == 'Pending' ? 'Done' : 'Pending';
    try {
      await repository.updateTaskStatus(id, newStatus);

      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = TaskEntity(
          id: _tasks[index].id,
          title: _tasks[index].title,
          description: _tasks[index].description,
          status: newStatus,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal update: ${e.toString()}';
      notifyListeners();
    }
  }
}