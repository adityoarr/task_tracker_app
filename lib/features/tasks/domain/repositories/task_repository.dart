import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity> addTask(String title, String description);
  Future<void> updateTaskStatus(int id, String status);
}