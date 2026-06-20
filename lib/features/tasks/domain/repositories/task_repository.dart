import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks({int page = 1, int limit = 10});
  Future<TaskEntity> addTask(String title, String description);
  Future<void> updateTaskStatus(int id, String status);
}